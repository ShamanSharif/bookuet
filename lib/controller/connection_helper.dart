import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ConnectionHelper {
  Future<Response> getData({required String url}) async {
    try {
      print(url);
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      Response<dynamic> response = await dio.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postData({
    required String url,
    required dynamic data,
  }) async {
    try {
      print(url);
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      Response<dynamic> response = await dio.post(url, data: data);
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
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
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
