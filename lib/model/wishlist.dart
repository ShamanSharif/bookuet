import 'package:hive/hive.dart';

part 'wishlist.g.dart';

@HiveType(typeId: 0)
class Wishlist extends HiveObject {
  @HiveField(0)
  final String bookId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String subtitle;

  @HiveField(3)
  final String authors;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final String bookUrl;

  Wishlist({
    required this.bookId,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.imageUrl,
    required this.bookUrl,
  });
}
