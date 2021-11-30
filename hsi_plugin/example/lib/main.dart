import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hsi_plugin/hsi_plugin.dart';

import 'dart:ffi';
import 'package:ffi/ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  var _returnInit;
  var _returnClose;
  var modelstr = 'aaaaaaaaaa';
  List<double> vsArray = [0, 0, 0, 0, 0];
  List<double> hsArray = [0, 0, 0, 0, 0];
  bool _isLiveview = false;
  int _isLiveviewInt = 0;

  void onPressInitButton() async {
    final vsArrayPtr = calloc.allocate<Double>(5);
    final hsArrayPtr = calloc.allocate<Double>(5);
    final modelPtr = malloc.allocate<Utf8>(10);
    await asyncInitIxon(modelPtr, vsArrayPtr, hsArrayPtr, 10, 5, 5);
    vsArray = vsArrayPtr.asTypedList(5);
    hsArray = hsArrayPtr.asTypedList(5);
    modelstr = modelPtr.toDartString();
    setState(() {
      _returnInit = modelstr;
      _returnClose = null;
    });
    calloc.free(vsArrayPtr);
    calloc.free(hsArrayPtr);
    malloc.free(modelPtr);
  }

  void onPressCloseButton() async {
    final temp = calloc.allocate<Double>(1);
    await asyncCloseIxon(temp);
    setState(() {
      _returnClose = temp.asTypedList(1)[0];
      _returnInit = null;
    });
    calloc.free(temp);
  }

  void onPressCloseShutter() {
    setShutterMode(1);
  }

  void onPressOpenShutter() {
    setShutterMode(2);
  }

  void _liveviewSwitchOnChanged(bool valueChanged) {
    setState(() {
      _isLiveview = valueChanged;
    });
    ixonLiveView();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await HsiPlugin.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: [
            Text('Running on: $_platformVersion\n'),
            TextButton(
                onPressed: onPressInitButton,
                child: Text('initIxon:$_returnInit')),
            TextButton(
                onPressed: onPressCloseButton,
                child: Text('closeIxon:$_returnClose')),
            TextButton(
                onPressed: onPressOpenShutter,
                child: const Text('open shutter')),
            TextButton(
                onPressed: onPressCloseShutter,
                child: const Text('close shutter')),
            Switch(value: _isLiveview, onChanged: _liveviewSwitchOnChanged),
            Text("Liveview")
          ]),
        ),
      ),
    );
  }
}
