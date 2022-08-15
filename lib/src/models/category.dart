import 'package:flutter/foundation.dart';

import 'package:word_persist/src/models/entity.dart';
import 'package:word_persist/src/models/field.dart';
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

  static const maxWordCount = 250;
  static const maxConfidenceLevel = 5;

  static const Map<String, Field> entityFields = <String, Field>{
    'id': Field<int>('id', defaultValue: -1, parser: int.tryParse), 
    'name': Field<String>('name', defaultValue: ''), 
    'words': Field<List<Word>>('words', defaultValue: []), 
    'confidenceLevel': Field<int>('confidence_lvl', defaultValue: 0, parser: int.tryParse), 
  };

  static const String validationNameEmptyMsg = '"name" must not be empty';
  static const String validationNotEnoughWords = '"words" must hava at least 1 element';
  static const String validationTooManyWords = '"words" must have a length <= maxWordCount';
  static const String validationConfLvlNegative = '"confidenceLevel" must be greater than 0';
  static const String validationConfLvlExceedsRange = '"confidenceLevel" must be <= maxConfidenceLevel';

  int get numberOfWords => words.length;

  @override
  Map<String, Field> get fields => entityFields;

  factory Category.fromMap(Map<String, Object?> map) {
    for (var field in map.entries) {

      final isFieldValid = _hasMatchingField(field.key, field.value.runtimeType);

      if (!isFieldValid) return Category.draft();
    }

    final idField = entityFields['id']! as Field<int>;
    final nameField = entityFields['name']! as Field<String>;
    final wordsField = entityFields['words']! as Field<List<Word>>;
    final confidenceField = entityFields['confidenceLevel']! as Field<int>;

    final category = Category(
      id: idField.tryParse(map[idField.name]) ?? 0,
      name: nameField.tryParse(map[nameField.name]) ?? nameField.defaultValue!,
      words: wordsField.tryParse(map[wordsField.name]) ?? wordsField.defaultValue!,
      confidenceLevel: confidenceField.tryParse(map[confidenceField.name]) ?? confidenceField.defaultValue!,
    );

    return category;
  }

  static bool _hasMatchingField(String name, Type type) => entityFields.entries
      .where((f) => (f.value.name == name && f.value.type == type))
      .isNotEmpty;

  static String? validateName(String name) => name.trim().isEmpty
    ? validationNameEmptyMsg
    : null;

  static String? validateWords(List<Word> words) {
    if (words.isEmpty) {
      return validationNotEnoughWords;
    }
    else if (words.length > maxWordCount) {
      return validationTooManyWords;
    } else {
      return null;
    }
  }

  static String? validateConfidenceLvl(int confidenceLevel) {
    if (confidenceLevel.isNegative) {
      return validationConfLvlNegative;
    } else if (confidenceLevel > maxConfidenceLevel) {
      return validationConfLvlExceedsRange;
    } else {
      return null;
    }
  }

  @override
  bool isValid() {
    // A category is valid if all its validators produce no error (return null).
    final isNameValid = validateName(name) == null;
    final isWordListValid = validateWords(words) == null;
    final isConfidenceLvlValid = validateConfidenceLvl(confidenceLevel) == null;

    return isNameValid && isWordListValid && isConfidenceLvlValid;
  }

  @override
  Map<String, Object?> toMap() {
    final map = <String, Object?>{};

    map[entityFields['id']!.name] = id;
    map[entityFields['name']!.name] = name;
    map[entityFields['words']!.name] = words;
    map[entityFields['confidenceLevel']!.name] = confidenceLevel;

    return map;
  }

  @override
  String toString() {
    StringBuffer strBuffer = StringBuffer('{ ');

    strBuffer.writeAll(['id: ', id, ', ']);
    strBuffer.writeAll(['name: "', name, '", ']);
    strBuffer.writeAll(['wordCount: ', words.length, ', ']);
    strBuffer.writeAll(['confidenceLevel: ', confidenceLevel,]);

    strBuffer.write('}');

    return strBuffer.toString();
  }

  @override
  bool operator==(Object? other) 
  {
    if (other is! Category) return false;

    final areIdsEqual = id == other.id;
    final areNamesEqual = name == other.name;
    final areWordListsEqual = listEquals(words, other.words);
    final areConfidenceLvlsEqual = confidenceLevel == other.confidenceLevel;

    return areIdsEqual && areNamesEqual && areWordListsEqual && areConfidenceLvlsEqual;
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    words,
    confidenceLevel
  ]);
}