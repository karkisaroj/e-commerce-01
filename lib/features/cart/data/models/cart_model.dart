import 'package:ecommerce_app/features/cart/domain/entities/cart_entity.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';

class CartModel {
  final int id;
  final List<ProductModel> products;
  final double total;
  final int totalQuantity;
  CartModel({
    required this.id,
    required this.products,
    required this.total,
    required this.totalQuantity,
  });
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      products: (json['products'] as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'],
      totalQuantity: json['totalQuantity'],
    );
  }
  static List<CartModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => CartModel.fromJson(item)).toList();
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      products: products.map((e) => e.toEntity()).toList(),
      total: total,
      totalQuantity: totalQuantity,
    );
  }
}
