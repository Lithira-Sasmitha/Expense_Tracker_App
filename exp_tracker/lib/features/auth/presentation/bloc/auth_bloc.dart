import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final AuthRepository authRepository; // needed to check current status synchronously if not using usecase.

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.updateProfileUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) {
      final result = authRepository.getCurrentUser();
      result.fold(
        (failure) => emit(Unauthenticated()),
        (user) {
          if (user != null) {
            emit(Authenticated(user: user));
          } else {
            emit(Unauthenticated());
          }
        },
      );
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) => emit(Authenticated(user: user)),
      );
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await registerUseCase(
        RegisterParams(email: event.email, password: event.password, name: event.name),
      );

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) => emit(Authenticated(user: user)),
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await logoutUseCase(NoParams());

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (_) => emit(Unauthenticated()),
      );
    });
    
    on<UpdateProfileEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await updateProfileUseCase(
        UpdateProfileParams(name: event.name),
      );

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) => emit(Authenticated(user: user)),
      );
    });
  }
}
