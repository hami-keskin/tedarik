import 'package:flutter/material.dart';
import 'package:tedarik/screens/help/HelpDetail1.dart';
import 'package:tedarik/screens/help/HelpDetail2.dart';
import 'package:tedarik/screens/help/HelpDetail3.dart';
import 'package:tedarik/screens/help/HelpDetail4.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yardım'),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height:70),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpDetail1()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                backgroundColor: Theme.of(context).primaryColorLight,
                textStyle: TextStyle(color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help, color: Colors.black),
                  SizedBox(width: 20),
                  Text(
                    'Kullanıcı Bilgilerimi Nasıl Değiştirebilirim',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpDetail2()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                backgroundColor: Theme.of(context).primaryColorLight,
                textStyle: TextStyle(color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help, color: Colors.black),
                  SizedBox(width: 20),
                  Text(
                    'Tedarik Oluşturamıyorum',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpDetail3()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                backgroundColor: Theme.of(context).primaryColorLight,
                textStyle: TextStyle(color: Colors.black),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help, color: Colors.black),
                  SizedBox(width: 20),
                  Text('Donma Sorunları Yaşıyorum',style: TextStyle(color: Colors.black),),
                ],
              ),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpDetail4()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                backgroundColor: Theme.of(context).primaryColorLight,
                textStyle: TextStyle(color: Colors.black),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help, color: Colors.black),
                  SizedBox(width: 20),
                  Text('Başka Bir Konuda Yardım Almak İstiyorum',style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
