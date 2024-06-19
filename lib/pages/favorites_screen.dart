import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Book>>(
        future: DatabaseHelper.instance.getFavoriteBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite books found.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Book book = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          minVerticalPadding: 12,
                          title: Text(book.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () async {
                              try {
                                await DatabaseHelper.instance
                                    .toggleFavoriteStatus(
                                      book.id,
                                      !book.isFavorite,
                                    )
                                    .then(
                                      (value) => print("Print BValue $value"),
                                    );
                                setState(() {});
                              } catch (e) {
                                print('error: $e');
                              }
                            },
                          ),
                          leading: Image.network(
                            book.imageLinks['thumbnail'] ?? "",
                            fit: BoxFit.cover,
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
