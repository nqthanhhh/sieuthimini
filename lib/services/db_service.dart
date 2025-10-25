import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../models/user.dart';

class DBService {
  static const String productsBox = 'products';
  static const String usersBox = 'users';
  static const String settingsBox = 'settings';
  static const String cartsBox = 'carts';

  static Future<void> init() async {
    // initialize hive for Flutter
    await Hive.initFlutter();
    // register adapter (we included a hand-written adapter)
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<Product>(productsBox);
    // open users box and seed demo users if empty
    await Hive.openBox<User>(usersBox);
    // open carts box to persist per-user carts (stored as Map<String,int> per-user keyed by email)
    await Hive.openBox(cartsBox);
    // settings box for small key-value flags (e.g., seen welcome)
    await Hive.openBox(settingsBox);
    final users = Hive.box<User>(usersBox);
    if (users.isEmpty) {
      users.add(User(email: 'abc', password: '123', role: 'owner'));
      users.add(User(email: 'xyz', password: '123', role: 'staff'));
    }
  }

  static Box<Product> products() => Hive.box<Product>(productsBox);
  static Box settings() => Hive.box(settingsBox);
  static Box<User> users() => Hive.box<User>(usersBox);
  static Box carts() => Hive.box(cartsBox);

  /// Return a cart map (productId -> quantity) for [email]. If not found returns empty map.
  static Map<String, int> getCartForUser(String email) {
    final raw = carts().get(email);
    if (raw == null) return <String, int>{};
    try {
      return Map<String, int>.from(raw as Map);
    } catch (_) {
      return <String, int>{};
    }
  }

  /// Save the provided cart (productId -> qty) for [email].
  static Future<void> saveCartForUser(
    String email,
    Map<String, int> cart,
  ) async {
    await carts().put(email, cart);
  }
}
