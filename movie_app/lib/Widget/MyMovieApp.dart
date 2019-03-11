import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Widget/Carusel.dart';
import 'package:movie_app/Widget/FancyTabBar.dart';
import 'package:movie_app/Widget/ListMovie.dart';
import 'package:movie_app/data/MovieDb.dart';
import 'package:movie_app/helper/Tmdb.dart';
import 'package:movie_app/model/movieModel.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class MyMovieApp extends StatefulWidget {
  @override
  _MyMovieApp createState() => new _MyMovieApp();
}


class _MyMovieApp extends State<MyMovieApp> {

  Movie nowPlayingMovies;
  Movie upcomingMovies;
  Movie popularMovies;
  Movie topRatedMovies;
  int heroTag = 0;
  int _currentIndex = 0;
  int _page = 0;

  MovieDb movieDb = MovieDb();
  Carousel car = Carousel();
  @override
  void initState()  {
    super.initState();
     _fetchNowPlayingMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMovies();
  }

  void _fetchNowPlayingMovies() async{
    var response =await http.get(Tmdb.nowPlayingUrl);
    var decodeJson= jsonDecode(response.body);
    setState(() {
      nowPlayingMovies=Movie.fromJson(decodeJson);
    });
  }

  void _fetchUpcomingMovies() async {
    var response = await http.get(Tmdb.upcomingUrl);
    var decodedJson = jsonDecode(response.body);
    setState(() {
      upcomingMovies = Movie.fromJson(decodedJson);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(Tmdb.popularUrl);
    var decodedJson = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodedJson);
    });
  }

  void _fetchTopRatedMovies() async {
    var response = await http.get(Tmdb.topRatedUrl);
    var decodedJson = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodedJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Movie Fab',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
            return <Widget>[
              SliverAppBar(
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('EN ESTOS MOMENTOS ...',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      Container(
                        child: Image.network("${Tmdb.baseImagesUrl}w500/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg",
                          fit: BoxFit.cover,
                          width: 1000.0,
                          colorBlendMode: BlendMode.dstATop,
                          color: Colors.blue.withOpacity(0.5),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:50.0),
                        child: Column(
                          children: <Widget>[
                            Carousel(items:nowPlayingMovies)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ];
          },
          body:  ListView(
            children: <Widget>[
              ListMovie( items:upcomingMovies, movieListTitle:'COMING SOON'),
              ListMovie( items:popularMovies, movieListTitle:'POPULAR'),
              ListMovie( items:topRatedMovies, movieListTitle:'TOP RATED'),
            ],
          ),
        ),
        bottomNavigationBar:  BottomNavigationBar(
          fixedColor: Colors.lightBlue,
          currentIndex: _currentIndex,
          onTap: (int index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_movies),
              title: Text('All Movies'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tag_faces),
              title: Text('Tickets'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
            )
          ],
        ));

  }


}

