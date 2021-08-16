import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movielist/model/movielist_model.dart';
import 'package:movielist/pages/addmovie_page.dart';
import 'package:movielist/pages/home_page.dart';
import 'package:movielist/pages/login_page.dart';
import 'package:movielist/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(MovieModelAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Constants.prefs.getBool("loggedIn") == true
            ? HomePage()
            : LoginPage(),
        theme: ThemeData(primarySwatch: Colors.purple),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          HomePage.routeName: (context) => HomePage(),
          AddMovie.routeName: (context) => AddMovie()
        });
  }
}
