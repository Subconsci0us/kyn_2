import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Location _location = Location();

  // Configurable parameters
  double _radiusInKm = 1;
  LatLng _currentPosition = const LatLng(24.8607, 67.0011);

  // Marker collections
  final Set<Marker> _allMarkers = {};
  final Set<Marker> _displayedMarkers = {};

  static const double earthRadius = 6371.0; // Earth radius in kilometers

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      await _loadMarkers();
      await _getCurrentLocation();
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final pos = await _location.getLocation();
      if (pos.latitude != null && pos.longitude != null) {
        final currentPos = LatLng(pos.latitude!, pos.longitude!);

        setState(() {
          _currentPosition = currentPos;
          _filterMarkersByRadius();
        });

        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPos, zoom: 17.0),
          ),
        );
      }
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  void _filterMarkersByRadius() {
    final filteredMarkers = _allMarkers.where((marker) {
      final distance = _calculateDistance(_currentPosition, marker.position);
      return distance <= _radiusInKm;
    }).toSet();

    if (!setEquals(_displayedMarkers, filteredMarkers)) {
      setState(() {
        _displayedMarkers
          ..clear()
          ..addAll(filteredMarkers);
      });
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    final lat1 = point1.latitude * (math.pi / 180);
    final lon1 = point1.longitude * (math.pi / 180);
    final lat2 = point2.latitude * (math.pi / 180);
    final lon2 = point2.longitude * (math.pi / 180);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  Future<void> _loadMarkers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      for (var doc in snapshot.docs) {
        final geoPoint = doc.data()['position']['geopoint'] as GeoPoint;
        final position = LatLng(geoPoint.latitude, geoPoint.longitude);
        final title = doc.data()['title'] ?? 'Unknown';

        _addMarker(position, title);
      }

      _filterMarkersByRadius();
    } catch (e) {
      debugPrint('Marker loading error: $e');
    }
  }

  void _addMarker(LatLng position, String title) {
    final markerId = MarkerId('${position.latitude},${position.longitude}');
    final marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: title, snippet: 'Location Marker'),
    );

    _allMarkers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Maps'))),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            markers: _displayedMarkers,
            onCameraIdle: _filterMarkersByRadius,
            circles: {
              Circle(
                circleId: const CircleId("detection_radius"),
                center: _currentPosition,
                radius: _radiusInKm * 1000, // Convert km to meters
                fillColor: Colors.blue.withOpacity(0.1),
                strokeColor: Colors.blue,
                strokeWidth: 2,
              )
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 70,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text('Radius: ${_radiusInKm.toStringAsFixed(1)} km'),
                  Slider(
                    value: _radiusInKm,
                    min: 1,
                    max: 30,
                    divisions: 150,
                    label: _radiusInKm.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _radiusInKm = value;
                        _filterMarkersByRadius();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
