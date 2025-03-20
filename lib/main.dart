import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/addproduct_screen.dart'; // Thêm màn hình thêm sản phẩm

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()), // Thêm ProductViewModel
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý sản phẩm',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthChecker(), // Kiểm tra user để điều hướng
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/add_product': (context) => AddProductScreen(),
      },
    );
  }
}

// Kiểm tra user đã đăng nhập chưa
class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomeScreen(); // Nếu đã đăng nhập -> vào Home
        } else {
          return LoginScreen(); // Chưa đăng nhập -> vào Login
        }
      },
    );
  }
}
