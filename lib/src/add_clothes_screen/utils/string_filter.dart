String filterString(String input) {
  // Use a regular expression to match the pattern and extract the word
  final regex = RegExp(r'^\d+\s+(.+)$');
  final match = regex.firstMatch(input);

  // Check if the match is successful and return the captured group
  if (match != null) {
    return match.group(1)!; // Return the word (the first capturing group)
  }

  // If no match is found, return the original input or handle accordingly
  return input;
}

void main() {
  String example1 = '1 Shirt';
  String example2 = '2 Pants';
  String example3 = 'No match';

  print(filterString(example1)); // Output: 'Shirt'
  print(filterString(example2)); // Output: 'Pants'
  print(filterString(example3)); // Output: 'No match'
}
