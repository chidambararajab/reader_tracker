import 'package:flutter/material.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/network/network.dart';
import 'package:reader_tracker/utils/book_details_arguements.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> _books = [];
  Network network = Network();

  Future<void> _searchBooks(String query) async {
    try {
      List<Book> books = await network.searchBooks(query);
      setState(() {
        _books = books;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: const InputDecoration(
                hintText: 'Search for books',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )),
            onSubmitted: (value) => _searchBooks(value),
          ),
        ),
        GridViewWidget(books: _books)
        // Expanded(
        //   child: SizedBox(
        //     width: double.infinity,
        //     child: ListView.builder(
        //       itemCount: _books.length,
        //       itemBuilder: (context, index) {
        //         Book book = _books[index];
        //         return ListTile(
        //           title: Text(book.title),
        //           subtitle: Text(book.authors.join(', & ')),
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ],
    )));
  }
}

class GridViewWidget extends StatelessWidget {
  const GridViewWidget({
    super.key,
    required List<Book> books,
  }) : _books = books;

  final List<Book> _books;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: _books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.6),
        itemBuilder: (context, index) {
          Book book = _books[index];
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onInverseSurface,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Theme.of(context).colorScheme.primary),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/book_details',
                  arguments: BookDetailsArguements(itemBook: book),
                );
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const BookDetailsScreen()));
              },
              child: Column(
                children: [
                  if (book.imageLinks.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.network(
                        book.imageLinks['thumbnail']!,
                        height: 200,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        book.authors.join(', & '),
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
