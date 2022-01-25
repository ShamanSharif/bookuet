import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ConnectionHelper {
  var dio = Dio();

  Future<Response> getData({required String url}) async {
    try {
      print(url);
      Response<dynamic> response = await dio.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.pdf';
    return path;
  }

  Future<Response> downloadFile({required String url}) async {
    try {
      String fileName = "read_now";
      String savePath = await getFilePath(fileName);
      Response<dynamic> response = await dio.download(
        url,
        savePath,
        onReceiveProgress: (count, total) =>
            print((count / total).toString() + "%"),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
