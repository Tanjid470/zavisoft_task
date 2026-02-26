class ProductEntity {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;
  final double rating;
  final int reviewCount;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.rating,
    required this.reviewCount,
  });
}
