

import 'package:flutter/material.dart';

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
      icon: Icon( Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
     return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: Icon( Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        child: const Center(
          child: Icon( Icons.movie_creation_outlined, color: Colors.black38, size: 100,),
        ),
      );
    }

    return Container();
  }

}