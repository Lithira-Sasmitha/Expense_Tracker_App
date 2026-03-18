import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      height: 300,
      color: isDarkMode ? AppColors.surfaceDark : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Weekly Spending', fontSize: 18, fontWeight: FontWeight.bold),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: _generateGroups(),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _getBottomTitles,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(enabled: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateGroups() {
    return [
      _makeGroupData(0, 5, AppColors.primary),
      _makeGroupData(1, 10, AppColors.secondary),
      _makeGroupData(2, 8, AppColors.primary),
      _makeGroupData(3, 15, AppColors.secondary),
      _makeGroupData(4, 12, AppColors.primary),
      _makeGroupData(5, 7, AppColors.secondary),
      _makeGroupData(6, 9, AppColors.primary),
    ];
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 15,
          borderRadius: BorderRadius.circular(5),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: color.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
    String text;
    switch (value.toInt()) {
      case 0: text = 'Mn'; break;
      case 1: text = 'Tu'; break;
      case 2: text = 'Wd'; break;
      case 3: text = 'Th'; break;
      case 4: text = 'Fr'; break;
      case 5: text = 'St'; break;
      case 6: text = 'Sn'; break;
      default: text = ''; break;
    }
    return SideTitleWidget(meta: meta, child: Text(text, style: style));
  }
}
