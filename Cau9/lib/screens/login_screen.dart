import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/repository/user_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserRepository _userRepo = UserRepository();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final user = await _userRepo.login(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        snackBar: SnackBar(content: Text('Đăng nhập thành công!'));
        final Uri url = Uri.parse('https://google.com');
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email hoặc mật khẩu không đúng!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login - 6451071084')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}