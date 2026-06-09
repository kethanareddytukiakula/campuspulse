import 'package:flutter/material.dart';
import 'package:campuspulse/features/outing/expense_store.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseAnalyticsScreen extends StatelessWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = ExpenseStore.expenses.fold<double>(
      0,
      (sum, expense) =>
          sum + (expense['amount'] as num).toDouble(),
    );

    final count = ExpenseStore.expenses.length;

    final average = count > 0 ? total / count : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Total Spending'),
                trailing: Text(
                  '₹${total.toStringAsFixed(2)}',
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                title: const Text('Average Expense'),
                trailing: Text(
                  '₹${average.toStringAsFixed(2)}',
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                title: const Text('Number of Expenses'),
                trailing: Text('$count'),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Expense Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 60,
                      title: 'Food',
                    ),
                    PieChartSectionData(
                      value: 25,
                      title: 'Travel',
                    ),
                    PieChartSectionData(
                      value: 15,
                      title: 'Shopping',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Card(
              child: ListTile(
                title: Text('Food'),
                trailing: Text('60%'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Travel'),
                trailing: const Text('25%'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Shopping'),
                trailing: const Text('15%'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}