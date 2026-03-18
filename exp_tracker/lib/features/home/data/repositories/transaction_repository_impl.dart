import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final transactions = await remoteDataSource.getTransactions();
      return Right<Failure, List<Transaction>>(transactions.cast<Transaction>());
    } catch (e) {
      return Left<Failure, List<Transaction>>(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await remoteDataSource.addTransaction(model);
      return Right<Failure, void>(null);
    } catch (e) {
      return Left<Failure, void>(ServerFailure(e.toString()));
    }
  }
}
