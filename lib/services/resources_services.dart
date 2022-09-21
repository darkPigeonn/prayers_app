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
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map(((e) => ResourceModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final resourceProvider = Provider<ResourceService>((ref) => ResourceService());