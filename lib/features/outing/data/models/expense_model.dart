import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    required super.id,
    required super.amount,
    required super.category,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ExpenseModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return ExpenseModel(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
class ExpenseStore {
  static final List<Map<String, dynamic>> expenses = [
    {
      'category': 'Food',
      'amount': 120,
    },
    {
      'category': 'Travel',
      'amount': 50,
    },
  ];
}