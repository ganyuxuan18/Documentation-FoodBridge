import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'dart:math';

class VolunteerDashboard extends StatefulWidget {
  @override
  _VolunteerDashboardState createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  final CollectionReference foods = FirebaseFirestore.instance.collection('foods');

  List<Marker> markers = [];
  List<LatLng> routePoints = [];
  double totalDistanceKm = 0;
  double totalDurationMin = 0;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  void acceptPickup(String foodId) async {
    await foods.doc(foodId).update({
      'pickedUp': true,
      'status': 'in_transit',
    });
    computeRoute();
  }

  void markDelivered(String foodId, int quantity) async {
    await foods.doc(foodId).update({'status': 'delivered'});

    await FirebaseFirestore.instance
        .collection('metrics')
        .doc('summary')
        .set({
      'mealsSaved': FieldValue.increment(quantity),
      'co2Reduced': FieldValue.increment(quantity * 0.5)
    }, SetOptions(merge: true));

    computeRoute();
  }

  // Haversine formula for straight-line distance
  double haversine(LatLng p1, LatLng p2) {
    const R = 6371; // km
    double dLat = (p2.latitude - p1.latitude) * pi / 180;
    double dLng = (p2.longitude - p1.longitude) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(p1.latitude * pi / 180) *
            cos(p2.latitude * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  void computeRoute() async {
    final snapshot = await foods
    .where('pickedUp', isEqualTo: true)
    .where('status', isEqualTo: 'in_transit')
    .get();
    if (snapshot.docs.isEmpty) {
      setState(() {
        routePoints = [];
        totalDistanceKm = 0;
        totalDurationMin = 0;
      });
      return;
    }

    List<LatLng> points = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      double lat = (data['lat'] ?? 3.1466).toDouble();
      double lng = (data['lng'] ?? 101.6956).toDouble();
      return LatLng(lat, lng);
    }).toList();

    if (points.length == 1) {
      double dist = haversine(LatLng(3.1466, 101.6956), points[0]);
      setState(() {
        routePoints = points;
        totalDistanceKm = dist;
        totalDurationMin = dist / 40 * 60; // avg 40km/h
      });
      return;
    }

    String coords = points.map((p) => '${p.longitude},${p.latitude}').join(';');
    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/$coords?overview=full&geometries=geojson');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];
        setState(() {
          totalDistanceKm = (route['distance'] ?? 0) / 1000;
          totalDurationMin = (route['duration'] ?? 0) / 60;
          routePoints = (route['geometry']['coordinates'] as List)
              .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();
        });
      } else {
        double dist = haversine(points.first, points.last);
        setState(() {
          routePoints = points;
          totalDistanceKm = dist;
          totalDurationMin = dist / 40 * 60;
        });
      }
    } catch (e) {
      double dist = haversine(points.first, points.last);
      setState(() {
        routePoints = points;
        totalDistanceKm = dist;
        totalDurationMin = dist / 40 * 60;
      });
    }
  }

  Widget buildMap() {
    return StreamBuilder<QuerySnapshot>(
      stream: foods.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Center(child: Text("No data"));
        }

        markers.clear();

        for (var food in snapshot.data!.docs) {
          final data = food.data() as Map<String, dynamic>;
          bool delivered = data['status'] == 'delivered';

          if (!delivered) {
            double lat = (data['lat'] ?? 3.1466).toDouble();
            double lng = (data['lng'] ?? 101.6956).toDouble();

            markers.add(Marker(
              point: LatLng(lat, lng),
              width: 40,
              height: 40,
              child: Icon(Icons.fastfood, color: Colors.red, size: 32),
            ));
          }
        }

        return Column(
          children: [
            if (routePoints.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  "Route: ${totalDistanceKm.toStringAsFixed(2)} km | ETA: ${totalDurationMin.toStringAsFixed(0)} min",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(3.1466, 101.6956),
                  zoom: 12,
                ),
                children: [
                  TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayer(markers: markers),
                  if (routePoints.isNotEmpty)
                    PolylineLayer(polylines: [
                      Polyline(points: routePoints, strokeWidth: 6, color: Colors.blue)
                    ])
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildFoodList() {
    return StreamBuilder<QuerySnapshot>(
      stream: foods.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Center(child: Text("No foods found"));
        }

        final docs = snapshot.data!.docs;

        docs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          int aUrgency = aData['urgency'] ?? 0;
          int bUrgency = bData['urgency'] ?? 0;
          return bUrgency.compareTo(aUrgency);
        });

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final food = docs[index];
            final data = food.data() as Map<String, dynamic>;

            bool pickedUp = data['pickedUp'] ?? false;
            bool delivered = data['status'] == 'delivered';
            int urgency = data['urgency'] ?? 0;
            int quantity = data['quantity'] ?? 1;

            Color color = urgency >= 7
                ? Colors.red
                : urgency >= 4
                    ? Colors.orange
                    : Colors.green;

            // Button color logic:
            Color acceptColor = !pickedUp && !delivered ? Colors.blue : Colors.grey;
            Color deliveredColor = pickedUp && !delivered ? Colors.blue : Colors.grey;

            return Card(
              margin: EdgeInsets.all(6),
              child: ListTile(
                title: Text("${data['name'] ?? "Food"} (x$quantity)"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Urgency: $urgency / 10"),
                    LinearProgressIndicator(value: urgency / 10, color: color),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: (!pickedUp && !delivered) ? () => acceptPickup(food.id) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: acceptColor),
                      child: Text("Accept"),
                    ),
                    SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: (pickedUp && !delivered) ? () => markDelivered(food.id, quantity) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: deliveredColor),
                      child: Text("Delivered"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volunteer Dashboard"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: buildMap()),
          Expanded(flex: 3, child: buildFoodList()),
        ],
      ),
    );
  }
}