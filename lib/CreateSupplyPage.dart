import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateSupplyPage extends StatefulWidget {
  const CreateSupplyPage({Key? key, this.supply}) : super(key: key);

  final Supply? supply;

  @override
  State<CreateSupplyPage> createState() => _CreateSupplyPageState();
}

class _CreateSupplyPageState extends State<CreateSupplyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  List<File> files = [];

  @override
  void initState() {
    super.initState();
    if (widget.supply != null) {
      titleController.text = widget.supply!.title;
      descriptionController.text = widget.supply!.description;
      industryController.text = widget.supply!.industry;
      files = widget.supply!.files;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tedariğini Oluştur'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Tedariğin Başlığı'),
                validator: (value) => value?.isEmpty ?? true ? 'Başlık gereklidir.' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Tedariğin Açıklaması'),
                maxLines: 5,
              ),
              TextFormField(
                controller: industryController,
                decoration: const InputDecoration(labelText: 'Tedariğin Sektörü'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() => files.add(File(pickedFile.path)));
                  }
                },
                child: const Text('Dosya Ekle'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final userId = FirebaseAuth.instance.currentUser!.uid;

                    if (widget.supply != null) {
                      // If supply is not null, update the existing supply
                      await FirebaseFirestore.instance.collection('supplies').doc(widget.supply!.getId).update(
                        {
                          'title': titleController.text,
                          'description': descriptionController.text,
                          'industry': industryController.text,
                          'files': files.map((file) => file.path).toList(),
                        },
                      );
                    } else {
                      // If supply is null, create a new supply
                      final supply = Supply(
                        title: titleController.text,
                        description: descriptionController.text,
                        industry: industryController.text,
                        files: files,
                        sharedBy: userId,
                      );

                      final docRef = await FirebaseFirestore.instance.collection('supplies').add(supply.toMap());

// Set the ID after adding the document to Firestore
                      supply.setId(docRef.id);

// Add the ID to the map before writing to Firestore
                      await docRef.update({'id': supply.getId});
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tedariğiniz başarıyla paylaşıldı.')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Tedariğini Paylaş'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Supply {
  String title;
  String description;
  String industry;
  List<File> files;
  String sharedBy;
  List<SupplyApplication> applications;
  String? id;

  String? get getId => id;

  Supply({
    required this.title,
    required this.description,
    required this.industry,
    this.files = const [],
    required this.sharedBy,
    this.applications = const [],
    this.id,
  });

  // Add a method to set the ID
  void setId(String id) {
    this.id = id;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'industry': industry,
      'files': files.map((file) => file.path).toList(),
      'sharedBy': sharedBy,
      'applications': applications.map((application) => application.toMap()).toList(),
    };
  }
  Map<String, dynamic> toMapWithApplications() {
    return {
      'title': title,
      'description': description,
      'industry': industry,
      'files': files.map((file) => file.path).toList(),
      'sharedBy': sharedBy,
      'applications': applications.map((application) => application.toMap()).toList(),
    };
  }


  factory Supply.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('map cannot be null');
    }

    return Supply(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      industry: map['industry'] ?? '',
      files: (map['files'] as List<dynamic>? ?? []).map((filePath) => File(filePath.toString())).toList(),
      sharedBy: map['sharedBy'] ?? '',
      applications: (map['applications'] as List<dynamic>? ?? []).map((appMap) => SupplyApplication.fromMap(appMap)).toList(),
    );
  }
}


class SupplyApplication {
  String applicantId;
  String supplyId;
  String status;

  SupplyApplication({
    required this.applicantId,
    required this.supplyId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'applicantId': applicantId,
      'supplyId': supplyId,
      'status': status,
    };
  }

  factory SupplyApplication.fromMap(Map<String, dynamic> map) {
    return SupplyApplication(
      applicantId: map['applicantId'],
      supplyId: map['supplyId'],
      status: map['status'],
    );
  }
}
