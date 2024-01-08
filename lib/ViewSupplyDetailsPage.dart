import 'dart:io';

import 'package:flutter/material.dart';

import 'CreateSupply.dart';

class ViewSupplyDetailsPage extends StatelessWidget {
  final Supply supply;

  const ViewSupplyDetailsPage({Key? key, required this.supply}) : super(key: key);

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
              Text('Dosyalar:', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildFilesList(supply.files),
            ],
            if (supply.applications.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text('Başvurular:', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildApplicationsList(supply.applications),
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
}
