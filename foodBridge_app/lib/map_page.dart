import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  final String foodName;
  final int urgency;

  const MapPage({super.key, required this.foodName, required this.urgency});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? selectedLocation;

  void saveFood() async {
    await FirebaseFirestore.instance.collection("foods").add({
      "name": widget.foodName,
      "urgency": widget.urgency,
      "lat": selectedLocation!.latitude,
      "lng": selectedLocation!.longitude,
      "status": "available",
      "timestamp": FieldValue.serverTimestamp(),
    });

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(3.1390, 101.6869),
                zoom: 12,
              ),
              onTap: (pos) => setState(() => selectedLocation = pos),
              markers: selectedLocation == null
                  ? {}
                  : {
                      Marker(
                          markerId: const MarkerId("food"),
                          position: selectedLocation!)
                    },
            ),
          ),
          ElevatedButton(
            onPressed: selectedLocation == null ? null : saveFood,
            child: const Text("Confirm Upload"),
          )
        ],
      ),
    );
  }
}