import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/purchase/app.dart';        
import 'screens/purchase/cart_provider.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = FlutterSecureStorage();
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}
