import 'package:hive/hive.dart';
import 'package:movielist/model/movielist_model.dart';

class Boxes {
  static Box<MovieModel> getMovies() => Hive.box<MovieModel>('movielist');
}
