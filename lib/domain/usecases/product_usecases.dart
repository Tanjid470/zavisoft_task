import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call() => repository.getProducts();
}

class GetProductsByCategoryUseCase {
  final ProductRepository repository;

  GetProductsByCategoryUseCase({required this.repository});

  Future<List<ProductEntity>> call(String category) =>
      repository.getProductsByCategory(category);
}

class GetCategoriesUseCase {
  final ProductRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<List<String>> call() => repository.getCategories();
}
