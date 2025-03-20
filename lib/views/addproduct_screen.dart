import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../models/product_model.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _imageFile != null) {
      setState(() {
        _isUploading = true; // Hiển thị trạng thái tải lên
      });

      final productViewModel = Provider.of<ProductViewModel>(context, listen: false);

      final newProduct = ProductModel(
        idsanpham: Uuid().v4(),
        tensanpham: _nameController.text,
        loaisp: _categoryController.text,
        gia: double.parse(_priceController.text),
        hinhanh: "",
      );

      await productViewModel.addProduct(newProduct, _imageFile!);

      setState(() {
        _isUploading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: Text("Thêm sản phẩm"),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Tên sản phẩm")),
            TextField(controller: _categoryController, decoration: InputDecoration(labelText: "Loại sản phẩm")),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: "Giá"), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            _imageFile != null
                ? Image.file(_imageFile!, width: 100, height: 100)
                : IconButton(icon: Icon(Icons.image), onPressed: _pickImage),
            SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator() // Hiển thị khi đang tải lên
                : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade100),
              onPressed: _addProduct,
              child: Text("Thêm sản phẩm", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
