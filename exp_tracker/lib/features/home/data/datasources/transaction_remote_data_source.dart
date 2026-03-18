import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  TransactionRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return [];

    final querySnapshot = await firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .get();

    final transactions = querySnapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
        .toList();

    // Sort in-memory (newest first) to avoid needing a Firestore composite index
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    await firestore.collection('transactions').add(transaction.toMap(user.uid));
  }
}
