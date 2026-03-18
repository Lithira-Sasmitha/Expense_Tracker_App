import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy data for initial UI check
  final List<Transaction> _dummyTransactions = [
    Transaction(
      id: '1',
      title: 'Monthly Salary',
      amount: 4500.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Salary',
      type: TransactionType.income,
    ),
    Transaction(
      id: '2',
      title: 'Grocery Shopping',
      amount: 120.50,
      date: DateTime.now(),
      category: 'Food',
      type: TransactionType.expense,
    ),
    Transaction(
      id: '3',
      title: 'Netflix Subscription',
      amount: 15.99,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Entertainment',
      type: TransactionType.expense,
    ),
    Transaction(
      id: '4',
      title: 'Freelance Work',
      amount: 800.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Bonus',
      type: TransactionType.income,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Hello, Lithira!',
                      fontSize: 18,
                      color: isDarkMode ? Colors.white70 : AppColors.gray,
                    ),
                    const AppText(
                      'Welcome Back',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person_rounded, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const BalanceCard(
              totalBalance: 5163.51,
              income: 5300.00,
              expense: 136.49,
            ),
            
            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Recent Transactions',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TextButton(
                  onPressed: () {},
                  child: const AppText('See All', color: AppColors.primary),
                ),
              ],
            ),
            
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dummyTransactions.length,
              itemBuilder: (context, index) {
                return TransactionTile(transaction: _dummyTransactions[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
