import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'CreateSupplyPage.dart';
import 'ViewSupplyDetailsPage.dart';

class ViewSuppliesPage extends StatefulWidget {
  const ViewSuppliesPage({Key? key}) : super(key: key);

  @override
  State<ViewSuppliesPage> createState() => _ViewSuppliesPageState();
}

class _ViewSuppliesPageState extends State<ViewSuppliesPage> {
  final Stream<QuerySnapshot> _suppliesStream =
  FirebaseFirestore.instance.collection('supplies').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tedarik Listesi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _suppliesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final supplies = snapshot.data!.docs
              .map((doc) => Supply.fromMap(doc.data() as Map<String, dynamic>?))
              .toList();

          return ListView.builder(
            itemCount: supplies.length,
            itemBuilder: (context, index) {
              final supply = supplies[index];
              return Card(
                child: ListTile(
                  title: Text(supply.title),
                  subtitle: Text(supply.industry),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewSupplyDetailsPage(supply: supply),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
