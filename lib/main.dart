import 'package:flutter/material.dart';
import 'package:picbay2/constants/api_constants.dart';
import 'package:picbay2/data_repos/fav_cach_repo.dart';
import 'package:picbay2/data_repos/initial_repo.dart';
import 'package:picbay2/providers/initial_data_provider.dart';
import 'package:picbay2/screens/home_screen.dart';
import 'package:picbay2/services/api/api.dart';
import 'package:picbay2/services/api_service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(ChangeNotifierProvider(
      create: (_) =>InitialDataProvider(faveCacheRepo: FaveCacheRepo(sharedPreferences: sharedPreferences), initialDataRepo: InitialDataRepo(apiService: APIService(api: Api(apiKey: ApiConstants.API_KEY)))),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<InitialDataProvider>(context).getFavImages();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}


