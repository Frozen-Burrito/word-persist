import 'package:word_persist/src/models/entity.dart';
import 'package:word_persist/src/models/validatable.dart';
import 'package:word_persist/src/models/word.dart';

class Category implements Entity, Validatable {

  Category({
    required this.id,
    required this.name, 
    required this.words,
    this.confidenceLevel = 0,
  });

  Category.draft() : this(
    id: -1, 
    name: "undefined", 
    words: [],
  );

  @override
  int id;

  final String name;
  int confidenceLevel;

  final List<Word> words;

  static const maxWordCount= 250;
  static const maxConfidenceLevel = 5;

  int get numberOfWords => words.length;

  @override
  // TODO: implement fields
  Map<String, Type> get fields => throw UnimplementedError();

  factory Category.fromMap(Map<String, Object?> map) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  bool isValid() {
    // TODO: implement isValid
    throw UnimplementedError();
  }

  @override
  Map<String, Object?> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  String toString() {
    // TODO: implement toString
    throw UnimplementedError();
  }

  @override
  bool operator==(Object? other) 
  {
    // TODO: implement operator==
    throw UnimplementedError();
  }

  @override
  int get hashCode
  {
    // TODO: implement hashCode
    throw UnimplementedError();
  }
}