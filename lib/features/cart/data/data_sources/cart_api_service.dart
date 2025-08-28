import 'dart:convert';
import 'dart:developer';
import 'package:ecommerce_app/features/cart/data/models/cart_model.dart';
import 'package:http/http.dart' as http;

final String baseUrl = 'https://dummyjson.com/carts';

Future<List<CartModel>> fetchCarts() async {
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> cartJson = data['carts'] ?? [];
    return CartModel.fromJsonList(cartJson);
  } else {
    throw Exception("Failed to load carts");
  }
}

Future<bool> deleteCarts(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));
  log("Status code: ${response.statusCode}");
  return response.statusCode == 200;
}
