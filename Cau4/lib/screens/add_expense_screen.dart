import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../data/models/expense_model.dart';
import '../data/repository/category_repository.dart';
import '../data/repository/expense_repository.dart';

class AddExpenseScreen extends StatefulWidget {
  final int? expenseId;
  final double? initialAmount;
  final String? initialNote;
  final int? initialCategoryId;

  const AddExpenseScreen({
    super.key,
    this.expenseId,
    this.initialAmount,
    this.initialNote,
    this.initialCategoryId,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final CategoryRepository _categoryRepository = CategoryRepository();
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  List<Category> _categories = [];
  int? _selectedCategoryId;
  bool _isLoading = true;

  bool get isEdit => widget.expenseId != null;

  @override
  void initState() {
    super.initState();

    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount!.toStringAsFixed(0);
    }
    if (widget.initialNote != null) {
      _noteController.text = widget.initialNote!;
    }
    _selectedCategoryId = widget.initialCategoryId;

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryRepository.getAll();

    setState(() {
      _categories = categories;
      if (_selectedCategoryId == null && categories.isNotEmpty) {
        _selectedCategoryId = categories.first.id;
      }
      _isLoading = false;
    });
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final note = _noteController.text.trim();

    if (isEdit) {
      final expense = Expense(
        id: widget.expenseId,
        amount: amount,
        note: note,
        categoryId: _selectedCategoryId!,
      );
      await _expenseRepository.update(expense);
    } else {
      final expense = Expense(
        amount: amount,
        note: note,
        categoryId: _selectedCategoryId!,
      );
      await _expenseRepository.insert(expense);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Quản lý chi tiêu - 6451071084'
              : 'Quản lý chi tiêu - 6451071084',
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Số tiền không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập ghi chú';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  child: Text(isEdit ? 'Cập nhật' : 'Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}