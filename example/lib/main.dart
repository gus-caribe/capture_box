import 'package:capture_box/extensions/pdf.dart';
import 'package:flutter/material.dart';
import 'package:capture_box/capture_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CaptureBoxController captureBoxController = CaptureBoxController();
  final TextEditingController textTitleController = TextEditingController();
  final TextEditingController textColorController = TextEditingController();

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('CaptureBox Example'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.sizeOf(context).width * 0.1,
          30, 
          MediaQuery.sizeOf(context).width * 0.1, 
          100
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textTitleController,
              onChanged: (value) => setState(() {}),
              decoration: const InputDecoration(
                hintText: "Insert Title"
              ),
            ),
            TextField(
              controller: textColorController,
              onChanged: (value) => setState(() {}),
              decoration: const InputDecoration(
                prefix: Text('#'),
                hintText: "Insert a Color"
              ),
            ),
            CaptureBox(
              controller: captureBoxController, 
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.5,
                margin: const EdgeInsets.symmetric(vertical: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(
                    int.tryParse(
                      textColorController.text, 
                      radix: 16
                    ) ?? 0xFF000000
                  ),
                ),
                alignment: Alignment.center,
                child: Text("Example: ${textTitleController.text}"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => captureBoxController.savePng(
                    fileName: "example"
                  ), 
                  child: const Text("PNG")
                ),
                TextButton(
                  onPressed: () => captureBoxController.saveJpg(
                    fileName: "example"
                  ),  
                  child: const Text("JPG")
                ),
                TextButton(
                  onPressed: () => captureBoxController.savePdf(
                    fileName: "example"
                  ), 
                  child: const Text("PDF")
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
