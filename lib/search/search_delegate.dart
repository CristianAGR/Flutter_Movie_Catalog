

import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

// searchDelegate nos facilita realizar busquedas dentro de la aplicacion
class MovieSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
     IconButton(
      onPressed: () =>  query = '', 
      icon: const Icon( Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
     return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: const Icon( Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }


  Widget _emptyContainer() {
return Container(
        child: const Center(
          child: Icon( Icons.movie_creation_outlined, color: Colors.black38, size: 130,),
        ),
      );
  }

  // el buildSuggestions se dispara cada vez que se toca una tecla
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      _emptyContainer();
    }

    //print('http request');

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false); 
    moviesProvider.getSuggestionsByQuery(query);

    // streamBuilder solo se redibujara cuando el suggestionStream emite un valor
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot){

        if ( !snapshot.hasData ) return _emptyContainer();
        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _, int index) => _MovieItem(movies[index])
        );

      },
      );
  }

}
class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${ movie.id }';

    return ListTile(
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: movie);
        },
    );
  }

}

