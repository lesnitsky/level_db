# level_db

[![lesnitsky.dev](https://lesnitsky.dev/shield.svg?hash=94181)](https://lesnitsky.dev?utm_source=level_db)
[![GitHub stars](https://img.shields.io/github/stars/lesnitsky/level_db.svg?style=social)](https://github.com/lesnitsky/level_db)
[![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_dev.svg?label=Follow%20me&style=social)](https://twitter.com/lesnitsky_dev)

LevelDB for Flutter

## ⚠ WORK-IN-PROGRESS ⚠

## Installation

pubspec.yaml:

```yaml
dependencies:
  level_db:
    git: git@github.com:lesnitsky/level_db.git
```

## Supported platforms

- [x] iOS
- [ ] Android
- [ ] Linux
- [ ] Web
- [ ] macOS

## Example

```dart
import 'package:level_db/level_db.dart';

void main() async {
  final db = await getLevelDB();
  db.setItem('key', 'value');

  final value = db.getItem('key');
  assert(value == 'value');
}
```

## Known issues

Hot restart doesn't work

## License

MIT
