import 'package:bookuet/controller/connection_helper.dart';
import 'package:bookuet/model/book.dart';
import 'package:bookuet/model/constants.dart';
import 'package:dio/dio.dart';

class DataFetcher {
  final ConnectionHelper _connectionHelper = ConnectionHelper();

  Future<List<Book>> getRecentBooks() async {
    List<Book> books = [];
    Response response = await _connectionHelper.getData(url: API.recentBooks);
    if (response.statusCode == 200) {
      var data = response.data;
      int i = 0;
      for (var b in data["books"]) {
        books.add(
          Book(
            id: b["id"],
            title: b["title"],
            subtitle: b["subtitle"],
            authors: b["authors"],
            imageUrl: b["image"],
            bookUrl: b["url"],
          ),
        );
        i++;
        if (i == 4) {
          break;
        }
      }
    }
    return books;
  }

  Future<List<Book>> searchBooks({required String searchTerm}) async {
    List<Book> books = [];
    String url = API.searchBooks + searchTerm;
    Response response = await _connectionHelper.getData(url: url);
    if (response.statusCode == 200) {
      var data = response.data;

      for (var b in data["books"]) {
        books.add(
          Book(
            id: b["id"],
            title: b["title"],
            subtitle: b["subtitle"],
            authors: b["authors"],
            imageUrl: b["image"],
            bookUrl: b["url"],
          ),
        );
      }
    }
    return books;
  }

  Future<BookDetails?> getBookDetail({required String bookId}) async {
    BookDetails? bookDetails;
    String url = API.bookDetails + bookId;
    Response response = await _connectionHelper.getData(url: url);
    if (response.statusCode == 200) {
      var b = response.data;
      bookDetails = BookDetails(
        description: b["description"],
        publisher: b["publisher"],
        pages: b["pages"],
        year: b["year"],
        downloadUrl: b["download"],
      );
    }
    return bookDetails;
  }

  Future<bool> downloadPdf({required String url}) async {
    Response<dynamic> response = await _connectionHelper.downloadFile(url: url);
    return true;
  }
}
