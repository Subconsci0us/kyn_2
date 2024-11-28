import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // Detection range from the center point
  double radiusInKm = 50;

  // Field name of Cloud Firestore documents where the geohash is saved
  String field = 'position';

  // Reference to the Firestore collection
  final CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('posts');

  // Function to get GeoPoint instance from Cloud Firestore document data
  GeoPoint geopointFrom(Map<String, dynamic> data) =>
      (data['position'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

  Location location = Location();

  // Initial placeholder location
  LatLng googlePlex = const LatLng(24.8607, 67.0011);

  // Store all markers (both displayed and filtered out)
  final List<Marker> _allMarkers = [];

  // Markers currently displayed on the map
  final Set<Marker> _displayedMarkers = {};

  // Store the current camera position
  LatLng _currentPosition = const LatLng(24.8607, 67.0011);

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _getCurrentLocation(); // Fetch current location when screen loads
  }

  // Function to fetch current location and set it as the starting position
  Future<void> _getCurrentLocation() async {
    var pos = await location.getLocation();

    setState(() {
      googlePlex = LatLng(pos.latitude!, pos.longitude!);
      _currentPosition = googlePlex;
    });
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: googlePlex,
          zoom: 17.0,
        ),
      ),
    );
  }

  // Filter markers based on radius
  void _filterMarkersByRadius() {
    setState(() {
      _displayedMarkers.clear();

      for (var marker in _allMarkers) {
        // Calculate distance between current map center and marker
        double distance = _calculateDistance(
          _currentPosition.latitude,
          _currentPosition.longitude,
          marker.position.latitude,
          marker.position.longitude,
        );

        // Add marker if it's within the current radius
        if (distance <= radiusInKm) {
          _displayedMarkers.add(marker);
        }
      }
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    // Convert latitude and longitude to radians
    final double lat1Rad = lat1 * (pi / 180);
    final double lon1Rad = lon1 * (pi / 180);
    final double lat2Rad = lat2 * (pi / 180);
    final double lon2Rad = lon2 * (pi / 180);

    // Calculate the differences
    final double x = (lon2Rad - lon1Rad) * cos((lat1Rad + lat2Rad) / 2);
    final double y = (lat2Rad - lat1Rad);

    // Calculate the distance
    final double distance = sqrt(x * x + y * y) * earthRadiusKm;

    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Maps')),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: googlePlex,
              zoom: 13,
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: _displayedMarkers,
            onCameraMove: (position) {
              _currentPosition = position.target;
              _filterMarkersByRadius(); // Refilter markers when map moves
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text('Radius: ${radiusInKm.toStringAsFixed(1)} km'),
                  Slider(
                    value: radiusInKm,
                    min: 1,
                    max: 100,
                    divisions: 99,
                    label: radiusInKm.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        radiusInKm = value;
                        _filterMarkersByRadius(); // Refilter markers when slider changes
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position, String title) {
    final marker = Marker(
      markerId: MarkerId(DateTime.now().toString()), // Unique marker ID
      position: position,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: title,
        snippet: 'Location Marker',
      ),
    );

    _allMarkers.add(marker);
    _displayedMarkers.add(marker);
  }

  Future<void> _loadMarkers() async {
    // Fetch posts from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await collectionReference.get();

    for (var doc in snapshot.docs) {
      // Get GeoPoint from Firestore document
      GeoPoint geoPoint = geopointFrom(doc.data());
      LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
      String title = doc.data()['title'] ?? 'Unknown';

      // Add marker to the map
      _addMarker(position, title);
    }
  }
}
