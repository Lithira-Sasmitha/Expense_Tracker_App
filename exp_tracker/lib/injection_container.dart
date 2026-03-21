import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/update_profile_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/data/datasources/transaction_remote_data_source.dart';
import 'features/home/data/repositories/transaction_repository_impl.dart';
import 'features/home/domain/repositories/transaction_repository.dart';
import 'features/home/domain/usecases/add_transaction_usecase.dart';
import 'features/home/domain/usecases/get_transactions_usecase.dart';
import 'features/home/presentation/bloc/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      updateProfileUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
    ),
  );

  // Features - Home / Transactions
  
  // Bloc
  sl.registerFactory(
    () => TransactionBloc(
      getTransactionsUseCase: sl(),
      addTransactionUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(
      firestore: sl(),
      firebaseAuth: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
