import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {
    final List<Movie> movies;
    final String? title;
    final Function onNextPage;

  const MovieSlider({super.key, required this.movies, required this.onNextPage, this.title});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = new ScrollController();

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() { 

     if ( scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500) {
      // Llamar provider
      widget.onNextPage();
      //print('Obtener siguiente página');
     }
     //print(scrollController.position.pixels);
     //print(scrollController.position.maxScrollExtent);
    });
  }

  // cuando el widget va a ser destruido
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // si no hay titulo no se debe de mostrar este widget
          if (widget.title != null)
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 20),
          child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),

          const SizedBox(height: 5,),

          Expanded(
            // crea el slideshow que se hizo
            child: ListView.builder(
              controller: scrollController, // se asocia el scrollController al listView
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              // se crea el item MoviePoster y el id para Hero
              itemBuilder: (_, int index) =>  _MoviePoster(movie: widget.movies[index], heroId: '${widget.title}-$index-${widget.movies[index].id}')
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;

  const _MoviePoster({super.key, required this.movie, required this.heroId});

  @override
  Widget build(BuildContext context) {
        // media query nos facilita la info del dispositivo
    final size = MediaQuery.of(context).size;

    if( movie.posterPath == null) {
       return Container(
        width: 130,
        height: 190,
        child: const Center(
          child: CircularProgressIndicator(),
          ),
       );
    }

    movie.heroId = heroId;
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        children: [

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            // el widget Hero hace la HeroAnimation
            child: Hero(
              // el tag del hero animation debe ser unico en todos los widgets
              tag: movie.heroId!,
              // genera el item de película
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover
                ),
              ),
            ),
          ),

          const SizedBox( height: 5,),

          Text(movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}