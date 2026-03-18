import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../widgets/spending_chart.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Statistics',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Average Spending',
                  fontSize: 14,
                  color: AppColors.gray,
                ),
                TextButton(
                  onPressed: () {},
                  child: const AppText('Weekly v', color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const SpendingChart(),

            const SizedBox(height: 35),

            const AppText(
              'Top Categories',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            
            const SizedBox(height: 15),

            _CategoryItem(
              title: 'Food & Drink',
              amount: 450,
              percentage: 45,
              color: AppColors.primary,
            ),
            _CategoryItem(
              title: 'Entertainment',
              amount: 250,
              percentage: 25,
              color: AppColors.secondary,
            ),
            _CategoryItem(
              title: 'Transportation',
              amount: 300,
              percentage: 30,
              color: AppColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final double amount;
  final double percentage;
  final Color color;

  const _CategoryItem({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(title, fontWeight: FontWeight.bold),
              AppText('\$${amount.toStringAsFixed(2)}', fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.surfaceDark : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
