import 'package:flutter/cupertino.dart'; //
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apikey = '152bb81ee798378542bfd32d732eb6ba';
  String _language = 'es-ES';
  String _page = '1';

  List<Movie> onDisplayMovie = []; // llista per treure les peliculas totals

  List<Movie> onPopularMovie = []; // llista de peliculas populars

  Map<int, List<Cast>> casting = {}; // llista per casting d'actors

  MoviesProvider() {
    print("Movies Provider inicialitzat");
    this.getOnDisplayMovies();
    print("Get populars movies");
    this.getOnPopularMovies();
  }

  getOnDisplayMovies() async {
    // metode per critar a les peliculaas totals y ficarles a la llista de ondisplay
    print("Get Display");

    var url = Uri.https(_baseUrl, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language, 'page': _page});

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final nowPlayingResponse = NowPlayingResponse.fromJson(result.body);

    onDisplayMovie = nowPlayingResponse.results;

    notifyListeners();
  }

  getOnPopularMovies() async {
    // metode per ficar les populars a una llista
    print("Get Display popular");

    var url = Uri.https(_baseUrl, '3/movie/popular',
        {'api_key': _apikey, 'language': _language, 'page': _page});

    // Await the http get response, then decode the json-formatted response.
    final resultado = await http.get(url);

    final popularResponse = PopularMovies.fromJson(resultado.body);

    onPopularMovie = popularResponse.results;

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int id) async {
    // metode per agafar els actors, aquest no l'entenc massa
    print("Get Display Cast");

    var url = Uri.https(_baseUrl, '3/movie/$id/credits',
        {'api_key': _apikey, 'language': _language});

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final creditResponse = CreditResponse.fromJson(result.body);

    casting[id] = creditResponse.cast;

    return creditResponse.cast;
  }
}
