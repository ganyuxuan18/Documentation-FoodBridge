class FoodItem {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final int urgency;
  final String status;

  FoodItem({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.urgency,
    required this.status,
  });

  factory FoodItem.fromMap(String id, Map<String, dynamic> data) {
    return FoodItem(
      id: id,
      name: data['name'],
      lat: data['lat'],
      lng: data['lng'],
      urgency: data['urgency'],
      status: data['status'],
    );
  }
}