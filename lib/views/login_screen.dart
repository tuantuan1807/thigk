import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thigk/views/register_screen.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // ⚡ Tránh lỗi tràn màn hình khi bàn phím xuất hiện
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView( // ⚡ Thêm cuộn nếu nội dung quá dài
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/gky.jpg',
                height: 120,
              ),
              SizedBox(height: 24),
              Text(
                "Chào mừng trở lại!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Đăng nhập để tiếp tục",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 32),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress, // ⚡ Đặt bàn phím phù hợp
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    String? error = await authVM.login(emailController.text, passwordController.text);
                    if (error == null) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error), backgroundColor: Colors.red),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Đăng nhập", style: TextStyle(fontSize: 18, color: Colors.blue)),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chưa có tài khoản?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                    },
                    child: Text("Đăng ký"),
                  ),
                ],
              ),
              SizedBox(height: 20), // ⚡ Thêm khoảng trống để tránh tràn khi bàn phím xuất hiện
            ],
          ),
        ),
      ),
    );
  }
}
