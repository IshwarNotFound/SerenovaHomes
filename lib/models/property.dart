class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String address;
  final String imageUrl;
  final String type; // Type with default value

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.address,
    required this.imageUrl,
    this.type = 'Apartment', // DEFAULT VALUE - FIXES NULL ERROR
  });

  Property copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    int? bedrooms,
    int? bathrooms,
    double? area,
    String? address,
    String? imageUrl,
    String? type,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
    );
  }
}
