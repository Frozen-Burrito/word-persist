
abstract class Entity
{
  int id = -1;
  Map<String, Type> get fields;
  Map<String, Object?> toMap();
}