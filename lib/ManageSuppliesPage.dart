import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'CreateSupplyPage.dart';

class ManageSuppliesPage extends StatefulWidget {
  const ManageSuppliesPage({Key? key}) : super(key: key);

  @override
  State<ManageSuppliesPage> createState() => _ManageSuppliesPageState();
}

class _ManageSuppliesPageState extends State<ManageSuppliesPage> {
  Stream<QuerySnapshot> _suppliesStream =
  FirebaseFirestore.instance.collection('supplies').where('sharedBy', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tedarik Yönetimi'),
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

          final supplies = snapshot.data!.docs.map((doc) {
            final supply = Supply.fromMap(doc.data() as Map<String, dynamic>?);
            supply.id = doc.id;  // Assign the document ID to the Supply object
            return supply;
          }).toList();

          return ListView.builder(
            itemCount: supplies.length,
            itemBuilder: (context, index) {
              final supply = supplies[index];
              return Card(
                child: ListTile(
                  title: Text(supply.title),
                  subtitle: Text(supply.industry),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateSupplyPage(supply: supply),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) => _buildDeleteDialog(context),
                          );

                          if (confirm == true) {
                            try {
                              await FirebaseFirestore.instance.collection('supplies').doc(supply.getId).delete();
                              // Refresh the stream after successful deletion
                              _suppliesStream =
                                  FirebaseFirestore.instance.collection('supplies').where('sharedBy', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tedariğiniz başarıyla silindi.'),
                                ),
                              );
                            } catch (error) {
                              _handleDeleteError(context, error);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDeleteDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Tedariğin Silinmesi'),
      content: const Text('Tedariği silmek istediğinize emin misiniz?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Sil'),
        ),
      ],
    );
  }

  void _handleDeleteError(BuildContext context, dynamic error) {
    print('Silme işlemi sırasında bir hata oluştu: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tedariğin silinmesi sırasında bir hata oluştu. Lütfen tekrar deneyin.'),
      ),
    );
  }
}