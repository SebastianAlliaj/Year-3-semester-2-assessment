import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/transaction.dart';

void main() {

  test('Transaction object stores correct values', () {
    final tx = Transaction(
      title: "Test",
      amount: 50,
      isIncome: true,
      category: "Job",
      date: DateTime.now(),
    );

    expect(tx.title, "Test");
    expect(tx.amount, 50);
    expect(tx.isIncome, true);
  });

}