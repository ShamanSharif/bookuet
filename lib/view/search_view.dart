import 'package:bookuet/controller/data_fetcher.dart';
import 'package:bookuet/controller/responsive.dart';
import 'package:bookuet/model/book.dart';
import 'package:bookuet/model/constants.dart';
import 'package:bookuet/model/hero_section.dart';
import 'package:bookuet/view/home_view.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'book_view.dart';

class SearchView extends StatefulWidget {
  final String searchTerm;
  const SearchView({Key? key, required this.searchTerm}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final DataFetcher dataFetcher = DataFetcher();
  List<Book>? searchedBooks;
  late String searchTerm;

  @override
  void initState() {
    searchTerm = widget.searchTerm;
    fetchBooks();
    super.initState();
  }

  fetchBooks() async {
    List<Book> fetchedBooks =
        await dataFetcher.searchBooks(searchTerm: searchTerm);
    setState(() {
      searchedBooks = fetchedBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        title: const Text("Search Screen"),
      ),
      body: SafeArea(
        child: Responsive(
          mobile: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroSection(
                  imageHeight: 200,
                  searchTerm: searchTerm,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Showing result for $searchTerm",
                        style: TextStyle(color: CustomColor.textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: MaterialButton(
                          color: CustomColor.textColor,
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => const HomeView(),
                            ),
                            (route) => false,
                          ),
                          child: Icon(
                            EvaIcons.backspace,
                            color: CustomColor.light,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: searchedBooks != null
                      ? GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 0.0,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1,
                          ),
                          children: [
                            for (Book book in searchedBooks!)
                              MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookView(book: book),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.network(book.imageUrl).image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
          tablet: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroSection(
                  imageHeight: 200,
                  searchTerm: searchTerm,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Showing result for $searchTerm",
                        style: TextStyle(color: CustomColor.textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: MaterialButton(
                          color: CustomColor.textColor,
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => const HomeView(),
                            ),
                            (route) => false,
                          ),
                          child: Icon(
                            EvaIcons.backspace,
                            color: CustomColor.light,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: searchedBooks != null
                      ? GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1,
                          ),
                          children: [
                            for (Book book in searchedBooks!)
                              MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookView(book: book),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.network(book.imageUrl).image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
          desktop: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroSection(
                  imageHeight: 200,
                  searchTerm: searchTerm,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Showing result for $searchTerm",
                        style: TextStyle(color: CustomColor.textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: MaterialButton(
                          color: CustomColor.textColor,
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => const HomeView(),
                            ),
                            (route) => false,
                          ),
                          child: Icon(
                            EvaIcons.backspace,
                            color: CustomColor.light,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: searchedBooks != null
                      ? GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1,
                          ),
                          children: [
                            for (Book book in searchedBooks!)
                              MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookView(book: book),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.network(book.imageUrl).image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
