import 'package:flutter/material.dart';

class HelpDetail2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tedarik Oluştur Yardımı'),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tedarik Oluştur Yardımı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. "Tedarik Oluştur" butonuna tıklayın.',
            ),
            SizedBox(height: 8),
            Text(
              '2. Açılan sayfada tedarik bilgilerini eksiksiz doldurun.',
            ),
            SizedBox(height: 8),
            Text(
              '3. Gerekli alanları doldurduktan sonra "Oluştur" butonuna tıklayarak tedarik oluşturun.',
            ),
            SizedBox(height: 8),
            Text(
              '4. Başarıyla oluşturulan tedarik sayfanıza eklenecektir.',
            ),
          ],
        ),
      ),
    );
  }
}
