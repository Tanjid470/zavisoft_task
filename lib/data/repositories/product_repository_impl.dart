import '../../data/datasources/remote_data_source.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final models = await remoteDataSource.getProducts();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    try {
      final models = await remoteDataSource.getProductsByCategory(category);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }
}
