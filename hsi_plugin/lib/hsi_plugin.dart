// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

typedef DllDoubleFun = Double Function(Double input);
typedef DoubleFun = double Function(double a);

typedef DllCloseIxonFun = Void Function(Pointer<Double> temp);
typedef CloseIxonFun = void Function(Pointer<Double> temp);

typedef DllInitIxonFun = Uint32 Function(
    Pointer<Utf8> model,
    Pointer<Double> vsArray,
    Pointer<Double> hsArray,
    Int32 modelLen,
    Int32 vsArrayLen,
    Int32 hsArrayLen);
typedef InitIxonFun = int Function(Pointer<Utf8> model, Pointer<Double> vsArray,
    Pointer<Double> hsArray, int modelLen, int vsArrayLen, int hsArrayLen);

typedef DllSetShutterModeFun = Void Function(Int32 mode);
typedef SetShutterModeFun = void Function(int mode);

typedef DllIxonLiveViewFun = Void Function();
typedef IxonLiveViewFun = void Function();

final hsidllpath = path.join(Directory.current.path, 'bin', 'dll', 'hsi.dll');
final hsilib = DynamicLibrary.open(hsidllpath);

final interOpTestPointer =
    hsilib.lookup<NativeFunction<DllDoubleFun>>('InterOpTest');
final interOpTest = interOpTestPointer.asFunction<DoubleFun>();

final initIxon = hsilib.lookupFunction<DllInitIxonFun, InitIxonFun>('InitIxon');

Future<int> asyncInitIxon(
    Pointer<Utf8> model,
    Pointer<Double> vsArray,
    Pointer<Double> hsArray,
    int modelLen,
    int vsArrayLen,
    int hsArrayLen) async {
  final Completer<int> _completer = Completer();
  Future.delayed(const Duration(milliseconds: 500), () {
    _completer.complete(
        initIxon(model, vsArray, hsArray, modelLen, vsArrayLen, hsArrayLen));
  });
  return _completer.future;
}

void initIxonInIsolate(SendPort sendPort) {
  final vsArrayPtr = calloc.allocate<Double>(5);
  final hsArrayPtr = calloc.allocate<Double>(5);
  final modelPtr = malloc.allocate<Utf8>(10);
  initIxon(modelPtr, vsArrayPtr, hsArrayPtr, 10, 5, 5);
  Map returnMap = Map();
  returnMap["model"] = modelPtr.toDartString();
  returnMap["vsArray"] = vsArrayPtr.asTypedList(5);
  returnMap["hsArray"] = hsArrayPtr.asTypedList(5);
  sendPort.send(returnMap);
  // calloc.free(vsArrayPtr);
  // calloc.free(hsArrayPtr);
  // malloc.free(modelPtr);
}

final closeixon =
    hsilib.lookupFunction<DllCloseIxonFun, CloseIxonFun>('CloseIxon');

Future<void> asyncCloseIxon(Pointer<Double> temp) async {
  final Completer<void> _completer = Completer();
  Future.delayed(const Duration(milliseconds: 500), () {
    closeixon(temp);
    _completer.complete();
  });
  return _completer.future;
}

void closeIxonInIsolate(SendPort sendPort) {
  final temp = calloc.allocate<Double>(1);
  closeixon(temp);
  sendPort.send(temp.asTypedList(1)[0]);
  // calloc.free(temp);
}

final setShutterMode = hsilib
    .lookupFunction<DllSetShutterModeFun, SetShutterModeFun>('SetShutterMode');

final ixonLiveView =
    hsilib.lookupFunction<DllIxonLiveViewFun, IxonLiveViewFun>('IxonLiveview');

class HsiPlugin {
  static const MethodChannel _channel = MethodChannel('hsi_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
