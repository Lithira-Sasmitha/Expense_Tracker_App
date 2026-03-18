import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../features/home/domain/entities/transaction.dart';
import '../../../../features/home/presentation/bloc/transaction_bloc.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();

  String _selectedType = 'Expense';
  String _selectedCategory = 'Food';

  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Shopping',
    'Utility',
    'Health',
    'Education',
    'Salary',
    'Business',
    'Others',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _onSave() {
    final amountText = _amountController.text;
    final title = _titleController.text;

    if (amountText.isEmpty || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
      return;
    }

    final transaction = Transaction(
      id: '',
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: _selectedCategory,
      type: _selectedType == 'Income'
          ? TransactionType.income
          : TransactionType.expense,
    );

    context.read<TransactionBloc>().add(AddTransactionEvent(transaction));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionAdded) {
          if (!mounted) return;

          // Clear form fields
          _amountController.clear();
          _titleController.clear();
          setState(() {
            _selectedType = 'Expense';
            _selectedCategory = 'Food';
          });

          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction saved!')),
          );

          // Navigate to home tab using GoRouter (AddPage is a tab, not a pushed route)
          if (mounted) {
            context.go('/');
          }
        }

        if (state is TransactionError) {
          if (!mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: AppScaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                'Add Transaction',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 30),

              /// TYPE
              Row(
                children: [
                  _TypeToggle(
                    label: 'Expense',
                    isSelected: _selectedType == 'Expense',
                    onTap: () => setState(() => _selectedType = 'Expense'),
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 15),
                  _TypeToggle(
                    label: 'Income',
                    isSelected: _selectedType == 'Income',
                    onTap: () => setState(() => _selectedType = 'Income'),
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// AMOUNT
              Center(
                child: Column(
                  children: [
                    const AppText(
                      'Amount',
                      fontSize: 16,
                      color: AppColors.gray,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// TITLE
              const AppText('Title', fontWeight: FontWeight.bold),
              const SizedBox(height: 10),

              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'What was this for?',
                  filled: true,
                  fillColor: isDarkMode
                      ? AppColors.surfaceDark
                      : Colors.grey.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// CATEGORY
              const AppText('Category', fontWeight: FontWeight.bold),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories
                    .map(
                      (cat) => _CategoryChip(
                        label: cat,
                        isSelected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 50),

              /// BUTTON
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  return AppButton(
                    text: 'Save Transaction',
                    isLoading: state is TransactionLoading,
                    onPressed: state is TransactionLoading ? null : _onSave,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _TypeToggle({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: AppText(
              label,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDarkMode
                    ? AppColors.surfaceDark
                    : Colors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(25),
        ),
        child: AppText(
          label,
          color: isSelected
              ? Colors.white
              : (isDarkMode ? Colors.white70 : Colors.black87),
          fontSize: 13,
        ),
      ),
    );
  }
}
