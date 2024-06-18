import 'package:reader_tracker/models/book.dart';

class BookDetailsArguements {
  final Book itemBook;
  final bool isFromSavedScreen;
  BookDetailsArguements(
      {required this.itemBook, required this.isFromSavedScreen});
}
