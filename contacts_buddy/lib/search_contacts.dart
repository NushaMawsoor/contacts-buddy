import 'database/Model.dart';

import 'database/utility.dart';

import 'package:flutter/material.dart';
import 'database/database_manager.dart';

class SearchContacts extends StatefulWidget {
  @override
  _SearchContactsState createState() => _SearchContactsState();
}

class _SearchContactsState extends State<SearchContacts> {
  TextEditingController searchController = TextEditingController();
  final DbManager dbManager = new DbManager();
  List<Model> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String query = searchController.text;
  if (query .isEmpty) {               
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Semantics(
      label: "empty field validation",
      child: Text("the fields can not be empty!"),
    ),
  ),
);
return;
}
 searchResults = await dbManager.searchContacts(query);
                setState(() {}); // Trigger a rebuild to show the results
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  Model result = searchResults[index];
                  return SearchResultItem(result);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final Model result;

  SearchResultItem(this.result);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: result.photoName != null
            ? CircleAvatar(
                backgroundImage: MemoryImage(
                  Utility.dataFromBase64String(result.photoName!),
                ),
              )
            : CircleAvatar(),
        title: Text(result.personName ?? ''),
        subtitle: Text(result.number ?? ''),
        // Add more fields if needed
        onTap: () {
          // Handle item tap, e.g., navigate to a detailed view
          // You can use the 'result' object for additional information
        },
      ),
    );
  }
}
