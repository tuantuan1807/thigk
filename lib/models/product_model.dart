class ProductModel {
  String idsanpham;
  String tensanpham;
  String loaisp;
  double gia;
  String hinhanh;

  ProductModel({
    required this.idsanpham,
    required this.tensanpham,
    required this.loaisp,
    required this.gia,
    required this.hinhanh,
  });

  Map<String, dynamic> toMap() {
    return {
      'idsanpham': idsanpham,
      'tensanpham': tensanpham,
      'loaisp': loaisp,
      'gia': gia,
      'hinhanh': hinhanh,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      idsanpham: id, // Lấy id từ Firebase key
      tensanpham: map['tensanpham'] ?? '',
      loaisp: map['loaisp'] ?? '',
      gia: (map['gia'] ?? 0).toDouble(),
      hinhanh: map['hinhanh'] ?? '',
    );
  }
}
