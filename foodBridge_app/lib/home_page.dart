import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'food_scan_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController foodController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final CollectionReference foods =
      FirebaseFirestore.instance.collection('foods');

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  // 🔥 Small PJ compact zone (max ~5km spread)
  LatLng randomPJLocation() {
    Random rand = Random();
    double lat = 3.095 + rand.nextDouble() * (3.110 - 3.095);
    double lng = 101.635 + rand.nextDouble() * (101.655 - 101.635);
    return LatLng(lat, lng);
  }

  void loadMarkers() async {
    final snapshot = await foods
        .where('donorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      markers = snapshot.docs.map((food) {
        final data = food.data() as Map<String, dynamic>;

        double lat = (data['lat']).toDouble();
        double lng = (data['lng']).toDouble();

        int urgency = data['urgency'] ?? 5;

        Color color = urgency >= 7
            ? Colors.red
            : urgency >= 4
                ? Colors.orange
                : Colors.green;

        return Marker(
          point: LatLng(lat, lng),
          width: 30,
          height: 30,
          child: Icon(Icons.fastfood, color: color, size: 30),
        );
      }).toList();
    });
  }

  void addFoodManually() async {
    String foodName = foodController.text.trim();
    int quantity =
        int.tryParse(quantityController.text.trim()) ?? 1;

    if (foodName.isEmpty) return;

    LatLng location = randomPJLocation();

    await foods.add({
      'donorId':
          FirebaseAuth.instance.currentUser!.uid,
      'name': foodName,
      'quantity': quantity,
      'timestamp': Timestamp.now(),
      'lat': location.latitude,
      'lng': location.longitude,
      'edibility': 'Safe',
      'urgency': 5,
      'freshness': 'Fresh',
      'pickedUp': false,
      'status': 'available'
    });

    foodController.clear();
    quantityController.clear();
    loadMarkers();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  Widget buildMap() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(3.1020, 101.6450),
        zoom: 14,
      ),
      children: [
        TileLayer(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']),
        MarkerLayer(markers: markers),
      ],
    );
  }

  Widget buildFoodList() {
    return StreamBuilder<QuerySnapshot>(
      stream: foods
          .where('donorId',
              isEqualTo:
                  FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty)
          return Text("No foods uploaded yet.");

        return Column(
          children: docs.map((food) {
            final data =
                food.data() as Map<String, dynamic>;

            int urgency = data['urgency'] ?? 0;
            int quantity = data['quantity'] ?? 1;

            Color color = urgency >= 7
                ? Colors.red
                : urgency >= 4
                    ? Colors.orange
                    : Colors.green;

            return Card(
              child: ListTile(
                title: Text(
                    "${data['name']} (Qty: $quantity)"),
                subtitle: LinearProgressIndicator(
                  value: urgency / 10,
                  color: color,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodBridge AI Donor"),
        actions: [
          IconButton(
              onPressed: logout,
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: foodController,
                      decoration:
                          InputDecoration(labelText: "Food Name"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: quantityController,
                      decoration:
                          InputDecoration(labelText: "Qty"),
                      keyboardType:
                          TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addFoodManually,
                    color: Colors.green,
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final scanned =
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                FoodScanPage()));
                if (scanned != null) {
                  LatLng location =
                      randomPJLocation();

                  await foods.add({
                    'donorId':
                        FirebaseAuth.instance
                            .currentUser!
                            .uid,
                    'name': scanned['name'],
                    'quantity':
                        scanned['quantity'] ?? 1,
                    'timestamp': Timestamp.now(),
                    'lat': location.latitude,
                    'lng': location.longitude,
                    'edibility':
                        scanned['edibility'],
                    'urgency':
                        scanned['urgency'],
                    'freshness':
                        scanned['freshness'],
                    'pickedUp': false,
                    'status': 'available'
                  });

                  loadMarkers();
                }
              },
              child: Text("Scan Food with AI"),
            ),
            SizedBox(height: 300, child: buildMap()),
            Padding(
              padding: EdgeInsets.all(12),
              child: buildFoodList(),
            ),
          ],
        ),
      ),
    );
  }
}