import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';

// Events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object> get props => [];
}

class GetTransactionsEvent extends TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final Transaction transaction;
  const AddTransactionEvent(this.transaction);
  @override
  List<Object> get props => [transaction];
}

// States
abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}
class TransactionLoading extends TransactionState {}
class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;
  const TransactionsLoaded(this.transactions);
  @override
  List<Object> get props => [transactions];
}
class TransactionAdded extends TransactionState {}
class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase getTransactionsUseCase;
  final AddTransactionUseCase addTransactionUseCase;

  TransactionBloc({
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
  }) : super(TransactionInitial()) {
    on<GetTransactionsEvent>((event, emit) async {
      debugPrint('📦 [TransactionBloc] GetTransactionsEvent fired');
      emit(TransactionLoading());
      final result = await getTransactionsUseCase(NoParams());
      result.fold(
        (failure) {
          debugPrint('❌ [TransactionBloc] GetTransactions FAILED: ${failure.message}');
          emit(TransactionError(failure.message));
        },
        (transactions) {
          debugPrint('✅ [TransactionBloc] GetTransactions SUCCESS: ${transactions.length} transactions loaded');
          emit(TransactionsLoaded(transactions));
        },
      );
    });

    on<AddTransactionEvent>((event, emit) async {
      debugPrint('📦 [TransactionBloc] AddTransactionEvent fired');
      emit(TransactionLoading());
      final result = await addTransactionUseCase(event.transaction);
      result.fold(
        (failure) {
          debugPrint('❌ [TransactionBloc] AddTransaction FAILED: ${failure.message}');
          emit(TransactionError(failure.message));
        },
        (_) {
          debugPrint('✅ [TransactionBloc] AddTransaction SUCCESS');
          emit(TransactionAdded());
          add(GetTransactionsEvent()); // Reload transactions after adding
        },
      );
    });
  }
}
