import 'dart:convert';

import 'package:picbay2/models/image_modal.dart';
import 'package:picbay2/services/api_service/api_service.dart';

class InitialDataRepo {
  final APIService apiService;

  InitialDataRepo({required this.apiService});

  Future<List<ImageModal>> getList(int page, String searchTerm) async {
    final response = await apiService.get(page, searchTerm);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.response.body);
      final List responseList = responseBody['hits'];
      List<ImageModal> lis =
          imageModalListFromJson(jsonEncode(responseList)).toList();
      return lis;
    }
    throw response;
  }
}
