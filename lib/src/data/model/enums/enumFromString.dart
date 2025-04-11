/// Converts a String [key] to an enum value [T] by comparing it
/// case-insensitively against the names of the enum values in [values].
///
/// Returns the matching enum value of type [T], or `null` if [key] is null
/// or no match is found.
///
/// Example:
/// ```dart
/// enum Status { pending, complete, failed }
/// Status? status = enumFromString<Status>('complete', Status.values); // Result: Status.complete
/// Status? invalidStatus = enumFromString<Status>('DONE', Status.values); // Result: null
/// Status? defaultStatus = enumFromString<Status>(null, Status.values) ?? Status.pending; // Result: Status.pending
/// ```
T? enumFromString<T extends Enum>(String? key, List<T> values) {
  // 1. Handle null input immediately
  if (key == null) {
    return null;
  }

  // 2. Prepare the input key for case-insensitive comparison
  final lowerCaseKey = key.toLowerCase();

  // 3. Iterate through the provided enum values
  for (final value in values) {
    // 4. Compare the lowercase enum name with the lowercase key
    if (value.name.toLowerCase() == lowerCaseKey) {
      // 5. Return the matching enum value if found
      return value;
    }
  }

  // 6. Return null if no match was found after checking all values
  return null;
}
