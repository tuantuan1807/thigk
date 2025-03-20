import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  File? _newImageFile;
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>(); // ⚡ FormKey để kiểm tra dữ liệu đầu vào

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.tensanpham);
    _categoryController = TextEditingController(text: widget.product.loaisp);
    _priceController = TextEditingController(text: widget.product.gia.toString());
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return; // ⚡ Kiểm tra dữ liệu hợp lệ trước khi lưu

    setState(() {
      _isUploading = true;
    });

    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);

    final updatedProduct = ProductModel(
      idsanpham: widget.product.idsanpham,
      tensanpham: _nameController.text,
      loaisp: _categoryController.text,
      gia: double.parse(_priceController.text),
      hinhanh: widget.product.hinhanh, // ⚡ Giữ URL ảnh cũ nếu không có ảnh mới
    );

    await productViewModel.updateProduct(updatedProduct, _newImageFile);

    setState(() {
      _isUploading = false;
    });

    Navigator.pop(context); // ⚡ Quay về danh sách sản phẩm
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ⚡ Tránh lỗi tràn màn hình khi bàn phím xuất hiện
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: Text("Chi tiết sản phẩm"),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey, // ⚡ Sử dụng Form để kiểm tra dữ liệu nhập vào
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Tên sản phẩm"),
                validator: (value) => value!.isEmpty ? "Vui lòng nhập tên sản phẩm" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: "Loại sản phẩm"),
                validator: (value) => value!.isEmpty ? "Vui lòng nhập loại sản phẩm" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Giá"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Vui lòng nhập giá sản phẩm";
                  if (double.tryParse(value) == null) return "Giá phải là số hợp lệ";
                  return null;
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _newImageFile != null
                      ? Image.file(_newImageFile!, width: 150, height: 150, fit: BoxFit.cover)
                      : Image.network(widget.product.hinhanh, width: 150, height: 150, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade100),
                onPressed: _pickImage,
                child: Text("Chọn ảnh mới"),
              ),
              SizedBox(height: 20),
              _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue.shade100),
                onPressed: _updateProduct,
                child: Text("Lưu thay đổi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
