import 'package:word_persist/src/models/field.dart';

abstract class Entity
{
  int id = -1;
  Map<String, Field> get fields;
  Map<String, Object?> toMap();
}