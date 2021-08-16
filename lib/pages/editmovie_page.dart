import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:movielist/model/movielist_model.dart';
import 'package:movielist/pages/home_page.dart';

class EditMovie extends StatefulWidget {
  static const String routeName = "/EditMovie";
  final MovieModel movie;
  const EditMovie({Key? key, required this.movie}) : super(key: key);
  @override
  _EditMovieState createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _movienameController;
  late TextEditingController _directorController;
  late String prevImage;
  String? prevMovie;
  String? prevDirector;
  MovieModel? _movie;
  XFile? image;
  @override
  void initState() {
    super.initState();
    print("Name" + widget.movie.name);

    image = XFile(widget.movie.posterImage);
    prevMovie = widget.movie.name;
    prevDirector = widget.movie.director;
    _movie = widget.movie;
    _movienameController = TextEditingController(text: widget.movie.name);
    _directorController = TextEditingController(text: widget.movie.director);
  }

  final snackBar = SnackBar(content: Text('Yay! Movie Edited succesfully!'));

  bool _autoValidate = false;
  bool validate() {
    if (formKey.currentState!.validate()) {
      print("Validated");
      return true;
    } else {
      print("Not Validated");
      return false;
    }
  }

  void editMovie() {
    final file = image; // File
    String imagePath = file!.path; // File // Uint8List
    var name = _movienameController.text;
    var director = _directorController.text;
    _movie!.name = name;
    _movie!.director = director;
    _movie!.posterImage = imagePath;
    _movie!.save();
  }

  void filePicker() async {
    final XFile? selectImage =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = selectImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a new Movie"),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _autoValidate = true;
                    });
                    Navigator.pushReplacementNamed(context, HomePage.routeName);
                  },
                  child: Text('Cancel'),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/add_bg.jpg",
              fit: BoxFit.cover,
              // color: Colors.black.withOpacity(0.7),
              // colorBlendMode: BlendMode.darken,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Form(
                  key: formKey,
                  // ignore: deprecated_member_use
                  autovalidate: _autoValidate,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            image == null
                                ? Image.file(File(prevImage))
                                : Image.file(File(image!.path),
                                    width: 200, fit: BoxFit.cover),
                            TextButton(
                                onPressed: () {
                                  filePicker();
                                },
                                child: const Text("Select Image")),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _movienameController,
                              keyboardType: TextInputType.text,
                              validator: (s) {
                                if (s!.isEmpty) {
                                  return "Required";
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Name of the Movie",
                                  labelText: "Enter Name of the Movie"),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _directorController,
                              keyboardType: TextInputType.text,
                              validator: (s) {
                                if (s!.isEmpty) {
                                  return "Required";
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Director's Name",
                                  labelText: "Enter Director's Name"),
                            ),
                            SizedBox(height: 20),
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: () {
                                if (validate() && (image != null)) {
                                  editMovie();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Text("Add to List"),
                              color: Color.fromRGBO(250, 102, 89, 0.8),
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            )
          ],
        ));
  }
}
