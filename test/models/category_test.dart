import 'package:flutter_test/flutter_test.dart';
import 'package:word_persist/src/models/category.dart';
import 'package:word_persist/src/models/entity.dart';
import 'package:word_persist/src/models/validatable.dart';
import 'package:word_persist/src/models/word.dart';

void main() {

  Category createCategory() {
    return Category.draft();
  }

  group('Category entity tests', () {
    test('Category implements "Entity"', () {      
      // Arrange 
      final category = createCategory();

      // Assert
      expect(category, isA<Entity>());
    });

    test('Category.fromMap(map) can convert a correct map representation', () {
      // Arrange
      final Category expected = Category(
        id: 1, 
        name: 'test category', 
        words: [], 
        confidenceLevel: 4
      );

      final validCategoryAsMap = <String, Object?>{
        'id': 1,
        'name': 'test category',
        'words': [],
        'confidenceLevel': 4,
      };

      // Act
      final mappedCategory = Category.fromMap(validCategoryAsMap);

      // Assert
      expect(mappedCategory, expected);
    });

    test('Category.fromMap(map) returns a default, uncommited Category if map has an incorrect format', () {
      // Arrange
      final expected = Category.draft();
      final invalidMap = <String, Object?>{
        'i': 1,
        'wordse': 0.0,
        'confidenceLevel': 'false',
      };

      // Act
      final category = Category.fromMap(invalidMap);

      // Assert
      expect(category, expected);
    });

    test('Word.toMap() produces a valid map representation', () {
      // Arrange
      final category = createCategory();

      // Act
      final map = category.toMap();

      // Assert
      expect(map.keys, containsAllInOrder(category.fields.keys));
    });

    test('Category.fields returns a map with 5 entries', () {
      // Arrange
      final category = createCategory();
      const int expected = 5;

      // Act
      final int fieldCount = category.fields.length;

      // Assert
      expect(fieldCount, expected);
    });

    test('Category.draft() returns a Category with an "uncommited" id (id < 0)', () {
      // Arrange
      final category = Category.draft();

      // Act
      final int id = category.id;

      // Assert
      expect(id, isNegative);
    });
  });

  group('Category validation tests', () {
    test('Category implements "Validatable"', () {      
      // Arrange 
      final category = createCategory();

      // Assert
      expect(category, isA<Validatable>());
    });

    test('Category.isValid() returns false if its name is an empty string', () {
      // Arrange
      final category = Category(
        id: 0,
        name: '',
        words: [],
        confidenceLevel: 0,
      );

      // Act
      final bool isCategoryValid = category.isValid();

      // Assert
      expect(isCategoryValid, isFalse);
    });

    test('Category.isValid() returns false if its name is a blank-space string', () {
      // Arrange
      final category = Category(
        id: 0,
        name: '            ',
        words: [],
        confidenceLevel: 0,
      );

      // Act
      final bool isCategoryValid = category.isValid();

      // Assert
      expect(isCategoryValid, isFalse);
    });

    test('Category.isValid() returns false when wordCount is greater than Category.maxWordCount', () {
      // Arrange
      final draftWord = Word.draft();
      final category = Category(
        id: 0,
        name: 'valid name',
        words: List.generate(Category.maxWordCount + 1, (_) => draftWord),
        confidenceLevel: 0,
      );

      // Act
      final bool isCategoryValid = category.isValid();

      // Assert
      expect(isCategoryValid, isFalse);
    });

    test('Category.isValid() returns false when confidenceLevel is negative', () {
      // Arrange
      final category = Category(
        id: 0,
        name: 'valid name',
        words: [ Word.draft() ],
        confidenceLevel: -1,
      );

      // Act
      final bool isCategoryValid = category.isValid();

      // Assert
      expect(isCategoryValid, isFalse);
    });

    test('Category.isValid() returns false when confidenceLevel is greater than Category.maxConfidenceLevel', () {
      // Arrange
      final category = Category(
        id: 0,
        name: 'valid name',
        words: [ Word.draft() ],
        confidenceLevel: Category.maxConfidenceLevel + 1,
      );

      // Act
      final bool isCategoryValid = category.isValid();

      // Assert
      expect(isCategoryValid, isFalse);
    });

    test('Category.isValid() returns false when "words" is empty', () {
      // Arrange
      final category = Category(
        id: 0,
        name: 'valid name',
        words: [],
        confidenceLevel: Category.maxConfidenceLevel + 1,
      );

      // Act
      final bool isCategoryValid = category.isValid();

      // Assert
      expect(isCategoryValid, isFalse);
    });

    test('Category.isValid() returns true when all the category\'s fields are valid', () {
      // Arrange
      final validCategory = Category(
        id: 0,
        name: 'valid name',
        words: [ Word.draft() ],
        confidenceLevel: 0,
      );

      // Act
      final bool isCategoryValid = validCategory.isValid();

      // Assert
      expect(isCategoryValid, isTrue);
    });
  });

  group('Category equality tests', () {
    test('"Category == other" returns false when "other" is not a Category', () {
      // Arrange
      final category = createCategory();
      final somethingElse = Object();

      // Act
      final bool areEqual = category == somethingElse;

      // Assert
      expect(areEqual, isFalse);
    });

    test('"Category == other" returns false when "other" is a Category but its "id" is not equal', () {
      // Arrange
      final category = createCategory();
      final other = createCategory();

      // Act
      other.id = 1;
      final bool areEqual = category == other;

      // Assert
      expect(areEqual, isFalse);
    });

    test('"Category == other" returns false when "other" is a Category but its "name" is not equal', () {
      // Arrange
      final category = createCategory();
      final other = Category(
        id: -1, 
        name: '', 
        confidenceLevel: 0,
        words: [],
      );

      // Act
      final bool areEqual = category == other;

      // Assert
      expect(areEqual, isFalse);
    });

    test('"Category == other" returns false when "other" is a Category but its "confidenceLevel" is not equal', () {
      // Arrange
      final category = createCategory();
      final other = Category(
        id: -1, 
        name: '', 
        confidenceLevel: 1,
        words: [],
      );

      // Act
      final bool areEqual = category == other;

      // Assert
      expect(areEqual, isFalse);
    });

    test('"Category == other" returns false when "other" is a Category but its "words" is not equal', () {
      // Arrange
      final category = createCategory();
      final other = Category(
        id: -1, 
        name: '', 
        confidenceLevel: 0,
        words: [Word.draft(), Word.draft()],
      );

      // Act
      final bool areEqual = category == other;

      // Assert
      expect(areEqual, isFalse);
    });

    test('"Category == other" returns true when "other" is exactly equal', () {
      // Arrange
      final category = createCategory();
      final other = createCategory();

      // Act
      final bool areEqual = category == other;

      // Assert
      expect(areEqual, isTrue);
    });

    test('"Category == other" returns true when "other" has the same identity', () {
      // Arrange
      final category = createCategory();
      final other = category;

      // Act
      final bool areEqual = category == other;

      // Assert
      expect(areEqual, isTrue);
    });
  });
}