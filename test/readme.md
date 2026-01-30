# Test Dictionaries

Minimal test dictionaries for spellchecker development and testing.

## Contents

- `test.aff` / `test.dic` - Generic test dictionary
- `en_US_test.aff` / `en_US_test.dic` - US English test dictionary

## Purpose

These dictionaries are used for testing spellchecker implementations. They contain minimal word lists to verify basic functionality.

## License

Public Domain - Test fixtures for development purposes.

## Usage

### Loading from URL (Recommended)

```ruby
# Load test dictionary
dict = Kotoshu::Dictionary::Hunspell.new(
  dic_path: "https://raw.githubusercontent.com/kotoshu/dictionaries/main/test/test.dic",
  aff_path: "https://raw.githubusercontent.com/kotoshu/dictionaries/main/test/test.aff",
  language_code: "en"
)
```

### Loading from Local File

```ruby
dict = Kotoshu::Dictionary::Hunspell.new(
  dic_path: "dictionaries/test/test.dic",
  aff_path: "dictionaries/test/test.aff",
  language_code: "en"
)
```
