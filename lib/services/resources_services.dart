import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayers_app/model/resource_model.dart';
import 'package:http/http.dart' as http;

class ResourceService {
  Future<List<ResourceModel>> getPrayers() async {
    Map<String, String> headers = {
      'Id': '619c3c2e29baa215519da64d',
      'Secret': '360039ed-79a6-4853-8304-c7b21e166f5f',
      'partner': 'keuskupanSby'
    };
    final response = await http.get(
      Uri.parse('https://api.imavi.org/imavi/prayers/get-all'),
      // Uri.parse('http://localhost:3005/imavi/prayers/get-all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);

      return result.map(((e) => ResourceModel.fromJson(e))).toList();
    } else {
      print(response);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<ResourceModel> getPrayersToday() async {
    Map<String, String> headers = {
      'Id': '619c3c2e29baa215519da64d',
      'Secret': '360039ed-79a6-4853-8304-c7b21e166f5f',
      'partner': 'keuskupanSby'
    };
    final response = await http.get(
      Uri.parse('https://api.imavi.org/imavi/prayers/get-today'),
      // Uri.parse('http://localhost:3005/imavi/prayers/get-all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      ResourceModel result = ResourceModel.fromJson(jsonDecode(response.body));
      return result;
    } else {
      print(response);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<dynamic> getEventsToday() async {
    Map<String, String> headers = {
      'Id': '6147f10d33abc530a445fe84',
      'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
      'partner': 'ukwms'
    };

    final response = await http.get(
        Uri.parse('https://api.imavi.org/imavi/events/get-all'),
        headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }
}

final resourceProvider = Provider<ResourceService>((ref) => ResourceService());
