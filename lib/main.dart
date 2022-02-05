import 'package:bookuet/model/user.dart';
import 'package:bookuet/model/wishlist.dart';
import 'package:bookuet/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase core
  await Firebase.initializeApp();

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
    return ChangeNotifierProvider(
      create: (context) => User(),
      child: MaterialApp(
        title: 'Bookeut',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: "Domine",
        ),
        home: const HomeView(),
      ),
    );
  }
}
