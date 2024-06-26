import 'package:bookuet/model/wishlist.dart';
import 'package:bookuet/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize hive database
  await Hive.initFlutter();
  Hive.registerAdapter(WishlistAdapter());
  await Hive.openBox<Wishlist>('wishlist');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookeut',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: "Domine",
      ),
      home: const HomeView(),
    );
  }
}
