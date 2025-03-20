import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductViewModel extends ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("products");

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  // Fetch danh sách sản phẩm từ Firebase
  Future<void> fetchProducts() async {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _products = data.entries.map((entry) {
          return ProductModel.fromMap(Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
        notifyListeners();
      }
    });
  }

  // Thêm sản phẩm
  Future<void> addProduct(ProductModel product, File imageFile) async {
    try {
      final newId = Uuid().v4();
      final storageRef = FirebaseStorage.instance.ref().child('product_images/$newId.jpg');
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();

      final newProduct = ProductModel(
        idsanpham: newId,
        tensanpham: product.tensanpham,
        loaisp: product.loaisp,
        gia: product.gia,
        hinhanh: imageUrl,
      );

      await _dbRef.child(newId).set(newProduct.toMap());
      fetchProducts();
    } catch (e) {
      print("Lỗi khi thêm sản phẩm: $e");
    }
  }

  // Cập nhật sản phẩm
  Future<void> updateProduct(ProductModel product, File? newImage) async {
    try {
      if (newImage != null) {
        final storageRef = FirebaseStorage.instance.ref().child('product_images/${product.idsanpham}.jpg');
        await storageRef.putFile(newImage);
        final imageUrl = await storageRef.getDownloadURL();
        product.hinhanh = imageUrl;
      }

      await _dbRef.child(product.idsanpham).update(product.toMap());
      fetchProducts();
    } catch (e) {
      print("Lỗi khi cập nhật sản phẩm: $e");
    }
  }

  // 🗑 Xóa sản phẩm
  Future<void> deleteProduct(String idsanpham) async {
    try {
      // Xóa ảnh trong Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('product_images/$idsanpham.jpg');
      await storageRef.delete();

      // Xóa dữ liệu sản phẩm trong Firebase Realtime Database
      await _dbRef.child(idsanpham).remove();

      fetchProducts(); // Cập nhật danh sách sau khi xóa
    } catch (e) {
      print("Lỗi khi xóa sản phẩm: $e");
    }
  }
}
