class Expense {
  final int? id;
  final double amount;
  final String note;
  final int categoryId;

  Expense({
    this.id,
    required this.amount,
    required this.note,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'categoryId': categoryId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      note: map['note'],
      categoryId: map['categoryId'],
    );
  }
}