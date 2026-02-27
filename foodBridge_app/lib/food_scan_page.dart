import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FoodScanPage extends StatefulWidget {
  @override
  _FoodScanPageState createState() => _FoodScanPageState();
}

class _FoodScanPageState extends State<FoodScanPage> {
  XFile? imageFile;
  String resultText = '';
  String edibility = '';
  int urgency = 0;
  String freshness = '';
  String foodName = '';
  int quantity = 1;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = picked;
        resultText = 'Analyzing with AI...';
      });

      await analyzeFood(picked);
    }
  }

  Future<void> analyzeFood(XFile file) async {
    await Future.delayed(Duration(seconds: 2));
    Random rand = Random();

    foodName = file.name.split('.').first;
    edibility = ['Safe', 'Caution', 'Spoiled'][rand.nextInt(3)];
    urgency = rand.nextInt(10) + 1;
    freshness = ['Fresh', 'Soon Expire', 'Expired'][rand.nextInt(3)];

    setState(() {
      resultText =
          "Food: $foodName\nEdibility: $edibility\nFreshness: $freshness\nUrgency: $urgency / 10";
    });
  }

  void submitFood() {
    Navigator.pop(context, {
      'name': foodName,
      'edibility': edibility,
      'urgency': urgency,
      'freshness': freshness,
      'quantity': quantity,
    });
  }

  @override
  Widget build(BuildContext context) {
    Color urgencyColor = urgency >= 7
        ? Colors.red
        : urgency >= 4
            ? Colors.orange
            : Colors.green;

    return Scaffold(
      appBar: AppBar(title: Text("Food Scan AI")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(onPressed: pickImage, child: Text("Pick Image")),
            SizedBox(height: 20),
            if (imageFile != null)
              kIsWeb
                  ? Image.network(imageFile!.path, height: 200)
                  : Image.file(File(imageFile!.path), height: 200),
            SizedBox(height: 20),
            Text(resultText, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (urgency > 0)
              LinearProgressIndicator(value: urgency / 10, color: urgencyColor),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Quantity: "),
                Expanded(
                  child: Slider(
                    value: quantity.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        quantity = value.toInt();
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            if (imageFile != null)
              ElevatedButton(onPressed: submitFood, child: Text("Add Food to Map"))
          ],
        ),
      ),
    );
  }
}