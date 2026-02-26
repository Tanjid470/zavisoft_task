import '../../domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<List<ProductEntity>> getProductsByCategory(String category);
  Future<List<String>> getCategories();
}
