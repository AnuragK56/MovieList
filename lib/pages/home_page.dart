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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              border: Border.all(
                color: Color.fromRGBO(233, 233, 233, 1),
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(233, 233, 233, 1),
                    ),
                    image: DecorationImage(
                      image: Image.file(File(movie.posterImage)).image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        movie.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        movie.director,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Movie List"),
        backgroundColor: Theme.of(context).primaryColor,
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
                    child: Text(
                      'No Movies added yet!',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text(
                'No Movies added yet!',
                style: TextStyle(fontSize: 24),
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushReplacementNamed(context, AddMovie.routeName);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
