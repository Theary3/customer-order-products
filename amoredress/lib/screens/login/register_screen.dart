import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isHidePW = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String baseUrl = 'http://10.0.2.2:8000/api';


  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
  Uri.parse('$baseUrl/register'),
  headers: {"Content-Type": "application/json"},
  body: jsonEncode({
    'username': name.text.trim(),
    'email': email.text.trim(),
    'password': password.text,
  }),
).timeout(const Duration(seconds: 5));

print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');

final resData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        final userId = resData['customer_id'];

        await prefs.setInt('id', userId is int ? userId : int.parse(userId.toString()));

        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!'), backgroundColor: Colors.green),
        );
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(resData['error'] ?? 'Registration failed'),
    backgroundColor: Colors.red,
  ),
);

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: Please check your connection'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, 
      {bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isHidePW : false,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
  if (value == null || value.trim().isEmpty) return "Please enter your $label";
  if (label == "Name" && value.trim().length < 2) return "Name must be at least 2 characters";
  if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) return "Invalid email format";
  if (isPassword && value.length < 8) return "Password must be at least 8 characters";
  return null;
}
,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: isPassword ? IconButton(
          onPressed: () => setState(() => isHidePW = !isHidePW),
          icon: Icon(isHidePW ? Icons.visibility_off : Icons.visibility),
        ) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xff997054), width: 2),
        ),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
      ),
    );
  }

  Widget _buildSocialButton(String imagePath) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Social signup coming soon!')),
      ),
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
                  "Sign Up",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Create your account to get started",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                _buildTextField("Name", "Enter your full name", name),
                SizedBox(height: 20),
                _buildTextField("Email", "example@gmail.com", email, isEmail: true),
                SizedBox(height: 20),
                _buildTextField("Password", "********", password, isPassword: true),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff997054),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Or sign up with')),
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
                    Text("Already have an account?", style: TextStyle(color: Colors.grey, fontSize: 15)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(' Sign In', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
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

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }
}