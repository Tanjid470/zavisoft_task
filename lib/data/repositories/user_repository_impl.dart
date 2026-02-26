import '../../data/datasources/remote_data_source.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> getUserById(int userId) async {
    try {
      final model = await remoteDataSource.getUserById(userId);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final models = await remoteDataSource.getAllUsers();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }
}
