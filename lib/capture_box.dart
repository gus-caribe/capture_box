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

  Future<Uint8List?> getPng() async {
    return await _widgetToPng();
  }

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
