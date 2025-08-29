import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/products/data/data_sources/product_api_service.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/presentation/screens/product_screen.dart';
import 'package:ecommerce_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:ecommerce_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late Future<List<String>> _categoriesFuture;
  late Future<List<ProductModel>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
    _productsFuture = fetchProducts();
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategoryTap(String cat) {
    setState(() {
      _productsFuture = fetchProductsByCategory(cat);
    });
  }

  void _onSeeAllCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('All Categories'),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: FutureBuilder<List<String>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                separatorBuilder: (context, i) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  return Card(
                    child: ListTile(
                      title: Text(cat),
                      onTap: () {
                        if (!mounted) return;
                        Navigator.pop(context);
                        _onCategoryTap(cat);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<ProductModel>> _getSuggestions(String pattern) async {
    if (pattern.length < 2) return [];
    final all = await fetchProducts();
    return all
        .where((p) => p.title.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Widget _buildDashboardHome() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, size: 28),
                onPressed: () {},
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'Kathmandu',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/avatar.jpg',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 24,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          TypeAheadField<ProductModel>(
            controller: _searchController,
            suggestionsCallback: _getSuggestions,
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.black38),
                ),
              );
            },
            itemBuilder: (context, product) {
              return ListTile(
                leading: Image.network(
                  product.thumbnail,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                title: Text(product.title),
              );
            },
            onSelected: (product) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(product.title),
                  content: Text(product.description),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextButton(
                onPressed: _onSeeAllCategories,
                child: const Text('See all'),
              ),
            ],
          ),
          FutureBuilder<List<String>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data!;
              return SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length > 8 ? 8 : categories.length,
                  separatorBuilder: (context, i) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return GestureDetector(
                      onTap: () => _onCategoryTap(cat),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 22,
                            child: Text(cat[0].toUpperCase()),
                          ),
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              cat,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final products = snapshot.data!;
                if (products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: products.length > 8 ? 8 : products.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final product = products[i];
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.thumbnail,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 30,
                                  ),
                                ),
                          ),
                        ),
                        title: Text(
                          product.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(product.category),
                        trailing: Text(
                          '₹${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(product.title),
                              content: Text(product.description),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF5F6FA);
    final List<Widget> screens = [
      _buildDashboardHome(),
      const ProductScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.green : Colors.black38,
              ),
              onPressed: () => _onNavTap(0),
            ),
            IconButton(
              icon: Icon(
                Icons.grid_view_rounded,
                color: _selectedIndex == 1 ? Colors.green : Colors.black38,
              ),
              onPressed: () => _onNavTap(1),
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: _selectedIndex == 2 ? Colors.green : Colors.black38,
              ),
              onPressed: () => _onNavTap(2),
            ),
            IconButton(
              icon: Icon(
                Icons.person_outline,
                color: _selectedIndex == 3 ? Colors.green : Colors.black38,
              ),
              onPressed: () => _onNavTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

// No helper widgets. All logic is in the main class or helper methods.
