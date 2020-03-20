import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:flutter_app/AlgoliaApplication.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("Posts").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Learning Algolia", style:TextStyle(color: Colors.black),),
          ),
        body: SingleChildScrollView(
                  child: Column(
            children:<Widget>[ 
              TextField(
                  onChanged: (val) {
                  setState(() {
                    _searchTerm = val;
                  });
                },
                style: new TextStyle(color: Colors.black, fontSize: 20),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search ...',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.search, color: Colors.black
              ))),
              StreamBuilder<List<AlgoliaObjectSnapshot>>(
                  stream: Stream.fromFuture(_operation(_searchTerm)),  
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Text("Start Typing", style: TextStyle(color: Colors.black ),);
                    else{
                    List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;

                    switch (snapshot.connectionState) {
                     case ConnectionState.waiting: return Container();
                     default:
                       if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                       else
                    return CustomScrollView(shrinkWrap: true,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            ( context,  index) {
                              return _searchTerm.length > 0 ? DisplaySearchResult(artDes: currSearchStuff[index].data["artShowDescription"], artistName: currSearchStuff[index].data["artistName"], genre: currSearchStuff[index].data["genre"],) :
                              Container();
                              
                            },
                            childCount: currSearchStuff.length ?? 0,
                          ),
                        ),
                    ],
                    ); }}
                  },
                ),
            ]),
        ),
      ),
    );
  }

}

class DisplaySearchResult extends StatelessWidget {
  final String artDes;
  final String artistName;
  final String genre;

  DisplaySearchResult({Key key, this.artistName, this.artDes, this.genre}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(artDes ?? "", style: TextStyle(color: Colors.black ),),
        Text(artistName ?? "", style: TextStyle(color: Colors.black ),),
        Text(genre ?? "", style: TextStyle(color: Colors.black ),),
        Divider(color: Colors.black,),
        SizedBox(height: 20)
      ]
    );
  }
}