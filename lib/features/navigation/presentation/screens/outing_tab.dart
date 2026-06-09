import 'package:flutter/material.dart';
import 'package:campuspulse/features/outing/presentation/screens/add_expense_screen.dart';
import 'package:campuspulse/features/outing/presentation/screens/expense_analytics_screen.dart';
import 'package:campuspulse/features/outing/expense_store.dart';

class OutingTab extends StatelessWidget {
  const OutingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Tracker',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                title: const Text('Total Spending'),
                subtitle: Text(
                  '₹${ExpenseStore.expenses.fold<double>(
                    0,
                    (sum, item) => sum + (item['amount'] as num).toDouble(),
                  )}',
                ),
                trailing: const Icon(
                  Icons.account_balance_wallet,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddExpenseScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Expense'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExpenseAnalyticsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.pie_chart),
                label: const Text('View Analytics'),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Recent Expenses',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: ExpenseStore.expenses.map((expense) {
                  return ListTile(
                    title: Text(expense['category']),
                    trailing: Text(
                      '₹${expense['amount']}',
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}