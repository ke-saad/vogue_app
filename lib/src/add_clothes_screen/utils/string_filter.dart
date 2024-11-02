String filterString(String input) {
  final regex = RegExp(r'^\d+\s+(.+)$');
  final match = regex.firstMatch(input);

  if (match != null) {
    return match.group(1)!;
  }

  return input;
}

void main() {
  String example1 = '1 Shirt';
  String example2 = '2 Pants';
  String example3 = 'No match';

  print(filterString(example1));
  print(filterString(example2));
  print(filterString(example3));
}
