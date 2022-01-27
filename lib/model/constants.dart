import 'package:flutter/material.dart';

class CustomColor {
  static Color light = const Color(0xFFFBEAFF);
  static Color textColor = const Color(0xFF4B4453);
  static Color background = const Color(0xFFDEF4FE);
}

class API {
  static String recentBooks = "https://www.dbooks.org/api/recent";
  static String searchBooks = "https://www.dbooks.org/api/search/"; // + query
  static String bookDetails = "https://www.dbooks.org/api/book/"; // + book id
}

class WishListTable {
  static String tableName = "wishlist";
  static String colId = "id";
  static String colBookId = "book_id";
  static String colTitle = "title";
  static String colSubtitle = "subtitle";
  static String colAuthors = "authors";
  static String colImageUrl = "image_url";
  static String colBookUrl = "book_url";
}
