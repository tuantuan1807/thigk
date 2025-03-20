import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/product_viewmodel.dart';
import 'addproduct_screen.dart';
import 'detailproduct_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userEmail = "Đang tải...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
  }

  // Lấy email người dùng hiện tại từ Firebase Authentication
  Future<void> _loadUserData() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final email = authViewModel.user?.email;
    setState(() {
      _userEmail = email ?? "Chưa đăng nhập";
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: Text("Danh sách sản phẩm"),
        backgroundColor: Colors.lightBlue.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Hiển thị email người dùng
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Email: $_userEmail", style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: Consumer<ProductViewModel>(
              builder: (context, productViewModel, child) {
                if (productViewModel.products.isEmpty) {
                  return Center(child: Text("Không có sản phẩm nào"));
                }
                return ListView.builder(
                  itemCount: productViewModel.products.length,
                  itemBuilder: (context, index) {
                    final product = productViewModel.products[index];

                    return ListTile(
                      leading: Image.network(product.hinhanh, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text("${product.tensanpham}-${product.loaisp}"),
                      subtitle: Text("Giá cả: ${product.gia} VNĐ"),
                      onTap: () {
                        // Chuyển sang trang xem chi tiết và cập nhật sản phẩm
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(productViewModel, product.idsanpham),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: CircleBorder(
          side: BorderSide(color: Colors.lightBlue.shade100, width: 2), // Viền xanh
        ),
        child: Icon(Icons.add, color: Colors.lightBlueAccent),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
      ),
    );
  }

  // Xác nhận trước khi xóa sản phẩm
  void _confirmDelete(ProductViewModel productViewModel, String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thông báo xóa sản phẩm"),
        content: Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              productViewModel.deleteProduct(productId);
              Navigator.pop(context);
            },
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
