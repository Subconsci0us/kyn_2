import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kyn_2/features/events/post/widget/post_card.dart';
import 'package:kyn_2/models/post_model.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Location _location = Location();

  double _radiusInKm = 0.2;
  LatLng _currentPosition = const LatLng(24.8607, 67.0011);

  final List<Marker> _allMarkers = [];
  final Set<Marker> _displayedMarkers = {};
  Post? _selectedPost; // To store the currently selected post

  BitmapDescriptor? emergencyIcon;
  BitmapDescriptor? eventIcon;
  BitmapDescriptor? businessIcon;
  BitmapDescriptor? servicesIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers(); // Load the custom markers
    _initializeMap();
  }

  // Load custom marker icons for each category
  Future<void> _loadCustomMarkers() async {
    emergencyIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(
        devicePixelRatio: 2,
      ),
      'assets/images/emergency.png',
    );
    eventIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 2),
      'assets/images/event.png',
    );
    businessIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 2),
      'assets/images/business.png',
    );
    servicesIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 2),
      'assets/images/service.png',
    );
  }

  // Get the correct marker icon based on the post category
  BitmapDescriptor _getCategoryIcon(Category category) {
    switch (category) {
      case Category.Emergency:
        return emergencyIcon!;
      case Category.Event:
        return eventIcon!;
      case Category.Business:
        return businessIcon!;
      case Category.Services:
        return servicesIcon!;
    }
  }

  // Initialize the map and get the current location
  Future<void> _initializeMap() async {
    await _loadMarkers();
    await _getCurrentLocation();
  }

  // Get the current location of the user
  Future<void> _getCurrentLocation() async {
    try {
      final pos = await _location.getLocation();
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
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  // Filter markers by radius
  void _filterMarkersByRadius() {
    setState(() {
      _displayedMarkers.clear();
      _displayedMarkers.addAll(_allMarkers.where((marker) {
        final distance = _calculateDistance(_currentPosition, marker.position);
        return distance <= _radiusInKm;
      }));
    });
  }

  // Calculate distance between two points
  double _calculateDistance(LatLng point1, LatLng point2) {
    const earthRadius = 6371.0;
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

  // Load markers from Firestore
  Future<void> _loadMarkers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      for (var doc in snapshot.docs) {
        final geoPoint = doc.data()['position']['geopoint'] as GeoPoint;
        final position = LatLng(geoPoint.latitude, geoPoint.longitude);
        final post = Post.fromMap(doc.data());
        _addMarker(position, post.title, post);
      }

      _filterMarkersByRadius();
    } catch (e) {
      debugPrint('Marker loading error: $e');
    }
  }

  // Add a marker to the map
  void _addMarker(LatLng position, String title, Post post) {
    final markerIcon = _getCategoryIcon(post.category);

    final marker = Marker(
      markerId: MarkerId(UniqueKey().toString()),
      position: position,
      icon: markerIcon,
      infoWindow: InfoWindow(title: title),
      onTap: () {
        setState(() {
          _selectedPost = post;
        });
      },
    );

    _allMarkers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Around you'))),
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
            circles: {
              Circle(
                circleId: const CircleId("detection_radius"),
                center: _currentPosition,
                radius: _radiusInKm * 1000,
                fillColor: Colors.blue.withOpacity(0.1),
                strokeColor: Colors.blue,
                strokeWidth: 2,
              )
            },
            onTap: (LatLng position) {
              setState(() {
                _selectedPost =
                    null; // Deselect the post card when the map is tapped
              });
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
                    value: _radiusInKm.clamp(
                        1.0, 30.0), // Ensure the value is within bounds
                    min: 1.0,
                    max: 30.0, // Update the max value here
                    divisions: 100, // Adjust based on the new range
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
          if (_selectedPost != null)
            Positioned(
              bottom: 55,
              left: 35,
              right: 35,
              child: PostCard(post: _selectedPost!), // Display the PostCard
            ),
        ],
      ),
    );
  }
}
