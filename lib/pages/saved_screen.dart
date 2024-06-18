import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/utils/book_details_arguements.dart';

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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Book book = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/book_details',
                            arguments: BookDetailsArguements(
                              itemBook: book,
                              isFromSavedScreen: true,
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            minVerticalPadding: 12,
                            title: Text(book.title),
                            trailing: IconButton(
                              onPressed: () async {
                                await DatabaseHelper.instance
                                    .deleteBook(book.id);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                            leading: Image.network(
                              book.imageLinks['thumbnail'] ?? "",
                              fit: BoxFit.cover,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.authors.join(", & ")),
                                ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        await DatabaseHelper.instance
                                            .toggleFavoriteStatus(
                                              book.id,
                                              !book.isFavorite,
                                            )
                                            .then(
                                              (value) =>
                                                  print("Print BValue $value"),
                                            );
                                      } catch (e) {
                                        print('error: $e');
                                      }
                                    },
                                    icon: const Icon(Icons.favorite_outline),
                                    label: const Text("Add To Favorites")),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
