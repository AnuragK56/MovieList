import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movielist/model/movielist_model.dart';
import 'package:movielist/pages/home_page.dart';

class AddMovie extends StatefulWidget {
  static const String routeName = "/addmovie";
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final formKey = GlobalKey<FormState>();
  final _movienameController = TextEditingController();
  final _directorController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final snackBar =
      SnackBar(content: Text('Yay! Movie added to the list succesfully!'));
  XFile? image;
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

  Future addMovie() async {
    final file = image; // File
    final imageBytes = await file!.readAsBytes(); // Uint8List
    var name = _movienameController.text;
    var director = _directorController.text;
    final movie = MovieModel(name, imageBytes, director);
    final box = await Hive.openBox<MovieModel>('movielist');
    print(box.keys);
    print("hasddaadad");
    box.add(movie);
    print(box.keys);
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
          title: Text("Add new Movie"),
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
              "assets/bg.jpg",
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
                                ? Text("No Image Found")
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
                                if (validate() && image != null) {
                                  addMovie();
                                  Navigator.pushReplacementNamed(
                                      context, HomePage.routeName);
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
