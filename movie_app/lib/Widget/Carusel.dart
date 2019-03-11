import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/Widget/MovieDetail.dart';
import 'package:movie_app/helper/Tmdb.dart';
import 'package:movie_app/model/movieModel.dart';
import 'package:intl/intl.dart';


class Carousel extends StatefulWidget{


  final Movie items;
  const Carousel({Key key, this.items}): super(key: key);

  @override
  _Carousel createState() => new _Carousel();
}

class _Carousel extends State<Carousel>{

  int heroTag = 0;
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {

    return CarouselSlider(
        items: widget.items == null ? <Widget>[Center(child: CircularProgressIndicator())] :
        widget.items.results
            .map((movieItem)=> _buildMovieItem (movieItem))
            .toList(),
        autoPlay: false,
        height: 240.0,
        viewportFraction: 0.5,
        enlargeCenterPage: true,
    );
  }

  Widget _buildMovieItem(Results movieItem) {
    heroTag += 1;
    movieItem.heroTag = heroTag;
    return Material(
        elevation: 30.0,
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> MovieDetail(movie: movieItem)
               )
              );
            },
            child: Hero(
              tag: heroTag,
              child: Image.network(
                  "${Tmdb.baseImagesUrl}w342${movieItem.posterPath}",
                  fit: BoxFit.cover),
            )));
  }


}