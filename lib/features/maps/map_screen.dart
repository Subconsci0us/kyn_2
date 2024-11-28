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

  // Detection range from the center point.
  double radiusInKm = 50;

  // Field name of Cloud Firestore documents where the geohash is saved.
  String field = 'position';

  // Reference to the Firestore collection.
  final CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('posts');

  // Function to get GeoPoint instance from Cloud Firestore document data.
  GeoPoint geopointFrom(Map<String, dynamic> data) =>
      (data['position'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

  Location location = Location();

  // Initial placeholder location
  LatLng googlePlex = const LatLng(24.8607, 67.0011);

  // Maintain a set of markers
  final Set<Marker> _markers = {};

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
      googlePlex = LatLng(pos.latitude!,
          pos.longitude!); // Set the current location as the starting point
      _currentPosition = googlePlex; // Update current position
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
            markers: _markers,
            onCameraMove: (position) {
              _currentPosition = position.target; // Update current position
            },
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
      position: position, // Position from the data
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: title,
        snippet: 'Location Marker',
      ),
    );

    setState(() {
      _markers.add(marker); // Add the marker to the set
    });
  }

  Future<void> _loadMarkers() async {
    // Fetch posts from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await collectionReference.get();

    for (var doc in snapshot.docs) {
      // Get GeoPoint from Firestore document
      GeoPoint geoPoint = geopointFrom(doc.data());
      LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
      String title =
          doc.data()['title'] ?? 'Unknown'; // Title for the marker info window

      // Add marker to the map
      _addMarker(position, title);
    }
  }
}
