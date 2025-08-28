import 'package:ecommerce_app/features/products/domain/entities/product_entity.dart';

class CartEntity {
  final int id;
  final List<ProductEntity> products;
  final double total;
  final int totalQuantity;
  CartEntity({
    required this.id,
    required this.products,
    required this.total,
    required this.totalQuantity,
  });
}
