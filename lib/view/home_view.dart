import 'package:bookuet/controller/data_fetcher.dart';
import 'package:bookuet/controller/responsive.dart';
import 'package:bookuet/model/book.dart';
import 'package:bookuet/model/constants.dart';
import 'package:bookuet/model/hero_section.dart';
import 'package:bookuet/view/book_view.dart';
import 'package:bookuet/view/wishlist_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DataFetcher dataFetcher = DataFetcher();
  List<Book>? recentBooks;

  @override
  void initState() {
    fetchRecentBooks();
    super.initState();
  }

  fetchRecentBooks() async {
    List<Book> fetchedBooks = await dataFetcher.getRecentBooks();
    if (fetchedBooks.isNotEmpty) {
      setState(() {
        recentBooks = fetchedBooks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: const [
              Text("Bookuet"),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text("Favorite"),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Responsive(
          mobile: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeroSection(
                  imageHeight: 200,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: recentBooks != null
                      ? Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10.0,
                          runSpacing: 20.0,
                          children: [
                            for (Book book in recentBooks!)
                              MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookView(book: book),
                                  ),
                                ),
                                child: Container(
                                  height: 180,
                                  width: 138,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.network(book.imageUrl).image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                )
              ],
            ),
          ),
          tablet: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeroSection(
                  imageHeight: 200,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: recentBooks != null
                      ? Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          runSpacing: 20.0,
                          children: [
                            for (Book book in recentBooks!)
                              MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookView(book: book),
                                  ),
                                ),
                                child: Container(
                                  height: 180,
                                  width: 138,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.network(book.imageUrl).image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                )
              ],
            ),
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 3,
                child: HeroSection(),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: CustomColor.light,
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: recentBooks != null
                        ? GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            children: [
                              for (Book book in recentBooks!)
                                MaterialButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookView(book: book),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            Image.network(book.imageUrl).image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
