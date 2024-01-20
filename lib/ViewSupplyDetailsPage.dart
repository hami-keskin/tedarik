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
  bool hasApplied = false;

  @override
  void initState() {
    super.initState();
    supply = widget.supply;
    _checkApplicationStatus();
  }

  // Function to check if the user has already applied
  void _checkApplicationStatus() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if the user has an application for this supply
    if (supply.applications.any((app) => app.applicantId == userId)) {
      setState(() {
        hasApplied = true;
      });
    }
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
            if (!hasApplied) ...[ // Show the button only if the user hasn't applied
              ElevatedButton(
                onPressed: () {
                  _showApplyDialog(context);
                },
                child: const Text('Tedariğe Başvur'),
              ),
            ],
            if (hasApplied) ...[ // Show the "Başvuruyu Geri Çek" button only if the user has applied
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _showWithdrawDialog(context);
                },
                child: const Text('Başvuruyu Geri Çek'),
              ),
            ],
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
      shrinkWrap: true, // Add this line
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
      shrinkWrap: true, // Add this line
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

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Başvuruyu Geri Çek'),
          content: const Text('Bu tedariğe yapmış olduğunuz başvuruyu geri çekmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                await _withdrawApplication(context);
              },
              child: const Text('Geri Çek'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyToSupply(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

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
          hasApplied = true; // User has applied
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

  Future<void> _withdrawApplication(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if supply.getId is not null before using it
    if (supply.getId != null) {
      final application = SupplyApplication(applicantId: userId, supplyId: supply.getId!, status: 'pending');

      try {
        // Remove the user's application from the applications list in Firestore
        await FirebaseFirestore.instance.collection('supplies').doc(supply.getId).update({
          'applications': FieldValue.arrayRemove([application.toMap()])
        });

        // Retrieve the updated supply with applications
        final updatedSupply = await FirebaseFirestore.instance.collection('supplies').doc(supply.getId).get();
        final updatedSupplyObject = Supply.fromMap(updatedSupply.data() as Map<String, dynamic>);

        // Update the local supply object
        setState(() {
          supply.applications = updatedSupplyObject.applications;
          hasApplied = false; // User has withdrawn application
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Başvurunuz başarıyla geri çekildi.')),
        );
        Navigator.pop(context);
      } catch (error) {
        // Handle any errors that may occur during the withdrawal process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Başvuru geri çekme sırasında bir hata oluştu: ${error.toString()}')),
        );
      }
    } else {
      // Handle the case where supply.getId is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başvuru geri çekmede bir hata oluştu: Tedariğin ID bilgisi bulunamadı.')),
      );
    }
  }
}