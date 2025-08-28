import 'dart:convert';

import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:http/http.dart' as http;

final String baseUrl = 'https://dummyjson.com/products';
Future<List<ProductModel>> fetchProducts() async {
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> productJson = data['products'] ?? [];
    return ProductModel.fromJsonList(productJson);
  } else {
    throw Exception("Failed to load album");
  }
}
