import 'package:flutter/material.dart';

class MenuGlissant extends Drawer {
  MenuGlissant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          ListTile(
            title: Text('Wants List'),
            leading: Icon(Icons.heart_broken),
          ),
          ListTile(title: Text('Scan'), leading: Icon(Icons.scanner)),
        ],
      ),
    );
  }
}
