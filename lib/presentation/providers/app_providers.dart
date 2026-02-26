import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/http_client.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/product_usecases.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/product_entity.dart';


final httpClientProvider = Provider((ref) => LoggingHttpClient());

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSourceImpl(client: ref.watch(httpClientProvider));
});


final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
  );
});

final getProductsUseCaseProvider = Provider((ref) {
  return GetProductsUseCase(repository: ref.watch(productRepositoryProvider));
});

final getProductsByCategoryUseCaseProvider = Provider((ref) {
  return GetProductsByCategoryUseCase(
    repository: ref.watch(productRepositoryProvider),
  );
});

final getCategoriesUseCaseProvider = Provider((ref) {
  return GetCategoriesUseCase(repository: ref.watch(productRepositoryProvider));
});

final getUserByIdUseCaseProvider = Provider((ref) {
  return GetUserByIdUseCase(repository: ref.watch(userRepositoryProvider));
});

final getAllUsersUseCaseProvider = Provider((ref) {
  return GetAllUsersUseCase(repository: ref.watch(userRepositoryProvider));
});


final selectedUserIdProvider = StateProvider<int?>((ref) => null);

final currentUserProvider = StateProvider<UserModel?>((ref) => null);


final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  final useCase = ref.watch(getAllUsersUseCaseProvider);
  final entities = await useCase(); // List<UserEntity>
  return entities.map((e) => UserModel.fromEntity(e)).toList();
});

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
