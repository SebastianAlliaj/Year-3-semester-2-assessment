import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/transaction.dart';

void main() {

  test('Balance calculation works correctly', () {
    final transactions = [
      Transaction(
        title: "Income",
        amount: 100,
        isIncome: true,
        category: "Job",
        date: DateTime.now(),
      ),
      Transaction(
        title: "Expense",
        amount: 40,
        isIncome: false,
        category: "Food",
        date: DateTime.now(),
      ),
    ];

    double balance = 0;

    for (var tx in transactions) {
      balance += tx.isIncome ? tx.amount : -tx.amount;
    }

    expect(balance, 60);
  });

}