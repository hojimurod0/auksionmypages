class Product {
  String id;
  String name;
  List images;
  String description;
  int startprice;
  int endprice;
  int rating;
  String auksiontime;

  Product({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    required this.startprice,
    required this.endprice,
    required this.rating,
    required this.auksiontime,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images: json['images'] ?? [],
      description: json['description'] ?? '',
      startprice: json['startprice'] ?? 0,
      endprice: json['endprice'] ?? 0,
      rating: json['rating'] ?? 0,
      auksiontime: json['auksiontime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'images': images,
      'description': description,
      'startprice': startprice,
      'endprice': endprice,
      'rating': rating,
      'auksiontime': auksiontime,
    };
  }
}
