import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = 'cd1a938bb324f711099221a6c47551fe';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  // debouncer
  final debouncer = Debouncer(
    duration: const Duration( milliseconds: 500),
  );

  // emitira una lista de movie
  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream <List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider() {
    // MoviesProvider inicializado

    getOnDisplayMovies();
    getPopularMovies();
  }

  // la pagina es opcional y si no se incerta el valor es 1 "[int page = 1]"
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
         final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
      });

  // Await the http get response, then decode the json-formatted response.
  final response = await http.get(url);
  return response.body;
  }

  getOnDisplayMovies() async {

  final jsonData = await _getJsonData('3/movie/now_playing');
  final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
  //final decodedData = json.decode(response.body) as Map<String, dynamic>;
  //if(response.statusCode != 200) return print('error');
  //print(decodedData['results']);
  //print(nowPlayingResponse.results[1].title);
  onDisplayMovies = nowPlayingResponse.results;

  // cuando ocupamos redibujar widgets se usa el sig metodo que notifica a los widgets cuando hay un cambio
  notifyListeners();
  }

  getPopularMovies() async {
  _popularPage++;

  final jsonData = await _getJsonData('3/movie/popular', _popularPage);
  final popularResponse = PopularResponse.fromJson(jsonData);

  // se concatenan las películas ya cargadas con las nuevas
  popularMovies = [ ...popularMovies, ...popularResponse.results];
  //print(popularMovies[1]);
  notifyListeners();
  }

  Future <List<Cast>> getMovieCast( int movieId ) async {
    // revisar el mapa para saber si ya se encuentra el elemento en el mapa
    if( moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    // se pide la info al servidor
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    // almacenamos el mapa
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  // buscar peliculas
  // el stream va a estar emitiendo los valores cada que el debouncer emite un valor
  Future <List<Movie>> searchMovies( String query ) async {
     final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
      });

      final response = await http.get(url);
      final searchResponse = SearchMoviesResponse.fromJson(response.body);

      return searchResponse.results;
  }

  // hace uso del debouncer para obtener el valor solo cuando padse la duracion indicada
  void getSuggestionsByQuery( String searchTerm) {

    debouncer.value = '';
    debouncer.onValue =(value) async{
      //print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      // emite un valor al streamController
      this._suggestionStreamController.add( results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), ( _ ) {
      debouncer.value = searchTerm;
     });

     Future.delayed(Duration(milliseconds: 301)).then(( _ ) => timer.cancel());
  }
}