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
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: const Text('Tedariğini Oluştur'),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
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
                    SizedBox(height: 8), // Reduced from 10 to 8

                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Tedariğin Açıklaması'),
                      maxLines: 5,
                    ),
                    SizedBox(height: 8), // Reduced from 10 to 8

                    TextFormField(
                      controller: industryController,
                      decoration: const InputDecoration(labelText: 'Tedariğin Sektörü'),
                    ),
                    SizedBox(height: 16), // Reduced from 30 to 16

                    Container(
                      height: 56, // Reduced from 64 to 56
                      child: ElevatedButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() => files.add(File(pickedFile.path)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          fixedSize: Size(MediaQuery.of(context).size.width / 2, 0),
                          minimumSize: Size(MediaQuery.of(context).size.width / 2, 56), // Reduced from 64 to 56
                          textStyle: TextStyle(color: Colors.black),
                        ),
                        child: Text(
                          'Dosya Ekle',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 12), // Reduced from 20 to 12

                    Container(
                      height: 56, // Reduced from 64 to 56
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final userId = FirebaseAuth.instance.currentUser!.uid;

                            if (widget.supply != null) {
                              await FirebaseFirestore.instance.collection('supplies').doc(widget.supply!.getId).update(
                                {
                                  'title': titleController.text,
                                  'description': descriptionController.text,
                                  'industry': industryController.text,
                                  'files': files.map((file) => file.path).toList(),
                                },
                              );
                            } else {
                              final supply = Supply(
                                title: titleController.text,
                                description: descriptionController.text,
                                industry: industryController.text,
                                files: files,
                                sharedBy: userId,
                              );

                              final docRef = await FirebaseFirestore.instance.collection('supplies').add(supply.toMap());

                              supply.setId(docRef.id);

                              await docRef.update({'id': supply.getId});
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tedariğiniz başarıyla paylaşıldı.')),
                            );

                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          fixedSize: Size(MediaQuery.of(context).size.width / 2, 0),
                          minimumSize: Size(MediaQuery.of(context).size.width / 2, 56), // Reduced from 64 to 56
                          textStyle: TextStyle(color: Colors.black),
                        ),
                        child: Text(
                          'Tedariğini Paylaş',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ); // Closing parenthesis added here
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
