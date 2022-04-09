import 'package:picbay2/constants/api_constants.dart';

class Api{
  final String apiKey;

  Api({required this.apiKey});
factory Api.production() =>Api(apiKey: ApiConstants.API_KEY);
Uri initialUri(int page,String term)=> Uri.parse('https://pixabay.com/api/?key=${apiKey}&q=$term&page=$page');
 // Uri initialUri (String endpoint) => Uri(
 //    scheme: 'https',
 //    host: ApiConstants.PIXBAY_BASE_URL,
 //    queryParameters: {
 //      "key": ApiConstants.API_KEY
 //    },
 //    path: endpoint
 //  );


}
