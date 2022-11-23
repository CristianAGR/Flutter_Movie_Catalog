

import 'package:flutter/material.dart';

// searchDelegate nos facilita realizar busquedas dentro de la aplicacion
class MovieSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      const Text('buildActions')
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
     return const Text('buildLeading');
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('buildSuggestions: $query');
  }

}