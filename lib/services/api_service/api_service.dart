import 'dart:io';

import 'package:picbay2/models/image_modal.dart';
import 'package:picbay2/services/api/api.dart';
import 'package:http/http.dart' as http;
class APIService{
  final Api api;

  APIService({required this.api});


  Future<dynamic> get(int page,String searchTerm)async{
    try {
      final response = await http.get(api.initialUri(page,searchTerm));
      if (response.statusCode == 200) {

        return Success(response:response,statusCode: 200);
      }
    } on SocketException{
      return Error('Error in network', 100);
    } on http.ClientException {
      return Error('Error in network', 102);
    } catch (e){
      return Error('Error in network', 103);
    }

  }
}

class Success{
  final dynamic response;
  final int statusCode;
  Success({required this.response, required this.statusCode});
}
class Error{
  final String responseMessage;
  final int errorCode;
  Error(this.responseMessage, this.errorCode);


}