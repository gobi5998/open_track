import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this package to pubspec.yaml

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  String selectedFilter = 'Week';
  final workColor = Colors.blue;
  final leaveColor = Colors.amber;
  final overtimeColor = Colors.green;
  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double work,
    double leave,
    double overtime,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: work,
          color: workColor,
          width: 15,
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          fromY: work + betweenSpace,
          toY: work + betweenSpace + leave,
          color: leaveColor,
          width: 15,
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          fromY: work + betweenSpace + leave + betweenSpace,
          toY: work + betweenSpace + leave + betweenSpace + overtime,
          color: overtimeColor,
          width: 15,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      fontFamily: 'Poppins',
      color: Colors.grey,
    );
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return SideTitleWidget(
      meta: meta,
      child: Text(days[value.toInt()], style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Time Sheet',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter buttons
              Row(
                children: [
                  FilterButton(
                    text: 'Year',
                    isSelected: selectedFilter == 'Year',
                    onTap: () => setState(() => selectedFilter = 'Year'),
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: 'Month',
                    isSelected: selectedFilter == 'Month',
                    onTap: () => setState(() => selectedFilter = 'Month'),
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: 'Week',
                    isSelected: selectedFilter == 'Week',
                    onTap: () => setState(() => selectedFilter = 'Week'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Total Employee Working Hours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              
              // Chart
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    maxY: 24 + (betweenSpace * 3),
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 4,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 30,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: [
                      generateGroupData(0, 0, 8, 0),  // Sunday
                      generateGroupData(1, 8, 2, 1),  // Monday
                      generateGroupData(2, 5, 0, 2),  // Tuesday
                      generateGroupData(3, 8, 1, 1),  // Wednesday
                      generateGroupData(4, 3, 0, 0),  // Thursday
                      generateGroupData(5, 8, 0, 1),  // Friday
                      generateGroupData(6, 0, 8, 0),  // Saturday
                    ],
                  ),
                ),
              ),
              
              // Legend
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Work', workColor, '8h'),
                  const SizedBox(width: 24),
                  _buildLegendItem('Leave', leaveColor, '2h'),
                  const SizedBox(width: 24),
                  _buildLegendItem('Overtime', overtimeColor, '2h'),
                ],
              ),
              
              const SizedBox(height: 24),
              const Text(
                'Total Employee : 58',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              
              // Employee List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    title: const Text(
                      'Arun Kumar',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          index == 2 ? '4h' : '8h',
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String hours) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label\n$hours',
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
} 