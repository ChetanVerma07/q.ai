import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CreditUsageScreen extends StatefulWidget {
  const CreditUsageScreen({super.key});

  @override
  State<CreditUsageScreen> createState() => _CreditUsageScreenState();
}

class _CreditUsageScreenState extends State<CreditUsageScreen> {
  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFF1A1A1A);
  static const Color _card2 = Color(0xFF1F1F1F);
  static const Color _accent = Color(0xFFE57373);
  static const Color _gptColor = Color(0xFFE57373);
  static const Color _geminiColor = Color(0xFF64B5F6);
  static const Color _grokColor = Color(0xFFFFB74D);
  static const Color _claudeColor = Color(0xFF81C784);
  static const Color _qseColor = Color(0xFFBA68C8);

  final List<_ModelUsage> _modelUsage = const [
    _ModelUsage('GPT', 164, _gptColor),
    _ModelUsage('Gemini', 116, _geminiColor),
    _ModelUsage('Grok', 74, _grokColor),
    _ModelUsage('Claude', 92, _claudeColor),
    _ModelUsage('QSE', 134, _qseColor),
  ];

  final List<double> _weeklySearches = const [18, 22, 16, 28, 31, 24, 35];
  final List<double> _monthlySearches = const [72, 88, 95, 110, 126, 118];

  final List<_CategoryUsage> _creditBreakdown = const [
    _CategoryUsage('Quant research', 132, Icons.query_stats),
    _CategoryUsage('Market scans', 96, Icons.candlestick_chart),
    _CategoryUsage('AI chats', 84, Icons.smart_toy),
    _CategoryUsage('Document analysis', 58, Icons.description),
    _CategoryUsage('Code queries', 44, Icons.code),
    _CategoryUsage('News search', 32, Icons.newspaper),
  ];

  final int _totalCredits = 580;
  final int _timeSavedMinutes = 1420;
  final int _adsSkipped = 286;
  final int _weeklySearchTotal = 174;
  final int _monthlySearchTotal = 609;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Credit Usage',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 72,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _overviewCard(),
            const SizedBox(height: 20),
            _sectionTitle('Usage Highlights'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    title: 'Time Saved',
                    value: '${(_timeSavedMinutes / 60).toStringAsFixed(1)} hrs',
                    subtitle: 'Through faster searches',
                    icon: Icons.timer_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    title: 'Ads Skipped',
                    value: '$_adsSkipped',
                    subtitle: 'Cleaner AI sessions',
                    icon: Icons.block,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle('Credits by Model'),
            const SizedBox(height: 12),
            _chartCard(
              title: 'AI model distribution',
              subtitle: 'Searches segmented across GPT, Gemini, Grok, Claude, and QSE',
              child: Column(
                children: [
                  SizedBox(
                    height: 240,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 52,
                        sectionsSpace: 3,
                        sections: _modelUsage
                            .map(
                              (item) => PieChartSectionData(
                            color: item.color,
                            value: item.value.toDouble(),
                            radius: 58,
                            title: '${item.value}',
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _modelUsage
                        .map((item) => _legendChip(item.label, item.color))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Weekly Searches'),
            const SizedBox(height: 12),
            _chartCard(
              title: 'Weekly activity trend',
              subtitle: 'Searches done in the last 7 days',
              child: SizedBox(
                height: 240,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 10,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white12,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white10),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 34,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                            if (value.toInt() < 0 || value.toInt() > 6) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[value.toInt()],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          _weeklySearches.length,
                              (index) => FlSpot(
                            index.toDouble(),
                            _weeklySearches[index],
                          ),
                        ),
                        isCurved: true,
                        color: _accent,
                        barWidth: 4,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: _accent,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: _accent.withOpacity(0.18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Monthly Model Usage'),
            const SizedBox(height: 12),
            _chartCard(
              title: 'Monthly searches by AI model',
              subtitle: 'Segregated comparison across major models',
              child: SizedBox(
                height: 280,
                child: BarChart(
                  BarChartData(
                    maxY: 180,
                    alignment: BarChartAlignment.spaceAround,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 30,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white10,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white10),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 34,
                          getTitlesWidget: (value, meta) {
                            const titles = [
                              'GPT',
                              'Gem',
                              'Grok',
                              'Claude',
                              'QSE'
                            ];
                            if (value.toInt() < 0 || value.toInt() > 4) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                titles[value.toInt()],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      _barGroup(0, 164, _gptColor),
                      _barGroup(1, 116, _geminiColor),
                      _barGroup(2, 74, _grokColor),
                      _barGroup(3, 92, _claudeColor),
                      _barGroup(4, 134, _qseColor),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Search Breakdown'),
            const SizedBox(height: 12),
            _cardBox(
              child: Column(
                children: _creditBreakdown
                    .map(
                      (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _breakdownTile(item),
                  ),
                )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Search Totals'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    title: 'Weekly Searches',
                    value: '$_weeklySearchTotal',
                    subtitle: 'Last 7 days',
                    icon: Icons.calendar_view_week,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    title: 'Monthly Searches',
                    value: '$_monthlySearchTotal',
                    subtitle: 'Last 30 days',
                    icon: Icons.calendar_month,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your credit intelligence',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track how you use QuantSpace credits across AI models, search types, and time saved.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _overviewStat('Total Credits Used', '$_totalCredits'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _overviewStat('Models Used', '${_modelUsage.length}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card2,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _accent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _accent, size: 22),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card2,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _cardBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _legendChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownTile(_CategoryUsage item) {
    final double percent = item.credits / _totalCredits;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: _accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${item.credits} credits',
                style: const TextStyle(
                  color: _accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(_accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _accent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 18,
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
      ],
    );
  }
}

class _ModelUsage {
  final String label;
  final int value;
  final Color color;

  const _ModelUsage(this.label, this.value, this.color);
}

class _CategoryUsage {
  final String label;
  final int credits;
  final IconData icon;

  const _CategoryUsage(this.label, this.credits, this.icon);
}