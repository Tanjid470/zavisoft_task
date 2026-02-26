import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase({required this.repository});

  Future<UserEntity> call(int userId) => repository.getUserById(userId);
}

class GetAllUsersUseCase {
  final UserRepository repository;

  GetAllUsersUseCase({required this.repository});

  Future<List<UserEntity>> call() => repository.getAllUsers();
}
