import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/utils/book_details_arguements.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as BookDetailsArguements;
    final bool isFromSavedScreen = args.isFromSavedScreen;
    final Book book = args.itemBook;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              if (book.imageLinks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.network(book.imageLinks['thumbnail']!),
                ),
              Column(
                children: [
                  Text(
                    book.title,
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Author: ${book.authors.join(', ')}",
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Published Date: ${book.publishedDate}",
                    style: textTheme.labelLarge,
                  ),
                  Text(
                    "Page Count: ${book.pageCount}",
                    style: textTheme.labelLarge,
                  ),
                  Text(
                    "Language: ${book.language}",
                    style: textTheme.labelLarge,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isFromSavedScreen)
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // Save a book in database using insert method in DatabaseHelper.
                            await DatabaseHelper.instance.insert(book);
                            SnackBar snackBar = SnackBar(
                              content: Text("Book Saved: ${book.title}"),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } catch (e) {
                            print('error: ${e.toString()}');
                          }
                        },
                        child: const Text('Saved'),
                      ),
                    if (isFromSavedScreen)
                      ElevatedButton.icon(
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
                          } catch (e) {
                            print('error: $e');
                          }
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Favorite'),
                      ),
                  ],
                ),
              ),
              const Divider(
                height: 30,
              ),
              Text(
                "Description",
                style: textTheme.headlineSmall,
              ),
              if (book.description.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    book.description,
                    style: textTheme.bodyLarge,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
