import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addExpense(
    String userId,
    ExpenseModel expense,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .add(expense.toMap());
  }

  Future<List<ExpenseModel>> getExpenses(
    String userId,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => ExpenseModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }
}