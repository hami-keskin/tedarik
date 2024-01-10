import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'CreateSupplyPage.dart';

class ViewSupplyDetailsPage extends StatefulWidget {
  final Supply supply;

  const ViewSupplyDetailsPage({Key? key, required this.supply}) : super(key: key);

  @override
  _ViewSupplyDetailsPageState createState() => _ViewSupplyDetailsPageState();
}

class _ViewSupplyDetailsPageState extends State<ViewSupplyDetailsPage> {
  late Supply supply;

  @override
  void initState() {
    super.initState();
    supply = widget.supply;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supply.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Başlık:', supply.title),
            _buildInfoRow('Açıklama:', supply.description),
            _buildInfoRow('Sektör:', supply.industry),
            _buildInfoRow('Paylaşan:', supply.sharedBy),
            if (supply.files.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              _buildSection('Dosyalar:', _buildFilesList(supply.files)),
            ],
            if (supply.applications.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              _buildSection('Başvurular:', _buildApplicationsList(supply.applications)),
            ],
            ElevatedButton(
              onPressed: () {
                _showApplyDialog(context);
              },
              child: const Text('Tedariğe Başvur'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content,
      ],
    );
  }

  Widget _buildFilesList(List<File> files) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return ListTile(
          title: Text(file.path),
          // ... diğer dosya bilgileri
        );
      },
    );
  }

  Widget _buildApplicationsList(List<SupplyApplication> applications) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return ListTile(
          title: Text(application.applicantId),
          subtitle: Text(application.status),
          // ... diğer başvuru bilgileri
        );
      },
    );
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tedariğe Başvur'),
          content: const Text('Bu tedariğe başvuruda bulunmak istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                await _applyToSupply(context);
              },
              child: const Text('Başvur'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyToSupply(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Debug print to check the value of supply.getId
    print('Supply ID: ${supply.getId}');

    // Check if supply.getId is not null before using it
    if (supply.getId != null) {
      final application = SupplyApplication(applicantId: userId, supplyId: supply.getId!, status: 'pending');

      try {
        // Update the applications list in Firestore
        await FirebaseFirestore.instance.collection('supplies').doc(supply.getId).update({
          'applications': FieldValue.arrayUnion([application.toMap()])
        });

        // Retrieve the updated supply with applications
        final updatedSupply = await FirebaseFirestore.instance.collection('supplies').doc(supply.getId).get();
        final updatedSupplyObject = Supply.fromMap(updatedSupply.data() as Map<String, dynamic>);

        // Update the local supply object
        setState(() {
          supply.applications = updatedSupplyObject.applications;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Başvurunuz başarıyla gönderildi.')),
        );
        Navigator.pop(context);
      } catch (error) {
        // Handle any errors that may occur during the application process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Başvuru sırasında bir hata oluştu: ${error.toString()}')),
        );
      }
    } else {
      // Handle the case where supply.getId is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başvuruda bir hata oluştu: Tedariğin ID bilgisi bulunamadı.')),
      );
    }
  }

}