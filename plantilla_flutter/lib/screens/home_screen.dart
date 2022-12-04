import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    //print(moviesProvider.onDisplayMovie);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'Cartellera',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                // metode per realitzar la busqueda, declarada la classe mes abaix
                showSearch(
                    context: context,
                    delegate: MySearchDelegate(moviesProvider
                        .onDisplayMovie)); // l'hi passam una llista de peliculas
              },
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          height: 1000,
          child: Column(
            children: [
              // Targetes principals
              CardSwiper(
                  movies: moviesProvider
                      .onDisplayMovie), // passam el provider de les peliculas en general

              // Slider de pel·licules
              MovieSlider(
                  movies: moviesProvider
                      .onPopularMovie), // pasam el provider de les populars
              // Poodeu fer la prova d'afegir-ne uns quants, veureu com cada llista és independent
              // MovieSlider(),
              // MovieSlider(),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  // he intentat
  final List<Movie>
      listapelis; // cream un constructor per rebre una llista de pelicules que passam mes a dalt
  MySearchDelegate(this.listapelis);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // part per borrar la query amb l'icone
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // realment el que tenc amb aquest metode es treure la llista de peliculas y clicar el valor que volem
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return TextField(onSubmitted: (value) {
      print(value);
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // aqui he fet un listview amb la llista de pelicules, amb el .title per treure nomes el nom
    return ListView.builder(
        itemCount: listapelis.length,
        itemBuilder: (context, index) {
          final suggestion = listapelis[index].title;

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query =
                  suggestion; // una vegada fas click al nom de la pelicula, introduire la pelicula a una Movie independent, la cual enviare a amb pushnames a la finestra details.
              for (int i = 0; i < listapelis.length; i++) {
                if (listapelis[i].title == query) {
                  Movie enviar = listapelis[i];
                  Navigator.pushNamed(context, 'details', arguments: enviar);
                }
              }

              showResults(context);
            },
          );
        });
  }
}
