import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static Future<List<dynamic>> loadKapampanganData() async {
    final String response = await rootBundle.loadString('assets/data/kapampangan_table_kapampangan.json');
    return json.decode(response)['data'];
  }

  static Future<List<dynamic>> loadHistoryData() async {
    final String response = await rootBundle.loadString('assets/data/kapampangan_table_histories.json');
    return json.decode(response)['data'];
  }
}
