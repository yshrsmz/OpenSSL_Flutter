/// Returns enum entry name. [o] must be an enum entry.
String enumEntryName(Object o) {
  final value = o.toString();
  return value.substring(value.indexOf('.') + 1);
}
