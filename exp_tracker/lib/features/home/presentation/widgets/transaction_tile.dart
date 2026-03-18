import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isDarkMode ? AppColors.surfaceDark : Colors.white,
      borderRadius: 15,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: (transaction.type == TransactionType.income 
                  ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.type == TransactionType.income 
                  ? Icons.arrow_downward_rounded 
                  : Icons.arrow_upward_rounded,
              color: transaction.type == TransactionType.income 
                  ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  transaction.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : AppColors.textHeaderLight,
                ),
                const SizedBox(height: 4),
                AppText(
                  transaction.category,
                  fontSize: 13,
                  color: AppColors.gray,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                '${transaction.type == TransactionType.income ? '+' : '-'} \$${transaction.amount.toStringAsFixed(2)}',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: transaction.type == TransactionType.income 
                    ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 4),
              AppText(
                DateFormat('MMM dd').format(transaction.date),
                fontSize: 12,
                color: AppColors.gray,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
