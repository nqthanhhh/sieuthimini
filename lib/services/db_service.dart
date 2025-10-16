import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../models/user.dart';

class DBService {
  static const String productsBox = 'products';
  static const String usersBox = 'users';
  static const String settingsBox = 'settings';

  static Future<void> init() async {
    // initialize hive for Flutter
    await Hive.initFlutter();
    // register adapter (we included a hand-written adapter)
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<Product>(productsBox);
    // open users box and seed demo users if empty
    await Hive.openBox<User>(usersBox);
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
}
