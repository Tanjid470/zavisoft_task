import '../../domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUserById(int userId);
  Future<List<UserEntity>> getAllUsers();
}
