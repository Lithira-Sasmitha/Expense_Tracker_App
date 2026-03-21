import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    context.read<TransactionBloc>().add(GetTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          // When a transaction is added, re-fetch the list
          if (state is TransactionAdded) {
            _loadTransactions();
          }
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  AppText('Error: ${state.message}', color: AppColors.gray),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTransactions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          List<Transaction> transactions = [];
          if (state is TransactionsLoaded) {
            transactions = state.transactions;
          }

          double totalIncome = 0;
          double totalExpense = 0;

          for (var tx in transactions) {
            if (tx.type == TransactionType.income) {
              totalIncome += tx.amount;
            } else {
              totalExpense += tx.amount;
            }
          }

          double totalBalance = totalIncome - totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        String name = 'User';
                        if (authState is Authenticated) {
                          name = authState.user.name ?? 'User';
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              'Hello, $name!',
                              fontSize: 18,
                              color: isDarkMode ? Colors.white70 : AppColors.gray,
                            ),
                            const AppText(
                              'Welcome Back',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        );
                      },
                    ),
                    InkWell(
                      onTap: () => context.go(AppRouter.profile),
                      borderRadius: BorderRadius.circular(25),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.person_rounded, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                BalanceCard(
                  totalBalance: totalBalance,
                  income: totalIncome,
                  expense: totalExpense,
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

                if (transactions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: AppText('No transactions yet.', color: AppColors.gray),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(transaction: transactions[index]);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
