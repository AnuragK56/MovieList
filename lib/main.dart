import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movielist/model/movielist_model.dart';
import 'package:movielist/pages/addmovie_page.dart';
import 'package:movielist/pages/home_page.dart';
import 'package:movielist/pages/login_page.dart';
import 'package:movielist/services/auth.dart';
import 'package:movielist/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(MovieModelAdapter());
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: (user != null) == true ? HomePage() : LoginPage(),
          theme: ThemeData(primarySwatch: Colors.purple),
          routes: {
            LoginPage.routeName: (context) => LoginPage(),
            HomePage.routeName: (context) => HomePage(),
            AddMovie.routeName: (context) => AddMovie(),
            // EditMovie.routeName:(context,MovieModel movie)=>EditMovie(movie: movie)
          }),
    );
  }
}
