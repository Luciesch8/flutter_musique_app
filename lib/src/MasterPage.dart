import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_musique_app/src/MenuGlissant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Master.dart';
import 'VersionPage.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({Key? key, required this.nom, required this.id})
      : super(key: key);

  final int id;
  final String nom;

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int get id => widget.id;

  List<Master> masters = [];
  int page = 1;
  int page_total = 1;

  Future<void> getData(int page) async {
    this.page = page;

    if (page == 1) {
      masters = [];
    }
    var response = await http.get(
      Uri.parse(
          "https://api.discogs.com/artists/$id/releases?sort=year&page=$page&per_page=20"),
      headers: {
        HttpHeaders.authorizationHeader:
            'Discogs token=HQbDeyffXGfkKLBCViolfEjWwfdsDrRahgAhFArh',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        dynamic j = json.decode(response.body);
        page_total = j['pagination']['pages'];
        List releases = j['releases'];
        masters =
            masters + releases.map((obj) => Master.fromJson(obj)).toList();
      });
    } else {
      throw Exception('Failed to load artists from API');
    }
  }

  @override
  void initState() {
    getData(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nom)),
      drawer: MenuGlissant(),
      body: ListView.builder(
          itemCount: masters.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == masters.length - 10 && page < page_total) {
              getData(page + 1);
            }
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: masters[index].vignette,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/singer.webp'),
              ),
              title: Text(masters[index].nom),
              subtitle: Text(masters[index].annee),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VersionPage(
                          id: masters[index].id, nom: masters[index].nom),
                    ));
              },
            );
          }),
    );
  }
}
