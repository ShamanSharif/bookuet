import 'package:bookuet/model/book.dart';
import 'package:bookuet/model/wishlist.dart';
import 'package:bookuet/view/book_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  _WishlistViewState createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  goToBookView(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => BookView(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist"),
      ),
      body: ValueListenableBuilder<Box<Wishlist>>(
        valueListenable: Hive.box<Wishlist>('wishlist').listenable(),
        builder: (context, box, _) {
          final wishlist = box.values.toList().cast<Wishlist>();
          return _buildWishListView(wishlist);
        },
      ),
    );
  }

  _buildWishListView(List<Wishlist> wishlist) {
    return ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              goToBookView(
                Book(
                  id: wishlist[index].bookId,
                  title: wishlist[index].title,
                  subtitle: wishlist[index].subtitle,
                  authors: wishlist[index].authors,
                  imageUrl: wishlist[index].imageUrl,
                  bookUrl: wishlist[index].bookUrl,
                ),
              );
            },
            leading: Image.network(wishlist[index].imageUrl),
            title: Text(wishlist[index].title),
            subtitle: Text(wishlist[index].authors),
          );
        });
  }
}
