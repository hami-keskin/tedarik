import 'package:flutter/material.dart';
import 'package:tedarik/ViewSuppliesPage.dart';
import 'package:tedarik/ManageSuppliesPage.dart'; // Add the import for ManageSuppliesPage
import 'package:tedarik/screens/help/HelpScreen.dart';

import '../../services/Auth.dart';
import '../../CreateSupplyPage.dart';



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
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: const Text('OMU TEDARİK'),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("lib/images/logo.PNG"),
              width: 300,
              height: 150,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateSupplyPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              fixedSize: Size(MediaQuery.of(context).size.width / 2, 64),
              textStyle: TextStyle(color: Colors.black),
            ),
            child: Row(
              children: [
                Icon(Icons.create, color: Colors.black),
                SizedBox(width: 20),
                Text(
                  'Tedarik Oluştur',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),




          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageSuppliesPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              fixedSize: Size(MediaQuery.of(context).size.width / 2, 0), // Genişliği ekranın yarısı kadar yap
              minimumSize: Size(MediaQuery.of(context).size.width / 2, 64), // Yüksekliği iki katına çıkar
              textStyle: TextStyle(color: Colors.black),
            ),
            child: Row(
              children: [
                Icon(Icons.manage_search,color: Colors.black,), // İlk butonun başına bir icon ekleyin
                SizedBox(width: 20), // Icon ile metin arasına bir boşluk ekleyin
                Text(
                  'Tedarik Yönetimi',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),


          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewSuppliesPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              fixedSize: Size(MediaQuery.of(context).size.width / 2, 0), // Genişliği ekranın yarısı kadar yap
              minimumSize: Size(MediaQuery.of(context).size.width / 2, 64), // Yüksekliği iki katına çıkar
              textStyle: TextStyle(color: Colors.black),
            ),
            child: Row(
              children: [
                Icon(Icons.list,color: Colors.black,), // İlk butonun başına bir icon ekleyin
                SizedBox(width: 20), // Icon ile metin arasına bir boşluk ekleyin
                Text('Tedarik Listesi',style: TextStyle(color: Colors.black),),
              ],
            ),
          ),


          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              fixedSize: Size(MediaQuery.of(context).size.width / 2, 0), // Genişliği ekranın yarısı kadar yap
              minimumSize: Size(MediaQuery.of(context).size.width / 2, 64), // Yüksekliği iki katına çıkar
              textStyle: TextStyle(color: Colors.black),
            ),
            child: Row(
              children: [
                Icon(Icons.help,color: Colors.black,), // İlk butonun başına bir icon ekleyin
                SizedBox(width: 20), // Icon ile metin arasına bir boşluk ekleyin
                Text('Yardım',style: TextStyle(color: Colors.black),),
              ],
            ),
          ),

          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16.0),
              fixedSize: Size(MediaQuery.of(context).size.width / 2, 0), // Genişliği ekranın yarısı kadar yap
              minimumSize: Size(MediaQuery.of(context).size.width / 2, 64), // Yüksekliği iki katına çıkar
              textStyle: TextStyle(color: Colors.black),
            ),
            child: Row(
              children: [
                Icon(Icons.exit_to_app,color: Colors.black,), // İlk butonun başına bir icon ekleyin
                SizedBox(width: 20), // Icon ile metin arasına bir boşluk ekleyin
                Text('Çıkış',style: TextStyle(color: Colors.black),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

