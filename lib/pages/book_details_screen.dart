import 'package:flutter/material.dart';
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
              if (book.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
