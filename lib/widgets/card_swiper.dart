import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movies;
  const CardSwiper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    // media query nos facilita la info del dispositivo
    final size = MediaQuery.of(context).size;

    if( movies.isEmpty) {
       return Container(
        width: double.infinity,
        height: size.height,
        child: const Center(
          child: CircularProgressIndicator(),
          ),
       );
    }

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: ( _ , int index) {

          // obtiene la pelicula de cada index
          final movie = movies[index];
          // crea el id personalizado
          movie.heroId = 'swiper-${movie.id}';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
             // el widget Hero hace la HeroAnimation
            child: Hero(
              // el tag del hero animation debe ser unico en todos los widgets
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius:  BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage( movie.fullPosterImg),
                  fit: BoxFit.cover,
                  ),
              ),
            ),
          );
        },
        ),
    );
  }
}