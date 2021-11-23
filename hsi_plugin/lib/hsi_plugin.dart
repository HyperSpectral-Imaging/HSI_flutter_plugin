// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:flutter/services.dart';

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

typedef DllVoidFun = Void Function();
typedef VoidFun = void Function();

typedef DllDoubleFun = Double Function(Double input);
typedef DoubleFun = double Function(double a);

final hsidllpath = path.join(Directory.current.path, 'bin', 'dll', 'hsi.dll');
final hsilib = DynamicLibrary.open(hsidllpath);

final interOpTestPointer =
    hsilib.lookup<NativeFunction<DllDoubleFun>>('InterOpTest');
final interOpTest = interOpTestPointer.asFunction<DoubleFun>();

class HsiPlugin {
  static const MethodChannel _channel = MethodChannel('hsi_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
