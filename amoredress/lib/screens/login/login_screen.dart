import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHidePW = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', userId);
  }

  Future<void> _saveUserData(Map<String, dynamic> resData) async {
    final prefs = await SharedPreferences.getInstance();
    final user = resData['user'];

    await prefs.setInt('user_id', user['customer_id']);

    await prefs.setString('username', user['username']);
    await prefs.setString('email', user['email']);
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final url = Uri.parse('$baseUrl/login');
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'email': email.text.trim(),
              'password': password.text,
            }),
          )
          .timeout(const Duration(seconds: 5));
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = resData['user'];
        await saveUserId(user['customer_id']);
        await _saveUserData(resData);

        if (resData['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', resData['token']);
        }

        bool isAdminFromAPI = resData['isAdmin'] ?? false;
        String message = resData['message'] ?? 'Login successful!';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );


        Navigator.pushReplacementNamed(context, '/home');
        
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        final error = resData['error'] ?? resData['message'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${resData['message'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: Please check your connection'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back"),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 80),
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Hi! Welcome back, you've been missed",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildEmailField(),
                SizedBox(height: 20),
                _buildPasswordField(),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Forgot password feature coming soon!'),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xff997054)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff997054),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Or sign in with'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton('assets/images/apple.png'),
                    SizedBox(width: 20),
                    _buildSocialButton('assets/images/google.png'),
                    SizedBox(width: 20),
                    _buildSocialButton('assets/images/facebook.png'),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        ' Sign Up',
                        style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter your email";
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
          return "Invalid email format";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "example@gmail.com",
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xff997054), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: password,
      obscureText: isHidePW,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your password";
        }
        if (value.length < 8) {
          return "Password must be at least 8 characters";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '********',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHidePW = !isHidePW;
            });
          },
          icon: Icon(isHidePW ? Icons.visibility_off : Icons.visibility),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xff997054), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String imagePath) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Social login coming soon!')));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.asset(imagePath, width: 34, height: 34),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
