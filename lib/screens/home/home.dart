import 'package:flutter/material.dart';
import 'package:tedarik/ViewSuppliesPage.dart';

import '../../services/Auth.dart';
import '../../CreateSupply.dart';
import '../../ViewSuppliesPage.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Demo App - HomePage'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CreateSupply sayfasını açan buton
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateSupplyPage()),
                );
              },
              child: Text('Tedariğini Oluştur'),
            ),
            SizedBox(height: 16),
            // ViewFilesPage sayfasını açan buton (geçici olarak disabled)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewSuppliesPage()),
                );
              },
              child: Text('Tedarik Listesi'),
            ),
            SizedBox(height: 32),
            // Log out butonu
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Theme.of(context).primaryColor,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Text(
                  "Log out",
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
