import 'package:flutter_test/flutter_test.dart';
import 'package:word_persist/src/models/category.dart';
import 'package:word_persist/src/models/entity.dart';
import 'package:word_persist/src/models/validatable.dart';
import 'package:word_persist/src/models/word.dart';

void main() {

  Category createCategory() {
    return Category.draft();
  }

  group('Category functional tests', () {
    test('Category.numberOfWords returns the number of words in the category.', () {
      // Arrange
      const int expectedWordCount = 3;
      final category = Category(
        id: 0,
        name: 'test category',
        confidenceLevel: 1,
        words: List.generate(expectedWordCount, (index) => Word.draft()),
      );

      // Act
      final int wordCount = category.numberOfWords;

      // Assert
      expect(wordCount, expectedWordCount);
    });
  });

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
        words: <Word>[], 
        confidenceLevel: 4
      );

      final validCategoryAsMap = <String, Object?>{
        'id': 1,
        'name': 'test category',
        'words': <Word>[],
        'confidence_lvl': 4,
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

      final expectedFields = category.fields.values.map((f) => f.name);

      // Act
      final map = category.toMap();

      // Assert
      expect(map.keys, containsAllInOrder(expectedFields));
    });

    test('Category.fields returns a map with 4 entries', () {
      // Arrange
      final category = createCategory();
      const int expected = 4;

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

    test('Category.validateName(name) returns Category.validationNameEmptyMsg when name is an empty string', () {
      // Arrange
      const String emptyName = '';
      const String expected = Category.validationNameEmptyMsg;

      // Act
      final nameError = Category.validateName(emptyName);

      // Assert
      expect(nameError, expected);
    });

    test('Category.validateName(name) returns null when name is a valid category name', () {
      // Arrange
      const String acceptableName = 'category name';

      // Act
      final nameError = Category.validateName(acceptableName);

      // Assert
      expect(nameError, isNull);
    });

    test('Category.validateWords(words) returns Category.validationNotEnoughWords when words is an empty list', () {
      // Arrange
      const List<Word> emptyWordList = [];
      const expectedError = Category.validationNotEnoughWords; 

      // Act
      final wordListError = Category.validateWords(emptyWordList);

      // Assert
      expect(wordListError, expectedError);
    });

    test('Category.validateWords(words) returns Category.validationTooManyWords when words has more than Category.maxWordCount', () {
      // Arrange
      final word = Word.draft();
      final fullWordList = List.generate(Category.maxWordCount + 1, (_) => word);
      const expectedError = Category.validationTooManyWords; 

      // Act
      final wordListError = Category.validateWords(fullWordList);

      // Assert
      expect(wordListError, expectedError);
    });

    test('Category.validateWords(words) returns null when words is a word list with a length within the accepted range', () {
      // Arrange
      final word = Word.draft();
      final wordList = List.generate(3, (_) => word);

      // Act
      final wordListError = Category.validateWords(wordList);

      // Assert
      expect(wordListError, isNull);
    });

    test('Category.validateConfidenceLvl(lvl) returns Category.validationConfLvlNegative when lvl is negative', () {
      // Arrange
      const int incorrectConfidenceLvl = -1;
      const expectedError = Category.validationConfLvlNegative;

      // Act
      final confidenceLvlError = Category.validateConfidenceLvl(incorrectConfidenceLvl);

      // Assert
      expect(confidenceLvlError, expectedError);
    });

    test('Category.validateConfidenceLvl(lvl) returns Category.validationConfLvlExceedsRange when lvl > Category.maxConfidenceLeve ', () {
      // Arrange
      const int incorrectConfidenceLvl = Category.maxConfidenceLevel + 1;
      const expectedError = Category.validationConfLvlExceedsRange;

      // Act
      final confidenceLvlError = Category.validateConfidenceLvl(incorrectConfidenceLvl);

      // Assert
      expect(confidenceLvlError, expectedError);
    });

    test('Category.validateConfidenceLvl(lvl) returns null when name lvl is within the expected range', () {
      // Arrange
      const int confidenceLevel = 0;

      // Act
      final confidenceLvlError = Category.validateConfidenceLvl(confidenceLevel);

      // Assert
      expect(confidenceLvlError, isNull);
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