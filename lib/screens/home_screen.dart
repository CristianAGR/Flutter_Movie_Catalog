import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // crear instancia de MoviesProvider
    // se especifica a que provider tiene que buscar entrando al arbol de widgets y regresa la primera instancia que encuentra
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    //print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon: const Icon(Icons.search_outlined)
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          // Tarjetas principaled}
          CardSwiper(movies: moviesProvider.onDisplayMovies ),

          // Slider horizontal de películas
          MovieSlider( 
            movies: moviesProvider.popularMovies,
            title: 'Populares', //opcional
            onNextPage: () => moviesProvider.getPopularMovies()
          ),
        ],
      ),
      )
    );
  }
}