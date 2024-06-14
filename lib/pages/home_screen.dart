import 'package:flutter/material.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/network/network.dart';

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
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                Book book = _books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.authors.join(', & ')),
                );
              },
            ),
          ),
        ),
      ],
    )));
  }
}
