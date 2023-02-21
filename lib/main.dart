import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_musique_app/src/MasterPage.dart';
import 'package:flutter_musique_app/src/MenuGlissant.dart';
import 'package:flutter/material.dart';
import 'models/Artist.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _ctrlRecherche =
      TextEditingController(); // _ private à la classe
  List<Artist> artists = [];
  int page = 1;
  int page_total = 1;

  Future<void> getData(String pattern, int page) async {
    if (pattern.isEmpty) return;

    this.page = page;

    if (page == 1) {
      artists = [];
    }
    var response = await http.get(
      Uri.parse(
          "https://api.discogs.com/database/search?q=$pattern&type=artist&page=$page&per_page=20"),
      headers: {
        HttpHeaders.authorizationHeader:
            'Discogs token=HQbDeyffXGfkKLBCViolfEjWwfdsDrRahgAhFArh',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        dynamic j = json.decode(response.body);
        page_total = j['pagination']['pages'];
        List results = j['results'];
        artists = artists + results.map((obj) => Artist.fromJson(obj)).toList();
      });
    } else {
      throw Exception('Failed to load artists from API');
    }
  }

  @override
  void initState() {
    _ctrlRecherche = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _ctrlRecherche.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: const Text("Discogs"), actions: <Widget>[
        SizedBox(
            width: 190,
            child: TextFormField(
              controller: _ctrlRecherche,
              onFieldSubmitted: (texte) {
                setState(() {
                  getData(texte, 1);
                });
              },
              onChanged: (texte) {
                if (texte.length < 3) return;
                setState(() {
                  //getData(texte);
                });
              },
            )),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              getData(_ctrlRecherche.text, 1);
            });
          },
        )
      ]),
      drawer: MenuGlissant(),
      body: ListView.builder(
          itemCount: artists.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == artists.length - 10 && page < page_total) {
              getData(_ctrlRecherche.text, page + 1);
            }
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: artists[index].vignette,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/singer.webp'),
              ),
              title: Text(artists[index].nom),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MasterPage(
                          id: artists[index].id, nom: artists[index].nom),
                    ));
              },
            );
          }),
    );
  }
}
