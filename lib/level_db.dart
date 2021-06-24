import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'src/bindings.dart' as ffi;

abstract class LevelDb {
  String? getItem(String key);
  void setItem(String key, String value);
}

Future<LevelDb> getLevelDB() async {
  final base = await getApplicationDocumentsDirectory();
  final dbPath =
      join(base.path, 'ca02e944-06da-4ca2-8197-c274f04846b9-level_db');

  return _LevelDb(dbPath);
}

extension Int8String on String {
  Pointer<Int8> toInt8Pointer() {
    return this.toNativeUtf8().cast<Int8>();
  }
}

class _LevelDb implements LevelDb {
  late final ffi.LevelDB _l;
  late final Pointer<ffi.leveldb_t> _db;
  final _errptr = "".toNativeUtf8().cast<Pointer<Int8>>();

  late final Pointer<ffi.leveldb_writeoptions_t> _write_options;
  late final Pointer<ffi.leveldb_readoptions_t> _read_options;

  _LevelDb(String path) {
    _l = ffi.LevelDB(DynamicLibrary.process());
    final options = _l.leveldb_options_create();

    _l.leveldb_options_set_create_if_missing(options, 1);
    _db = _l.leveldb_open(options, path.toInt8Pointer(), _errptr);

    checkError();

    _write_options = _l.leveldb_writeoptions_create();
    _l.leveldb_writeoptions_set_sync(_write_options, 1);

    _read_options = _l.leveldb_readoptions_create();
  }

  setItem(String key, String value) {
    final keylen = key.length;
    final vallen = value.length;

    _l.leveldb_put(
      _db,
      _write_options,
      key.toInt8Pointer(),
      keylen,
      value.toInt8Pointer(),
      vallen,
      _errptr,
    );

    checkError();
  }

  String? getItem(String key) {
    final vallen = calloc.allocate(8).cast<Uint64>();

    final res = _l.leveldb_get(
      _db,
      _read_options,
      key.toInt8Pointer(),
      key.length,
      vallen,
      _errptr,
    );

    checkError();

    if (res.address == 0) return null;
    return res.cast<Utf8>().toDartString();
  }

  checkError() {
    if (_errptr.value.address != 0) {
      final errMessage = _errptr.value.cast<Utf8>().toDartString();
      throw new Exception(errMessage);
    }
  }
}
