part of 'product_model.dart';


ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String,
  image: json['image'] as String,
  category: json['category'] as String,
  rating: json['rating'] as Map<String, dynamic>,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'image': instance.image,
      'category': instance.category,
      'rating': instance.rating,
    };
