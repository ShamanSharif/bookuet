class Book {
  String id;
  String title;
  String subtitle;
  String authors;
  String imageUrl;
  String bookUrl;

  Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.imageUrl,
    required this.bookUrl,
  });
}

class BookDetails {
  String description;
  String publisher;
  String pages;
  String year;
  String downloadUrl;

  BookDetails({
    required this.description,
    required this.publisher,
    required this.pages,
    required this.year,
    required this.downloadUrl,
  });
}
