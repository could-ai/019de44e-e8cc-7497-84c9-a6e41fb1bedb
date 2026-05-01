import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/pdf_export.dart';
import '../db/database_helper.dart';
import '../models/record.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<PatientRecord> records = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshRecords();
  }

  Future refreshRecords() async {
    setState(() => isLoading = true);
    records = await DatabaseHelper.instance.readAllRecords();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard & Trends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshRecords,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
              ? const Center(child: Text('No records found.'))
              : Column(
                  children: [
                    _buildTrendsChart(),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(record.name.isNotEmpty ? record.name[0] : '?'),
                            ),
                            title: Text('${record.name} (MRN: ${record.mrn})'),
                            subtitle: Text('Date: ${record.datetime} - Age: ${record.age}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('GRACE: ${record.graceScore}'),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: () async {
                                    final file = await PdfExport.generatePdf(record);
                                    Share.shareXFiles([XFile(file.path)], text: 'Patient Record: ${record.name}');
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // View details
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).pushNamed('/add_record');
          refreshRecords();
        },
      ),
    );
  }

  Widget _buildTrendsChart() {
    if (records.isEmpty) return const SizedBox.shrink();

    // Group by month/day or simply show last N records' scores
    // For simplicity, we'll plot GRACE scores of last 7 records
    final recentRecords = records.take(7).toList().reversed.toList();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Recent GRACE Scores Trend', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: recentRecords.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.graceScore.toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
