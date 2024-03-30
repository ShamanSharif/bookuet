import 'dart:io';

import 'package:bookuet/controller/data_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class BookReader extends StatefulWidget {
  final String bookUrl;
  const BookReader({
    Key? key,
    required this.bookUrl,
  }) : super(key: key);

  @override
  _BookReaderState createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  final DataFetcher _dataFetcher = DataFetcher();
  PdfController? pdfController;

  @override
  void initState() {
    super.initState();
    _fetchBook();
  }

  _fetchBook() async {
    await _dataFetcher.downloadPdf(url: widget.bookUrl);
    String fileName = "read_now";
    String filePath = await getFilePath(fileName);
    setState(() {
      pdfController = PdfController(
        document: PdfDocument.openFile(filePath),
      );
    });
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.pdf';
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Book"),
      ),
      body: pdfController != null
          ? PdfView(
              controller: pdfController!,
              scrollDirection: Axis.vertical,
              pageSnapping: false,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
