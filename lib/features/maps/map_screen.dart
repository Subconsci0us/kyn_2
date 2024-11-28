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

  Location location = new Location();

  final LatLng googlePlex = const LatLng(24.8607, 67.0011);

  // Maintain a set of markers
  final Set<Marker> _markers = {};

  // Store the current camera position
  LatLng _currentPosition = const LatLng(24.8607, 67.0011);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
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
          Positioned(
            bottom: 50,
            right: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
              onPressed: _animateToUser,
              child: const Icon(Icons.pin_drop, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker() {
    final marker = Marker(
      markerId: MarkerId(DateTime.now().toString()), // Unique marker ID
      position: _currentPosition, // Use updated camera position
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(
        title: 'Magic Marker',
        snippet: '🍄🍄🍄',
      ),
    );

    setState(() {
      _markers.add(marker); // Add the marker to the set
    });
  }

  _animateToUser() async {
    var pos = await location.getLocation();
    print(
        "Location fetched: Latitude: ${pos.latitude}, Longitude: ${pos.longitude}"); // Debug: After fetching location

    // Ensure latitude and longitude are not null
    if (pos.latitude != null && pos.longitude != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                pos.latitude!, pos.longitude!), // Use the non-nullable values
            zoom: 17.0,
          ),
        ),
      );
    } else {
      // Handle the case where location is null (log, show a message, etc.)
      print("Unable to fetch user location.");
    }
  }
}




  /* 
        markers: {
          Marker(
            markerId: const MarkerId("sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: googlePlex,
          ),
        },
        */