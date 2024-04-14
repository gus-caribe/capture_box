import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capture_box/capture_box.dart';
import 'package:capture_box/extensions/pdf.dart';

void main() {
  final CaptureBoxController controller = CaptureBoxController();
  final MaterialApp baseCaptureBox = MaterialApp(home: Scaffold(
    appBar: AppBar(
      title: const Text('CaptureBox Example'),
    ),
    body: Center(child: CaptureBox(
      controller: controller, 
      child: Container(
        color: Colors.red,
        child: const Text("Widget Test"),
      )
    )),
  ));

  group("CaptureBox", () {
    testWidgets("getPng", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);

      Uint8List? result;

      await widgetTester.runAsync(
        () async => result = await controller.getPng()
      );

      expect(result, isNotNull);
    });

    testWidgets("getJpg", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);

      Uint8List? result;

      await widgetTester.runAsync(
        () async => result = await controller.getJpg()
      );

      expect(result, isNotNull);
    });

    testWidgets("savePng", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);
      expect(
        () async => await controller.savePng(fileName: "test"), 
        isA<void>()
      );
    });

    
    testWidgets("saveJpg", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);
      expect(
        () async => await controller.saveJpg(fileName: "test"), 
        isA<void>()
      );
    });

    testWidgets("trySavePng - valid byteList", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);

      bool failed = false;

      await widgetTester.runAsync(
        () async => await controller.trySavePng(
          fileName: "test",
          onError: () => failed = true
        )
      );

      expect(failed, isFalse);
    });

    testWidgets("trySaveJpg - valid byteList", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);

      bool failed = false;

      await widgetTester.runAsync(
        () async => await controller.trySaveJpg(
          fileName: "test",
          onError: () => failed = true
        )
      );

      expect(failed, isFalse);
    });

    testWidgets("trySavePng - invalid byteList", (widgetTester) async {
      final CaptureBoxController unboundController = CaptureBoxController();

      await widgetTester.pumpWidget(const SizedBox.shrink());

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsNothing);

      bool failed = false;

      await widgetTester.runAsync(
        () async => await unboundController.trySavePng(
          fileName: "test",
          onError: () => failed = true
        )
      );

      expect(failed, isTrue);
    });

    testWidgets("trySaveJpg - invalid byteList", (widgetTester) async {
      final CaptureBoxController unboundController = CaptureBoxController();

      await widgetTester.pumpWidget(const SizedBox.shrink());

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsNothing);

      bool failed = false;

      await widgetTester.runAsync(
        () async => await unboundController.trySaveJpg(
          fileName: "test",
          onError: () => failed = true
        )
      );

      expect(failed, isTrue);
    });
  });

  group("CaptureBox_ext_pdf", () {
    testWidgets("getPdf", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);

      Uint8List? result = await controller.getPdf();

      expect(result, isNotNull);
    });

    testWidgets("savePdf", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);
      expect(
        () async => await controller.savePdf(fileName: "test"), 
        isA<void>()
      );
    });

    testWidgets("trySavePdf - valid byteList", (widgetTester) async {
      await widgetTester.pumpWidget(baseCaptureBox);

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsOneWidget);

      bool failed = false;

      await controller.trySavePdf(
        fileName: "test",
        onError: () => failed = true
      );

      expect(failed, isFalse);
    });

    testWidgets("trySavePdf - invalid byteList", (widgetTester) async {
      await widgetTester.pumpWidget(const SizedBox.shrink());

      final Finder widgetTestFinder = find.text("Widget Test");

      expect(widgetTestFinder, findsNothing);

      bool failed = false;

      await controller.trySavePdf(
        fileName: "test",
        onError: () => failed = true
      );

      expect(failed, isTrue);
    });
  });
}
