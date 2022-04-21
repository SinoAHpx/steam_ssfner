import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class SSFNService {
  static Future<void> write(
      {required String ssfn, required String steamPath}) async {
    var file = File('$steamPath\\$ssfn');
    if (await file.exists()) {
      return;
    }

    var bytes = await download(ssfn);
    file.writeAsBytes(bytes);
  }

  static Future<List<int>> download(String ssfn) async {
    final url = "https://ssfnbox.com/download/$ssfn";
    final response = await http.get(Uri.parse(url));
    final body = response.body;

    final startIndex = body.lastIndexOf('sec=');
    if (startIndex == -1) {
      throw Exception(
          'Failed to fetch SSFN from web, check if your input SSFN is valid!');
    }

    final endIndex = body.indexOf(')', startIndex);

    final validateCode = body.substring(startIndex + 4, endIndex - 1);

    final trueLink = '$url?sec=$validateCode';
    return (await http.get(Uri.parse(trueLink))).bodyBytes.toList();
  }
}
