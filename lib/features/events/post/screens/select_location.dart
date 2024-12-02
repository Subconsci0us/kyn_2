import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart'; // Package to get the current location

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const SelectLocation(),
      );

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  TextEditingController searchplaceController = TextEditingController();
  List<dynamic> listOflocations = [];
  bool isLoading = false; // Track loading state
  String? errorMessage; // Track error messages

  static const String apiKey = "AIzaSyAXw9NgvWLnJCPlT3DXV-qHPc5jCs_acmw";
  static const String baseUrl = "https://maps.googleapis.com/maps/api";

  @override
  void initState() {
    super.initState();
    searchplaceController.addListener(_onChange);
  }

  void _onChange() {
    if (searchplaceController.text.isNotEmpty) {
      placeSuggestion(searchplaceController.text);
    }
  }

  Future<void> placeSuggestion(String input) async {
    String request =
        "$baseUrl/place/autocomplete/json?input=$input&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          listOflocations = data['predictions']; // Update list of predictions
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => errorMessage = "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => errorMessage = "Location permissions are denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() =>
            errorMessage = "Location permissions are permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
      GeoFirePoint geoFirePoint = GeoFirePoint(geoPoint);

      // Send the GeoFirePoint data back to the previous screen
      Navigator.pop(context, geoFirePoint.data);
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching location: $e';
      });
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  void dispose() {
    searchplaceController.removeListener(_onChange);
    searchplaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchplaceController,
              decoration: const InputDecoration(
                hintText: 'Search places...',
                prefixIcon: Icon(Icons.search),
              ),
            ),

            // Show the current location button if search bar is empty
            if (searchplaceController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: _getCurrentLocation,
                  child: isLoading
                      ? const CircularProgressIndicator() // Show loading spinner
                      : const Text('Get Current Location'),
                ),
              ),

            // Show error message if any
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Display the suggestions list
            Expanded(
              child: ListView.builder(
                itemCount: listOflocations.length,
                itemBuilder: (context, index) {
                  var location = listOflocations[index];
                  return GestureDetector(
                    onTap: () async {
                      var selectedLocation =
                          await fetchPlaceDetails(location['place_id']);

                      if (selectedLocation != null) {
                        GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(
                          selectedLocation['latitude'],
                          selectedLocation['longitude'],
                        ));

                        Navigator.pop(context, geoFirePoint.data);
                      } else {
                        print("Selected location details not found.");
                      }
                    },
                    child: ListTile(
                      title: Text(location["description"]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
    String request = "$baseUrl/place/details/json?placeid=$placeId&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var locationDetails = data['result'];
        var location = locationDetails['geometry']['location'];

        if (location != null) {
          return {
            'latitude': location['lat'],
            'longitude': location['lng'],
          };
        } else {
          print("Location details not found.");
          return null;
        }
      } else {
        print("Error fetching place details: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }
}
