import 'package:flutter_test/flutter_test.dart';

import 'package:word_persist/src/models/category.dart';
import 'package:word_persist/src/models/entity.dart';
import 'package:word_persist/src/models/language.dart';
import 'package:word_persist/src/models/validatable.dart';
import 'package:word_persist/src/models/word.dart';

Word createWord() {
  return Word.draft();
}

void main() {
  group('Word model functional tests', () {
    test('Word.revise() increments the word\'s revision count by 1', () {
      // Arrange
      final word = createWord();
      final expectedCount = word.revisionCount + 1;

      // Act
      word.revise();

      // Assert
      expect(word.revisionCount, expectedCount);
    });

    test('Word.revise() sets word\'s latestRevision date to the same moment as the current date', () {
      // Arrange
      final word = createWord();
      final expectedLatestRevision = DateTime.now();

      // Act
      word.revise();

      // Assert
      final isSameMoment = word.latestRevision.isAtSameMomentAs(expectedLatestRevision);

      expect(isSameMoment, isTrue);
    });

    test('Word.evaluateAttempt(answer) returns true, if answer is equal to the originalWord', () {
      // Arrange
      final word = createWord();
      final correctAnswer = word.originalWord;

      // Act
      final bool result = word.evaluateAttempt(correctAnswer);

      // Assert
      expect(result, isTrue);
    });

    test('Word.evaluateAttempt(answer) returns false, if the answer is not equal to originalWord', () {
      // Arrange
      final word = createWord();
      final incorrectAnswer = "${word.originalWord} is wrong";

      // Act
      final bool result = word.evaluateAttempt(incorrectAnswer);

      // Assert
      expect(result, isFalse);
    });

    test('Word.evaluateAttempt(answer) increments correctStreak by 1, if answer is correct', () {
      // Arrange
      final word = createWord();
      final correctAnswer = word.originalWord;
      final excpectedStreak = word.correctStreak + 1;

      // Act
      word.evaluateAttempt(correctAnswer);

      // Assert
      expect(word.correctStreak, excpectedStreak);
    });

    test('Word.dateForNextRevision returns a date Word.revisionFrequencies[correctStreak] days from latestRevision', () {
      // Arrange
      final word = createWord();
      final today = DateTime.now();

      final expectedDaysDiff = Word.revisionFrequencies[word.correctStreak];

      // Act
      final nextRevision = word.dateForNextRevision;

      // Assert
      final int actualDays = nextRevision.difference(today).inDays;

      expect(actualDays, expectedDaysDiff);
    });
  });

  group('Word model entity tests', () {
    test('Word implements "Entity"', () {      
      // Arrange 
      final word = createWord();

      // Assert
      expect(word, isA<Entity>());
    });

    test('Word.fromMap(map) can convert a correct map representation', () {
      // Arrange
      final validWordAsMap = <String, Object?>{
        'id': 1,
        'originalWord': '',
        'translatedWord': '',
        'definition': '',
        'revisionCount' : 0,
        'correctStreak' : 0,
        'category': {
          'id': 2,
          'name': 'default',
          'confidenceLevel': 0,
        },
        'language': Language.english.index,
        'latestRevision' : DateTime.now().millisecondsSinceEpoch,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      // Act
      final word = Word.fromMap(validWordAsMap);

      final isWordValid = word.isValid();

      // Assert
      expect(isWordValid, isTrue);
    });

    test('Word.fromMap(map) returns invalid Word if map has an incorrect format', () {
      // Arrange
      final validWordAsMap = <String, Object?>{
        'i': 1,
        'originalWord': '',
        'translatedWord': '',
        'definition': '',
        'revisionCount' : 0,
        'language': Language.english.index,
        'latestRevision' : DateTime.now().millisecondsSinceEpoch,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      // Act
      final word = Word.fromMap(validWordAsMap);

      final isWordValid = word.isValid();

      // Assert
      expect(isWordValid, isFalse);
    });

    test('Word.toMap() produces a valid map representation', () {
      // Arrange
      final word = createWord();

      // Act
      final map = word.toMap();

      // Assert
      expect(map.keys, containsAllInOrder(word.fields.keys));
    });

    test('Word.draft() returns a Word with an invalid id (-1)', () {
      // Arrange
      final word = Word.draft();
      const expectedId = -1;

      // Act
      final actualId = word.id;

      // Assert
      expect(actualId, expectedId);
    });

    test('Word().id returns a valid integer id (id >= 0)', () {
      // Arrange
      final word = createWord();

      // Act
      final int id = word.id;

      // Assert
      expect(id, isNonNegative);
    });
  });

  group('Word model validation tests', () {
    test('Word implements "Validatable"', () {      
      // Arrange 
      final word = createWord();

      // Assert
      expect(word, isA<Validatable>());
    });

    test('Word.isValid() returns false if the original word is empty.', () {
      // Arrange
      final word = createWord();

      // Act
      word.originalWord = '';

      final bool isWordValid = word.isValid();

      // Assert
      expect(isWordValid, isFalse);
    });

    test('Word.isValid() returns false if the translated word is empty.', () {
      // Arrange
      final word = createWord();

      // Act
      word.translatedWord = '';

      final bool isWordValid = word.isValid();

      // Assert
      expect(isWordValid, isFalse);
    });

    test('Word.isValid() returns false when the definition is empty.', () {
      // Arrange
      final word = createWord();

      // Act
      word.definition = '';

      final bool isWordValid = word.isValid();

      // Assert
      expect(isWordValid, isFalse);
    });

    test('Word.isValid() returns false when the definition is longer than Word.definitionLengthLimit', () {
      // Arrange
      final word = createWord();
      final longDefinition = List<String>
        .filled(Word.definitionLengthLimit + 1, ' ')
        .join();

      // Act
      word.definition = longDefinition;

      final bool isWordValid = word.isValid();

      // Assert
      expect(isWordValid, isFalse);
    });

    test('Word.isValid() returns false when the revision count is negative', () {
      // Arrange
      final word = createWord();

      // Act
      word.revisionCount = -1;

      final bool isWordValid = word.isValid();

      // Assert
      expect(word.revisionCount, isNegative);
      expect(isWordValid, isFalse);
    });

    test('Word.isValid() returns false when the correct streak is negative', () {
      // Arrange
      final word = createWord();

      // Act
      word.correctStreak = -1;

      final bool isWordValid = word.isValid();

      // Assert
      expect(word.correctStreak, isNegative);
      expect(isWordValid, isFalse);
    });

    test('Word.isValid() returns false when latesRevision is before createdAt', () {
      // Arrange
      final word = createWord();

      final earlierDate = word.createdAt.subtract(const Duration( seconds: 10 ));

      // Act
      word.latestRevision = earlierDate;

      final bool isWordValid = word.isValid();

      // Assert
      expect(isWordValid, isFalse);
    });

    test('Word.isValid() returns true when a Word entity is valid', () {
      // Arrange
      final validWord = Word(
        id: 1, 
        originalWord: 'Valid word', 
        translatedWord: 'Valid translation',
        definition: 'Some valid definition',
        category: Category.draft(), 
        createdAt: DateTime.now(), 
        latestRevision: DateTime.now(), 
      );

      // Act
      final bool isWordValid = validWord.isValid();

      // Assert
      expect(isWordValid, isTrue);
    });    
  });

  group('Word model equality tests', () {
    test('Word == other returns flase when <other> is not an instance of Word', () {
      // Arrange
      final word = createWord();
      final somethingElse = Object();

      // Act
      final bool equal = word == somethingElse;

      // Assert
      expect(equal, isFalse);
    });

    test('Word == other returns flase when other is a Word but its originalWord is not equal', () {
      // Arrange
      final word = createWord();

      final otherWord = createWord();
      otherWord.originalWord = "a different word";

      // Act
      final bool equal = word == otherWord;

      // Assert
      expect(equal, isFalse);
    });

    test('Word == other returns flase when other is a Word but its translatedWord is not equal', () {
      // Arrange
      final word = createWord();

      final otherWord = createWord();
      otherWord.translatedWord = "a different translation";

      // Act
      final bool equal = word == otherWord;

      // Assert
      expect(equal, isFalse);
    });

    test('Word == other returns flase when other is a Word but its definition is not equal', () {
      // Arrange
      final word = createWord();

      final otherWord = createWord();
      otherWord.definition = "a different definition";

      // Act
      final bool equal = word == otherWord;

      // Assert
      expect(equal, isFalse);
    });

    test('Word == other returns flase when other is a Word but its language is not equal', () {
      // Arrange
      final word = createWord();

      final otherWord = createWord();
      otherWord.language = Language.notSelected;

      // Act
      final bool equal = word == otherWord;

      // Assert
      expect(equal, isFalse);
    });

    test('Word == other returns flase when other is a Word but its category is not equal', () {
      // Arrange
      final word = createWord();

      final otherWord = createWord();
      final otherCategory = Category.draft();

      otherCategory.id = 1000;
      otherWord.category = otherCategory;

      // Act
      final bool equal = word == otherWord;

      // Assert
      expect(equal, isFalse);
    });

    test('Word == other returns flase when other is a Word but its createdAt is not at the same moment', () {
      // Arrange
      final word = createWord();

      final otherWord = Word(
        id: -1, 
        originalWord: '', 
        translatedWord: '',
        definition: '',
        category: Category.draft(), 
        createdAt: DateTime(2022, 7, 9, 23, 8), 
        latestRevision: DateTime.now(), 
      );

      // Act
      final bool equal = word == otherWord;

      // Assert
      expect(equal, isFalse);
    });

    test('Word == other returns true when other is a Word and it is exactly equal', () {
      // Arrange
      final word = createWord();
      final other = createWord();

      // Act
      final bool equal = word == other;

      // Assert
      expect(equal, isFalse);
    });
  });
}