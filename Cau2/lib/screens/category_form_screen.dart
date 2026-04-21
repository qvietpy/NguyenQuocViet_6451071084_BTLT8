import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _controller = TextEditingController();
  final _categoryController = CategoryController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    await _categoryController.addCategory(_controller.text.trim());

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category - 6451071084'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Tên danh mục',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên danh mục';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  child: const Text('Lưu danh mục'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}