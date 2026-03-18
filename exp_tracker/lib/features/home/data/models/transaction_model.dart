import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.category,
    required super.type,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      category: map['category'] ?? '',
      type: map['type'] == 'income' ? TransactionType.income : TransactionType.expense,
    );
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'category': category,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'userId': userId,
    };
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      date: transaction.date,
      category: transaction.category,
      type: transaction.type,
    );
  }
}
