# hsi_plugin_example

The plugin makes LabView built dll `hsi.dll` accessible to flutter codes. The dynamic load library is the backend of the HyperSpectral Imaging system. Another important library is the `atmcd64d.dll` file used to communicate with Andor iXon camera.

Both dll files can be find in the `lib/dll` directory. For any flutter program to run this plugin properly, `hsi.dll` should be placed in `bin/dll` and `atmcd64d.dll` in `\build\windows\runner\Debug` (namely where the host executable runs) from the root of flutter project. 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
