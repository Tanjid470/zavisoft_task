import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import 'service_provider.dart';

// Auth State
final selectedUserIdProvider = StateProvider<int?>((ref) => null);
final currentUserProvider = StateProvider((ref) => null);

// Products State
final productsProvider = FutureProvider<List<ProductEntity>>((ref) async {
  final useCase = ref.watch(getProductsUseCaseProvider);
  return useCase();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  return useCase();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final productsByCategoryProvider =
    FutureProvider.family<List<ProductEntity>, String?>((ref, category) async {
  if (category == null) {
    final useCase = ref.watch(getProductsUseCaseProvider);
    return useCase();
  }
  final useCase = ref.watch(getProductsByCategoryUseCaseProvider);
  return useCase(category);
});
