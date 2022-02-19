import 'package:bookuet/controller/data_fetcher.dart';
import 'package:bookuet/controller/responsive.dart';
import 'package:bookuet/model/book.dart';
import 'package:bookuet/model/constants.dart';
import 'package:bookuet/model/wishlist.dart';
import 'package:bookuet/view/book_reader.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BookView extends StatefulWidget {
  final Book book;
  const BookView({Key? key, required this.book}) : super(key: key);

  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  final DataFetcher dataFetcher = DataFetcher();
  BookDetails? bookDetails;
  late Book book;
  bool onFav = false;
  double? bookRating;
  int newRating = 0;

  @override
  void initState() {
    book = widget.book;
    fetchBook();
    isOnFav();
    fetchBookRating();
    super.initState();
  }

  fetchBook() async {
    BookDetails? fetchedBook = await dataFetcher.getBookDetail(bookId: book.id);
    setState(() {
      bookDetails = fetchedBook;
    });
  }

  fetchBookRating() async {
    double? rating = await dataFetcher.getBookRating(bookId: book.id);
    if (rating != null) {
      setState(() {
        bookRating = rating;
      });
    }
  }

  isOnFav() {
    final wishlistBox = Hive.box<Wishlist>('wishlist');
    for (Wishlist wishlistBook in wishlistBox.values) {
      if (wishlistBook.bookId == book.id) {
        setState(() {
          onFav = true;
        });
        break;
      }
    }
  }

  addToFav(Wishlist wishlistBook) {
    final wishlistBox = Hive.box<Wishlist>('wishlist');
    wishlistBox.add(wishlistBook);
    setState(() {
      onFav = true;
    });
  }

  removeFromFav() {
    final wishlistBox = Hive.box<Wishlist>('wishlist');
    for (Wishlist wishlistBook in wishlistBox.values) {
      if (wishlistBook.bookId == book.id) {
        wishlistBook.delete();
        setState(() {
          onFav = false;
        });
        break;
      }
    }
  }

  Future<bool> postReview(int rate) async {
    bool status = await dataFetcher.rateBook(bookId: book.id, rate: rate);
    return status;
  }

  void _launchURL({required String url}) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        title: const Text("Book Details"),
      ),
      body: SafeArea(
        child: Responsive(
          mobile: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    book.imageUrl,
                    width: size.width * 0.9,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: TextStyle(
                                color: CustomColor.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            book.subtitle.isNotEmpty
                                ? Text(
                                    book.subtitle,
                                    style: TextStyle(
                                      color: CustomColor.textColor,
                                    ),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(book.authors),
                            ),
                            MaterialButton(
                              color: CustomColor.textColor,
                              onPressed: () {
                                if (onFav) {
                                  removeFromFav();
                                } else {
                                  addToFav(
                                    Wishlist(
                                      bookId: book.id,
                                      title: book.title,
                                      subtitle: book.subtitle,
                                      authors: book.authors,
                                      imageUrl: book.imageUrl,
                                      bookUrl: book.bookUrl,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                onFav
                                    ? "Remove from Favourite"
                                    : "Add to Favourite",
                                style: TextStyle(
                                  color: CustomColor.light,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        bookDetails != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(
                                      bookDetails!.description,
                                      style: TextStyle(
                                        color: CustomColor.textColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    bookRating != null
                                        ? "Rating: Not rated yet"
                                        : "Rating: $bookRating out of 5",
                                    style: TextStyle(
                                      color: CustomColor.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Publisher: ${bookDetails!.publisher}",
                                    style: TextStyle(
                                      color: CustomColor.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Published On: ${bookDetails!.year}",
                                    style: TextStyle(
                                      color: CustomColor.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Total Pages: ${bookDetails!.pages}",
                                    style: TextStyle(
                                      color: CustomColor.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: MaterialButton(
                                  color: CustomColor.textColor,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Material(
                                            child: Center(
                                                child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              color: Colors.cyan,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  DropdownButton<int>(
                                                    items: const [
                                                      DropdownMenuItem<int>(
                                                        child: Text("1"),
                                                        value: 1,
                                                      ),
                                                      DropdownMenuItem<int>(
                                                        child: Text("2"),
                                                        value: 2,
                                                      ),
                                                      DropdownMenuItem<int>(
                                                        child: Text("3"),
                                                        value: 3,
                                                      ),
                                                      DropdownMenuItem<int>(
                                                        child: Text("4"),
                                                        value: 4,
                                                      ),
                                                      DropdownMenuItem<int>(
                                                        child: Text("5"),
                                                        value: 5,
                                                      )
                                                    ],
                                                    onChanged: (val) =>
                                                        setState(() {
                                                      newRating = val ?? 0;
                                                    }),
                                                    isExpanded: true,
                                                  ),
                                                  MaterialButton(
                                                    color:
                                                        CustomColor.textColor,
                                                    onPressed: newRating == 0
                                                        ? null
                                                        : () {
                                                            postReview(
                                                                newRating);
                                                            fetchBookRating();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                    child: Text(
                                                      "Post",
                                                      style: TextStyle(
                                                        color:
                                                            CustomColor.light,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Rate this book",
                                    style: TextStyle(
                                      color: CustomColor.light,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      color: CustomColor.textColor,
                                      onPressed: bookDetails == null
                                          ? null
                                          : () {
                                              _launchURL(
                                                  url:
                                                      bookDetails!.downloadUrl);
                                            },
                                      child: Text(
                                        "Download",
                                        style: TextStyle(
                                          color: CustomColor.light,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      color: CustomColor.textColor,
                                      onPressed: bookDetails == null
                                          ? null
                                          : () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => BookReader(
                                                    bookUrl: bookDetails!
                                                        .downloadUrl,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: Text(
                                        "Read Now",
                                        style: TextStyle(
                                          color: CustomColor.light,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          tablet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(book.imageUrl),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              color: CustomColor.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          book.subtitle.isNotEmpty
                              ? Text(
                                  book.subtitle,
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                  ),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              book.authors,
                              style: TextStyle(
                                color: CustomColor.textColor,
                              ),
                            ),
                          ),
                          MaterialButton(
                            color: CustomColor.textColor,
                            onPressed: () {
                              if (onFav) {
                                removeFromFav();
                              } else {
                                addToFav(
                                  Wishlist(
                                    bookId: book.id,
                                    title: book.title,
                                    subtitle: book.subtitle,
                                    authors: book.authors,
                                    imageUrl: book.imageUrl,
                                    bookUrl: book.bookUrl,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              onFav
                                  ? "Remove from Favourite"
                                  : "Add to Favourite",
                              style: TextStyle(
                                color: CustomColor.light,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      bookDetails != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    bookDetails!.description,
                                    style: TextStyle(
                                      color: CustomColor.textColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  bookRating != null
                                      ? "Rating: Not rated yet"
                                      : "Rating: $bookRating out of 5",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Publisher: ${bookDetails!.publisher}",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Published On: ${bookDetails!.year}",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Total Pages: ${bookDetails!.pages}",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: MaterialButton(
                                color: CustomColor.textColor,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Material(
                                          child: Center(
                                              child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            color: Colors.cyan,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                DropdownButton<int>(
                                                  items: const [
                                                    DropdownMenuItem<int>(
                                                      child: Text("1"),
                                                      value: 1,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("2"),
                                                      value: 2,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("3"),
                                                      value: 3,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("4"),
                                                      value: 4,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("5"),
                                                      value: 5,
                                                    )
                                                  ],
                                                  onChanged: (val) =>
                                                      setState(() {
                                                    newRating = val ?? 0;
                                                  }),
                                                  isExpanded: true,
                                                ),
                                                MaterialButton(
                                                  color: CustomColor.textColor,
                                                  onPressed: newRating == 0
                                                      ? null
                                                      : () {
                                                          postReview(newRating);
                                                          fetchBookRating();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                  child: Text(
                                                    "Post",
                                                    style: TextStyle(
                                                      color: CustomColor.light,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                        );
                                      });
                                },
                                child: Text(
                                  "Rate this book",
                                  style: TextStyle(
                                    color: CustomColor.light,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    color: CustomColor.textColor,
                                    onPressed: bookDetails == null
                                        ? null
                                        : () {
                                            _launchURL(
                                                url: bookDetails!.downloadUrl);
                                          },
                                    child: Text(
                                      "Download",
                                      style: TextStyle(
                                        color: CustomColor.light,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    color: CustomColor.textColor,
                                    onPressed: bookDetails == null
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => BookReader(
                                                  bookUrl:
                                                      bookDetails!.downloadUrl,
                                                ),
                                              ),
                                            );
                                          },
                                    child: Text(
                                      "Read Now",
                                      style: TextStyle(
                                        color: CustomColor.light,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          desktop: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(book.imageUrl),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              color: CustomColor.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          book.subtitle.isNotEmpty
                              ? Text(
                                  book.subtitle,
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                  ),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              book.authors,
                              style: TextStyle(
                                color: CustomColor.textColor,
                              ),
                            ),
                          ),
                          MaterialButton(
                            color: CustomColor.textColor,
                            onPressed: () {
                              if (onFav) {
                                removeFromFav();
                              } else {
                                addToFav(
                                  Wishlist(
                                    bookId: book.id,
                                    title: book.title,
                                    subtitle: book.subtitle,
                                    authors: book.authors,
                                    imageUrl: book.imageUrl,
                                    bookUrl: book.bookUrl,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              onFav
                                  ? "Remove from Favourite"
                                  : "Add to Favourite",
                              style: TextStyle(
                                color: CustomColor.light,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      bookDetails != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    bookDetails!.description,
                                    style: TextStyle(
                                      color: CustomColor.textColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  bookRating != null
                                      ? "Rating: Not rated yet"
                                      : "Rating: $bookRating out of 5",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Publisher: ${bookDetails!.publisher}",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Published On: ${bookDetails!.year}",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Total Pages: ${bookDetails!.pages}",
                                  style: TextStyle(
                                    color: CustomColor.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: MaterialButton(
                                color: CustomColor.textColor,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Material(
                                          child: Center(
                                              child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            color: Colors.cyan,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                DropdownButton<int>(
                                                  items: const [
                                                    DropdownMenuItem<int>(
                                                      child: Text("1"),
                                                      value: 1,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("2"),
                                                      value: 2,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("3"),
                                                      value: 3,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("4"),
                                                      value: 4,
                                                    ),
                                                    DropdownMenuItem<int>(
                                                      child: Text("5"),
                                                      value: 5,
                                                    )
                                                  ],
                                                  onChanged: (val) =>
                                                      setState(() {
                                                    newRating = val ?? 0;
                                                  }),
                                                  isExpanded: true,
                                                ),
                                                MaterialButton(
                                                  color: CustomColor.textColor,
                                                  onPressed: newRating == 0
                                                      ? null
                                                      : () {
                                                          postReview(newRating);
                                                          fetchBookRating();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                  child: Text(
                                                    "Post",
                                                    style: TextStyle(
                                                      color: CustomColor.light,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                        );
                                      });
                                },
                                child: Text(
                                  "Rate this book",
                                  style: TextStyle(
                                    color: CustomColor.light,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                MaterialButton(
                                  minWidth: 200,
                                  color: CustomColor.textColor,
                                  onPressed: bookDetails == null
                                      ? null
                                      : () {
                                          _launchURL(
                                              url: bookDetails!.downloadUrl);
                                        },
                                  child: Text(
                                    "Download",
                                    style: TextStyle(
                                      color: CustomColor.light,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                MaterialButton(
                                  minWidth: 200,
                                  color: CustomColor.textColor,
                                  onPressed: bookDetails == null
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BookReader(
                                                bookUrl:
                                                    bookDetails!.downloadUrl,
                                              ),
                                            ),
                                          );
                                        },
                                  child: Text(
                                    "Read Now",
                                    style: TextStyle(
                                      color: CustomColor.light,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
