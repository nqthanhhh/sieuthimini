// ...existing code...
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/db_service.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.role, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ...existing code...
  // mapping đơn giản id -> ảnh/đơn vị (nếu cần)
  String imageFor(String id) {
    switch (id) {
      case 'banana':
        return 'assets/images/banana.png';
      case 'apple':
        return 'assets/images/apple.png';
      case 'coke':
        return 'assets/images/coke.png';
      case 'diet_coke':
        return 'assets/images/diet_coke.png';
      case 'tomato':
        return 'assets/images/tomato.png';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    // ensure DBService.init() has seeded products earlier; we don't setState here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              SizedBox(width: 12),
              Icon(Icons.search, color: Colors.black45),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Search Store',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout, color: Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo banner (image)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/banner.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 100,
                    color: Colors.orange.shade50,
                    alignment: Alignment.center,
                    child: const Text('Banner'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ưu đãi hôm nay',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Tất cả')),
                ],
              ),
              const SizedBox(height: 8),
              // Use ValueListenableBuilder on the products box so UI updates automatically
              ValueListenableBuilder(
                valueListenable: DBService.products().listenable(),
                builder: (context, Box<Product> box, _) {
                  final items = box.values.toList().cast<Product>();
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(child: Text('Không có sản phẩm')),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Product p = items[index];
                      final img = imageFor(p.id);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: img.isNotEmpty
                                      ? Image.asset(
                                          img,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (c, e, s) => Container(
                                            color: Colors.grey.shade100,
                                            child: const Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 36,
                                                color: Colors.black26,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.image,
                                              size: 36,
                                              color: Colors.black26,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p.stock} có sẵn • ${p.price.toString()}đ',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () async {
                                    // ví dụ thêm vào giỏ hàng - ở đây chỉ show Snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Đã thêm ${p.name} vào giỏ hàng'),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade400,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ...existing code...
