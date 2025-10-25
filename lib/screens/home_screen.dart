import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/db_service.dart';
import '../models/product.dart';
import 'profile_view_screen.dart';
import 'checkout_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.role, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Simple in-memory cart: productId -> quantity
  final Map<String, int> _cart = {};
  String? _currentUserEmail;

  // mapping đơn giản id -> ảnh
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
    // load current user cart if available
    final settings = DBService.settings();
    final email = settings.get('current_user_email') as String?;
    _currentUserEmail = email;
    if (email != null) {
      final saved = DBService.getCartForUser(email);
      if (saved.isNotEmpty) {
        _cart.addAll(saved);
      }
    }
  }

  Future<void> _persistCart() async {
    if (_currentUserEmail != null) {
      await DBService.saveCartForUser(_currentUserEmail!, _cart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileViewScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12, width: 6),
                          ),
                          child: const Center(
                            child: Icon(Icons.person_outline, size: 48),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Thông tin cá nhân',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (widget.role == 'owner') ...[
                      ListTile(
                        leading: const Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        title: const Text('Tổng quan doanh thu'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: const Text('Quản lý sản phẩm'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.inventory),
                        title: const Text('Quản lý kho hàng'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Nhân viên'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Vai trò'),
                        onTap: () {},
                      ),
                    ],
                    ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: const Text('Đơn hàng'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
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
                                    setState(() {
                                      _cart.update(
                                        p.id,
                                        (v) => v + 1,
                                        ifAbsent: () => 1,
                                      );
                                    });
                                    Future.microtask(() => _persistCart());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Đã thêm ${p.name} vào giỏ hàng',
                                        ),
                                        duration: const Duration(
                                          milliseconds: 100,
                                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCartSheet(context),
        backgroundColor: Colors.orange.shade400,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart),
            if (_cart.isNotEmpty)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _cart.values.fold<int>(0, (a, b) => a + b).toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openCartSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        // We'll compute the items inside the modal to reflect latest cart
        return StatefulBuilder(
          builder: (ctx2, modalSetState) {
            final productsBox = DBService.products();
            final items = productsBox.values
                .where((p) => _cart.containsKey(p.id))
                .toList();
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              minChildSize: 0.25,
              maxChildSize: 0.9,
              builder: (_, controller) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Giỏ hàng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: items.isEmpty
                          ? const Center(child: Text('Giỏ hàng trống'))
                          : ListView.builder(
                              controller: controller,
                              itemCount: items.length,
                              itemBuilder: (context, i) {
                                final p = items[i];
                                final qty = _cart[p.id] ?? 0;
                                return ListTile(
                                  leading: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: imageFor(p.id).isNotEmpty
                                        ? Image.asset(
                                            imageFor(p.id),
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.image_outlined),
                                  ),
                                  title: Text(p.name),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Decrement
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        onPressed: () {
                                          modalSetState(() {
                                            final cur = _cart[p.id] ?? 0;
                                            if (cur <= 1) {
                                              _cart.remove(p.id);
                                            } else {
                                              _cart[p.id] = cur - 1;
                                            }
                                          });
                                          setState(() {});
                                          Future.microtask(
                                            () => _persistCart(),
                                          );
                                        },
                                      ),
                                      Text(qty.toString()),
                                      // Increment
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        onPressed: () {
                                          modalSetState(() {
                                            _cart.update(
                                              p.id,
                                              (v) => v + 1,
                                              ifAbsent: () => 1,
                                            );
                                          });
                                          setState(() {});
                                          Future.microtask(
                                            () => _persistCart(),
                                          );
                                        },
                                      ),
                                      // Delete with confirmation
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (dctx) => AlertDialog(
                                              title: const Text('Xác nhận xoá'),
                                              content: Text(
                                                'Bạn có chắc muốn xoá "${p.name}" khỏi giỏ hàng không?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    dctx,
                                                  ).pop(false),
                                                  child: const Text('Huỷ'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    dctx,
                                                  ).pop(true),
                                                  child: const Text('Xoá'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            modalSetState(() {
                                              _cart.remove(p.id);
                                            });
                                            setState(() {});
                                            Future.microtask(
                                              () => _persistCart(),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _cart.isEmpty
                                ? null
                                : () {
                                    // Close cart sheet and navigate to checkout
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CheckoutScreen(
                                          cart: Map.from(_cart),
                                          onCheckoutComplete: () async {
                                            setState(() => _cart.clear());
                                            await _persistCart();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade400,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Thanh toán',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
