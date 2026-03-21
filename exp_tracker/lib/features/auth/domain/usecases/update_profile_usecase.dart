import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(name: params.name);
  }
}

class UpdateProfileParams extends Equatable {
  final String name;

  const UpdateProfileParams({required this.name});

  @override
  List<Object?> get props => [name];
}
