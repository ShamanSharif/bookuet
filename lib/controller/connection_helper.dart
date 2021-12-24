import 'package:dio/dio.dart';

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
}
