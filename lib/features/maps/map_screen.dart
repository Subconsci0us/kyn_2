import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Define the coordinates for the location
  final LatLng googlePlex = const LatLng(24.8607, 67.0011);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: googlePlex,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: googlePlex,
          ),
        },
      ),
    );
  }
}
