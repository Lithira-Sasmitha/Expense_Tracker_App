import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';

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

  final List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Shopping', 'Utility', 'Health', 'Education', 'Salary', 'Business', 'Others'];

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const AppText('Add Transaction', fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 30),

            // Toggle Type
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
                  color: Colors.greenAccent,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Amount Input
            Center(
              child: Column(
                children: [
                  const AppText('Amount', fontSize: 16, color: AppColors.gray),
                  const SizedBox(height: 10),
                   TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
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

            // Title Input
            const AppText('Title', fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'What was this for?',
                filled: true,
                fillColor: isDarkMode ? AppColors.surfaceDark : Colors.grey.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Category Selection
            const AppText('Category', fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _categories.map((cat) => _CategoryChip(
                label: cat, 
                isSelected: _selectedCategory == cat,
                onTap: () => setState(() => _selectedCategory = cat),
              )).toList(),
            ),
            
            const SizedBox(height: 50),

            AppButton(
              text: 'Save Transaction',
              onPressed: () {
                // TODO: Save logic
                debugPrint('Save pressed: ${_amountController.text} for ${_titleController.text}');
              },
            ),
          ],
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
            color: isSelected ? color : color.withValues(alpha: 0.1),
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
              : (isDarkMode ? AppColors.surfaceDark : Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(25),
        ),
        child: AppText(
          label,
          color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
          fontSize: 13,
        ),
      ),
    );
  }
}
