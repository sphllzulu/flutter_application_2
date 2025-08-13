class Venue {
  final String id;
  final String name;
  final String category;
  final String? imageUrl;
  final double distance;
  final String address;

  Venue({
    required this.id,
    required this.name,
    required this.category,
    this.imageUrl,
    required this.distance,
    required this.address,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['fsq_id'],
      name: json['name'],
      category: json['categories'][0]['name'],
      imageUrl: json['photos']?[0]?['prefix'] != null && json['photos']?[0]?['suffix'] != null
          ? '${json['photos'][0]['prefix']}original${json['photos'][0]['suffix']}'
          : null,
      distance: json['distance'] / 1000, // Convert to km
      address: json['location']['formatted_address'],
    );
  }
}