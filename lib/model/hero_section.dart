import 'package:bookuet/controller/responsive.dart';
import 'package:bookuet/view/search_view.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class HeroSection extends StatefulWidget {
  final double? imageHeight;
  final String? searchTerm;
  const HeroSection({Key? key, this.imageHeight, this.searchTerm})
      : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final TextEditingController searchTermTextEditingController =
      TextEditingController();

  @override
  void initState() {
    if (widget.searchTerm != null) {
      searchTermTextEditingController.text = widget.searchTerm!;
    }
    super.initState();
  }

  void searchBooks() {
    String searchTerm = searchTermTextEditingController.value.text;
    if (searchTerm.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => SearchView(
            searchTerm: searchTerm,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    searchTermTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo.png",
          color: CustomColor.textColor,
          height: widget.imageHeight,
        ),
        SizedBox(
          width:
              Responsive.isMobile(context) ? size.width / 1.3 : size.width / 2,
          child: TextField(
            controller: searchTermTextEditingController,
            onSubmitted: (searchTerm) {
              searchBooks();
            },
            decoration: InputDecoration(
              isDense: true,
              labelText: "Search for Bookuet",
              labelStyle: TextStyle(
                color: CustomColor.textColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColor.textColor),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColor.textColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.textColor,
                  width: 3.0,
                ),
              ),
              suffixIcon: Icon(
                EvaIcons.search,
                color: CustomColor.textColor,
              ),
              suffixIconColor: CustomColor.textColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: searchBooks,
            color: CustomColor.textColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 32.0,
              ),
              child: Text(
                "Search",
                style: TextStyle(
                  color: CustomColor.light,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
