// import 'package:awesome_app/name_card_widget.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielist/boxes.dart';
import 'package:movielist/drawer.dart';
import 'package:movielist/model/movielist_model.dart';
import 'package:movielist/pages/addmovie_page.dart';
import 'package:movielist/pages/editmovie_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:movielist/utils/constants.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  late Box<MovieModel> movieBox;
  final List<MovieModel> movielist = [];
  final snackBar = SnackBar(content: Text('Movie Deleted succesfully!'));
  var url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
  var data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  void deleteMovie(MovieModel movie) {
    movie.delete();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildContent(List<MovieModel> movielist) {
    if (movielist.isEmpty) {
      return Center(
        child: Text(
          'No Movies added yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: movielist.length,
              itemBuilder: (BuildContext context, int index) {
                MovieModel movie = movielist[index];

                return buildMovie(context, movie);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildMovie(
    BuildContext context,
    MovieModel movie,
  ) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "Edit",
          color: Colors.orange,
          icon: Icons.edit,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditMovie(
                      movie: movie,
                    )));
          },
        ),
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Deleting Movie'),
                content: const Text('Do you want delete the selected Movie'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () =>
                        {Navigator.pop(context, 'Yes'), deleteMovie(movie)},
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
        )
      ],
      child: ListTile(
        title: Text(movie.name),
        subtitle: Text(movie.director),
        leading: Image.file(File(movie.posterImage)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      Constants.prefs.setBool("loggedIn", true);
      print("USer loggedIn Successfully");
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Movie List"),
        //   actions: <Widget>[
        //     IconButton(
        //         onPressed: () {
        //           final provider =
        //               Provider.of<GoogleSignInProvider>(context, listen: false);
        //           provider.logout();
        //           Navigator.pushReplacementNamed(context, LoginPage.routeName);
        //         },
        //         icon: Icon(Icons.exit_to_app))
        //   ],
      ),
      body: FutureBuilder(
        future: Hive.openBox<MovieModel>('movielist'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            movieBox = Hive.box<MovieModel>('movielist');
            return movieBox.isEmpty == false
                ? ValueListenableBuilder<Box<MovieModel>>(
                    valueListenable: Boxes.getMovies().listenable(),
                    builder: (context, box, _) {
                      final movielist = box.values.toList().cast<MovieModel>();
                      return buildContent(movielist);
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          } else
            return Text("Loading");
        },
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AddMovie.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
