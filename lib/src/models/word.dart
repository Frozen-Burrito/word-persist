import 'package:word_persist/src/models/category.dart';
import 'package:word_persist/src/models/entity.dart';
import 'package:word_persist/src/models/field.dart';
import 'package:word_persist/src/models/language.dart';
import 'package:word_persist/src/models/validatable.dart';
import 'package:word_persist/src/utils/datetime_extensions.dart';

class Word implements Entity, Validatable
{
  Word({
    required this.id,
    required this.originalWord,
    required this.translatedWord,
    required this.definition,
    this.revisionCount = 0,
    this.correctStreak = 0,
    required this.category,
    this.language = Language.notSelected,
    required this.latestRevision,
    required this.createdAt
  });

  Word.draft() : this(
    id: -1,
    originalWord: '',
    translatedWord: '',
    definition: '',
    category: Category.draft(),
    latestRevision: DateTime.now(),
    createdAt: DateTime.now()
  );

  @override
  int id;

  String originalWord;
  String translatedWord;
  String definition;

  int revisionCount;
  int correctStreak;
  DateTime latestRevision;

  Category? category;
  Language language;

  final DateTime createdAt;

  static const definitionLengthLimit = 150;

  static final revisionFrequencies = Map.unmodifiable({
    0: 1,
    3: 3,
    10: 7,
    15: 14,
    20: 30,
  });

  static final Map<String, Field> fieldNames = {
    'id': const Field<int>('id', defaultValue: -1, parser: int.tryParse), 
    'originalWord': const Field<String>('originalWord', defaultValue: ''), 
    'translatedWord': const Field<String>('translatedWord', defaultValue: ''), 
    'definition': const Field<String>('definition', defaultValue: ''), 
    'revisionCount': const Field<int>('revisionCount', defaultValue: 0, parser: int.tryParse), 
    'correctStreak': const Field<int>('correctStreak', defaultValue: 0, parser: int.tryParse), 
    'category': const Field<Category>('category', defaultValue: null), 
    'language': const Field<Language>('language', defaultValue: Language.notSelected), 
    'latestRevision': Field<DateTime>('latestRevision', defaultValue: DateTime.now(), parser: DateTimeParsing.fromStringSecondsSinceEpoch), 
    'createdAt': Field<DateTime>('createdAt', defaultValue: DateTime.now(), parser: DateTimeParsing.fromStringSecondsSinceEpoch),
  };

  @override
  Map<String, Field> get fields => fieldNames;

  void revise() {
    // TODO: implement revise
    throw UnimplementedError();
  }

  bool evaluateAttempt(String answer) {
    // TODO: implement evaluateAttempt
    throw UnimplementedError();
  }

  DateTime get dateForNextRevision {
    // TODO: implement dateForNextRevision
    throw UnimplementedError();
  }

  factory Word.fromMap(Map<String, Object?> map) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  Map<String, Object?> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  bool isValid() {
    // TODO: implement isValid
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