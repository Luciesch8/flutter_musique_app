import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_musique_app/src/MenuGlissant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Version.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({Key? key, required this.nom, required this.id})
      : super(key: key);

  final int id;
  final String nom;

  @override
  State<VersionPage> createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  int get id => widget.id;

  List<Version> versions = [];
  int page = 1;
  int page_total = 1;

  Future<void> putWantsList(int idversion) async {
    var response = await http.put(
      Uri.parse("https://api.discogs.com/users/i2m/wants/$idversion"),
      headers: {
        HttpHeaders.authorizationHeader:
            'Discogs token=HQbDeyffXGfkKLBCViolfEjWwfdsDrRahgAhFArh',
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Ajouté à votre liste"),
    ));
  }

  Future<void> getData(int page) async {
    this.page = page;

    if (page == 1) {
      versions = [];
    }
    var response = await http.get(
      Uri.parse(
          "https://api.discogs.com/masters/$id/versions?page=$page&per_page=20"),
      headers: {
        HttpHeaders.authorizationHeader:
            'Discogs token=HQbDeyffXGfkKLBCViolfEjWwfdsDrRahgAhFArh',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        dynamic j = json.decode(response.body);
        page_total = j['pagination']['pages'];
        List liste = j['versions'];
        versions =
            versions + liste.map((obj) => Version.fromJson(obj)).toList();
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
          itemCount: versions.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == versions.length - 10 && page < page_total) {
              getData(page + 1);
            }
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: versions[index].vignette,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/singer.webp'),
              ),
              title: Text(versions[index].format),
              subtitle:
                  Text(versions[index].label + " " + versions[index].country),
              onTap: () {
                putWantsList(versions[index].id);
              },
            );
          }),
    );
  }
}
