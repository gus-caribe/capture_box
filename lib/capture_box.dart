library capture_box;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart'; 
import 'package:path/path.dart' as path;


enum SaveMode {
  filePicker,
  appDocuments
}

/// [CaptureBoxController] can be attached to a [CaptureBox] Widget, allowing to perform
/// conversions with rendering outputs. It also allows saving the resulting byte lists
/// into user-defined directories.
/// 
class CaptureBoxController {
  final GlobalKey _boxKey = GlobalKey();
  bool _attached = false;


  Future<Uint8List?> _widgetToPng() async {
    final RenderRepaintBoundary? boundary = _boxKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final ui.Image? image = await boundary?.toImage();
    final ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  Future<Uint8List?> _pngToJpg(
    Uint8List pngByteList,
    {int quality = 100}
  ) async {
    final image.Image? png = image.decodePng(pngByteList);

    if(png != null) {
      return image.encodeJpg(
        png,
        quality: quality
      );
    }
    
    return null;
  }

  /// This method takes in a Uint8List and, based on the directive passed to `saveMode`,
  /// it saves the binary data into a file.
  /// 
  void saveBytes({
    required Uint8List byteList,
    required String fileName,
    required String fileExtension,
    SaveMode saveMode = SaveMode.filePicker,
    String filePickerTitle = ""
  }) async {
    if(kIsWeb) {
      html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,${base64Encode(byteList)}"
      )..setAttribute("download", "$fileName.$fileExtension")
      ..click();

      return;
    }

    String filePath = "";

    switch(saveMode) {
      case SaveMode.filePicker:
        filePath = await FilePicker.platform.saveFile(
          dialogTitle: filePickerTitle,
          fileName: "$fileName.$fileExtension",
        ) ?? "";
      break;

      case SaveMode.appDocuments:
        filePath = path.join(
          (await getApplicationDocumentsDirectory()).path, 
          "$fileName.$fileExtension"
        );
      break;
    }

    File file = File(filePath);
    await file.writeAsBytes(byteList);
  }

  /// This method outputs a nullable [Uint8List] representing the Widget wrapped by 
  /// [CaptureBox] in the form of a PNG mime type. 
  /// 
  /// If there is no Widget attached or if an error occurs during the convertion, this
  /// method returns `null`.
  /// 
  Future<Uint8List?> getPng() async {
    return await _widgetToPng();
  }

  /// This method outputs a nullable [Uint8List] representing the Widget wrapped by 
  /// [CaptureBox] in the form of a JPG mime type. 
  /// 
  /// If there is no Widget attached or if an error occurs during the convertion, this
  /// method returns `null`.
  /// 
  Future<Uint8List?> getJpg({int quality = 100}) async {
    Uint8List? pngByteList = await getPng();

    if(pngByteList != null) {
      return await _pngToJpg(
        pngByteList,
        quality: quality
      );
    }

    return null;
  }

  /// This method saves into a PNG file the binary data obtained from a widget rendering 
  /// task, based on the directive passed to `saveMode`.
  /// 
  /// If there is no Widget attached or if an error occurs during the convertion, this
  /// method throws an `Exception`.
  /// 
  Future<void> savePng({
    required String fileName,
    SaveMode saveMode = SaveMode.filePicker,
    String filePickerTitle = ""
  }) async {
    Uint8List? pngByteList = await getPng();

    if(pngByteList != null) {
      saveBytes(
        byteList: pngByteList, 
        fileName: fileName, 
        fileExtension: "png",
        saveMode: saveMode,
        filePickerTitle: filePickerTitle
      );

      return;
    }

    throw Exception("An error occurred during the Widget conversion to PNG.");
  }

  /// This method saves into a PNG file the binary data obtained from a widget rendering 
  /// task, based on the directive passed to `saveMode`.
  /// 
  /// If there is no Widget attached or if an error occurs during the convertion, this
  /// method executes the callback passed to the `onError` argument.
  /// 
  Future<void> trySavePng({
    required String fileName,
    SaveMode saveMode = SaveMode.filePicker,
    String filePickerTitle = "",
    void Function()? onError
  }) async {
    try {
      await savePng(
        fileName: fileName,
        saveMode: saveMode,
        filePickerTitle: filePickerTitle
      );
    } on Exception catch(_) {
      if(onError != null) {
        onError();
      }
    }
  }

  /// This method saves into a JPG file the binary data obtained from a widget rendering 
  /// task, based on the directive passed to `saveMode`.
  /// 
  /// If there is no Widget attached or if an error occurs during the convertion, this
  /// method throws an `Exception`.
  /// 
  Future<void> saveJpg({
    required String fileName,
    int quality = 100,
    SaveMode saveMode = SaveMode.filePicker,
    String filePickerTitle = ""
  }) async {
    Uint8List? jpgByteList = await getJpg(quality: quality);

    if(jpgByteList != null) {
      saveBytes(
        byteList: jpgByteList, 
        fileName: fileName, 
        fileExtension: "jpg",
        saveMode: saveMode,
        filePickerTitle: filePickerTitle
      );

      return;
    }

    throw Exception("An error occurred during the Widget conversion to JPG.");
  }

  /// This method saves into a JPG file the binary data obtained from a widget rendering 
  /// task, based on the directive passed to `saveMode`.
  /// 
  /// If there is no Widget attached or if an error occurs during the convertion, this
  /// method executes the callback passed to the `onError` argument.
  /// 
  Future<void> trySaveJpg({
    required String fileName,
    int quality = 100,
    SaveMode saveMode = SaveMode.filePicker,
    String filePickerTitle = "",
    void Function()? onError
  }) async {
    try {
      await saveJpg(
        fileName: fileName,
        quality: quality,
        saveMode: saveMode,
        filePickerTitle: filePickerTitle
      );
    } on Exception catch(_) {
      if(onError != null) {
        onError();
      }
    }
  }
}

/// [CaptureBox] wraps the Widget passed to its `child` attribute, allowing calls coming
/// from its `controller` to trigger a rendering task, resulting in a [Uint8List] that can
/// be converted to several image and document file types.
/// 
class CaptureBox extends StatefulWidget {
  const CaptureBox({
    super.key,
    required this.controller,
    required this.child,
  });

  final CaptureBoxController controller;
  final Widget child;

  @override
  State<CaptureBox> createState() => _CaptureBoxState();
}

class _CaptureBoxState extends State<CaptureBox> {
  @override
  void initState() {
    if(widget.controller._attached) {
      throw Exception(
        "You can only use one CaptureBox for each CaptureBoxController instance."
      );
    }

    widget.controller._attached = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    key: widget.controller._boxKey,
    child: widget.child,
  );

  @override
  void dispose() {
    widget.controller._attached = false;
    super.dispose();
  }
}
