import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../data/repository/category_repository.dart';
import '../data/repository/expense_repository.dart';
import 'add_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final ExpenseRepository _expenseRepository = ExpenseRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  List<Map<String, dynamic>> _expenses = [];
  List<Category> _categories = [];
  double _total = 0;
  bool _isLoading = true;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    final categories = await _categoryRepository.getAll();

    if (categories.isEmpty) {
      await _seedDefaultCategories();
    }

    await _loadData();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _seedDefaultCategories() async {
    await _categoryRepository.insert(
      Category(name: 'Ăn uống'),
    );
    await _categoryRepository.insert(
      Category(name: 'Đi lại'),
    );
    await _categoryRepository.insert(
      Category(name: 'Mua sắm'),
    );
    await _categoryRepository.insert(
      Category(name: 'Giải trí'),
    );
  }

  Future<void> _loadData() async {
    final categories = await _categoryRepository.getAll();
    final expenses = await _expenseRepository.getAllWithCategory(
      categoryId: _selectedCategoryId,
    );
    final total = await _expenseRepository.getTotal(
      categoryId: _selectedCategoryId,
    );

    setState(() {
      _categories = categories;
      _expenses = expenses;
      _total = total;
    });
  }

  Future<void> _openAddExpenseScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddExpenseScreen(),
      ),
    );

    if (result == true) {
      await _loadData();
    }
  }

  Future<void> _openEditExpenseScreen(Map<String, dynamic> expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          expenseId: expense['id'] as int,
          initialAmount: (expense['amount'] as num).toDouble(),
          initialNote: expense['note'] as String? ?? '',
          initialCategoryId: expense['categoryId'] as int,
        ),
      ),
    );

    if (result == true) {
      await _loadData();
    }
  }

  Future<void> _deleteExpense(int id) async {
    await _expenseRepository.delete(id);
    await _loadData();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa khoản chi'),
      ),
    );
  }

  Future<void> _confirmDelete(int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa khoản chi'),
        content: const Text('Bạn có chắc muốn xóa khoản chi này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    ) ??
        false;

    if (shouldDelete) {
      await _deleteExpense(id);
    }
  }

  String _formatMoney(double amount) {
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu - 6451071084'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<int?>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'Lọc theo danh mục',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Tất cả danh mục'),
                ),
                ..._categories.map((category) {
                  return DropdownMenuItem<int?>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }),
              ],
              onChanged: (value) async {
                setState(() {
                  _selectedCategoryId = value;
                });
                await _loadData();
              },
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Tổng tiền: ${_formatMoney(_total)} VNĐ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
              child: Text('Chưa có khoản chi nào'),
            )
                : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final item = _expenses[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      item['note'] as String? ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      item['categoryName'] as String? ?? '',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${_formatMoney((item['amount'] as num).toDouble())} VNĐ',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                _openEditExpenseScreen(item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _confirmDelete(item['id'] as int);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}