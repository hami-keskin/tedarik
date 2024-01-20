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
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Text('Tedarik Listesi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? result = await showSearch<String>(
                context: context,
                delegate: _SupplySearchDelegate(),
              );

              if (result != null && result.isNotEmpty) {
                // Handle the search result if needed
                // For example, you can navigate to the details page of the found supply
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('supplies').snapshots(),
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

class _SupplySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final Stream<QuerySnapshot> searchStream = FirebaseFirestore.instance
        .collection('supplies')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: searchStream,
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
            return ListTile(
              title: Text(supply.title),
              subtitle: Text(supply.industry),
              onTap: () {
                // Navigate to the detail page when a search result is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSupplyDetailsPage(supply: supply),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
