// import 'package:awesome_app/name_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:movielist/boxes.dart';
import 'package:movielist/drawer.dart';
import 'package:movielist/model/movielist_model.dart';
import 'package:movielist/pages/addmovie_page.dart';
import 'package:movielist/pages/login_page.dart';
import 'package:movielist/utils/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<MovieModel> movieBox;
  final List<MovieModel> movielist = [];
  var url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
  var data;

  @override
  void initState() {
    super.initState();
    //
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
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
                final movie = movielist[index];

                return buildTransaction(context, movie);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
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
          onTap: () => print("Edit"),
        ),
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print("Delete"),
        )
      ],
      child: ListTile(
        title: Text(movie.name),
        subtitle: Text(movie.director),
        leading: Image.memory(movie.posterImage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Movie List"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Constants.prefs.setBool("loggedIn", false);
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      // body: data != null
      //     ? ListView.builder(
      //         itemBuilder: (context, index) {
      //           return Slidable(
      //             actionPane: SlidableDrawerActionPane(),
      //             secondaryActions: <Widget>[
      //               IconSlideAction(
      //                 caption: "Edit",
      //                 color: Colors.orange,
      //                 icon: Icons.edit,
      //                 onTap: () => print("Edit"),
      //               ),
      //               IconSlideAction(
      //                 caption: "Delete",
      //                 color: Colors.red,
      //                 icon: Icons.delete,
      //                 onTap: () => print("Delete"),
      //               )
      //             ],
      //             child: ListTile(
      //               title: Text(data[index]["title"]),
      //               subtitle: Text("ID: ${data[index]["id"]}"),
      //               leading: Image.network(data[index]["url"]),
      //             ),
      //           );
      //         },
      //         itemCount: data.length,
      //       )
      // body: movielist.isEmpty != false
      //     ? ValueListenableBuilder<Box<MovieModel>>(
      //         valueListenable: Boxes.getMovies().listenable(),
      //         builder: (context, box, _) {
      //           final movielist = box.values.toList().cast<MovieModel>();
      //           return buildContent(movielist);
      //         })
      //     : Center(
      //         child: CircularProgressIndicator(),
      //       ),
      body: FutureBuilder(
        future: Hive.openBox<MovieModel>('movielist'),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.done) {
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
          // } else
          //   return Text("Loading");
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
