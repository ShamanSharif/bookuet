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
        try {
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
        } catch (e) {}
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
        try {
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
        } catch (e) {}
      }
    }
    return books;
  }

  Future<BookDetails?> getBookDetail({required String bookId}) async {
    BookDetails? bookDetails;
    String url = API.bookDetails + bookId;
    Response response = await _connectionHelper.getData(url: url);
    if (response.statusCode == 200) {
      try {
        var b = response.data;
        bookDetails = BookDetails(
          description: b["description"],
          publisher: b["publisher"],
          pages: b["pages"],
          year: b["year"],
          downloadUrl: b["download"],
        );
      } catch (e) {}
    }
    return bookDetails;
  }

  Future<bool> downloadPdf({required String url}) async {
    Response<dynamic> response = await _connectionHelper.downloadFile(url: url);
    return true;
  }

  Future<double?> getBookRating({required String bookId}) async {
    Response<dynamic> response =
        await _connectionHelper.getData(url: API.bookReview);
    if (response != null) {
      if (response.statusCode == 200) {
        var data = response.data;
        int counter = 0;
        int rating = 0;
        for (var d in data) {
          if (d["book_id"] == bookId) {
            rating += int.parse(d["rating"].toString());
            counter++;
          }
        }
        if (counter > 0) {
          return rating / counter;
        }
      }
    }
  }

  Future<bool> rateBook({required String bookId, required int rate}) async {
    dynamic data = {"book_id": bookId, "rating": rate};
    Response<dynamic>? response =
        await _connectionHelper.postData(url: API.bookReview, data: data);
    if (response != null) {
      if (response.statusCode == 201) {
        return true;
      }
    }
    return false;
  }
}
