import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Book>>(
        future: DatabaseHelper.instance.readAllBooks(),
        builder: (context, snapshot) => snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Book book = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        minTileHeight: 120,
                        title: Text(book.title),
                        trailing: const Icon(Icons.delete_outline),
                        leading: Image.network(
                          book.imageLinks['thumbnail'] ?? "",
                          fit: BoxFit.cover,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.authors.join(", & ")),
                            ElevatedButton.icon(
                                onPressed: () {
                                  // Toggle Fav Flag
                                },
                                icon: const Icon(Icons.favorite_outline),
                                label: const Text("Add To Favorites")),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
