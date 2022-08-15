
class Field<T extends Object> {
  
  const Field(
    this.name, { 
      this.defaultValue,
      this.parser 
    }
  ) : type = T;

  final String name;
  final Type type;

  final T? defaultValue;
  final T? Function(String source)? parser;

  T? tryParse(Object? value) {

    if (value is T) return value;

    if (value is String && parser != null) return parser!(value);
  
    return defaultValue;
  }
}