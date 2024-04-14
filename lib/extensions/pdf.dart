library capture_box_pdf;

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widgets;
import 'package:printing/printing.dart';

import 'package:capture_box/capture_box.dart';

extension CaptureBoxControllerPdf on CaptureBoxController {
  Future<Uint8List?> _pngToPdf(
    Uint8List pngByteList,
    {
      PdfPageMode pageMode = PdfPageMode.thumbs,
      bool compress = false,
      PdfVersion pdfVersion = PdfVersion.pdf_1_5,
      PdfPageFormat pageFormat = PdfPageFormat.undefined,
      pdf_widgets.PageOrientation? pageOrientation,
      String? title,
      String? author,
      String? creator,
      String? subject,
      String? keywords,
      String? producer,
    }
  ) async {
    final pdf_widgets.Document doc = pdf_widgets.Document(
      pageMode: pageMode,
      compress: compress,
      version: pdfVersion,
      title: title,
      author: author,
      creator: creator,
      subject: subject,
      keywords: keywords,
      producer: producer,
    );

    doc.addPage(pdf_widgets.Page(
      pageFormat: pageFormat,
      orientation: pageOrientation,
      build: (pdf_widgets.Context context) => pdf_widgets.Center(
        child: pdf_widgets.Image(pdf_widgets.MemoryImage(pngByteList)),
      ),
    ));

    return await doc.save();
  }

  Future<Uint8List?> getPdf({
    PdfPageMode pageMode = PdfPageMode.thumbs,
    bool compress = false,
    PdfVersion pdfVersion = PdfVersion.pdf_1_5,
    PdfPageFormat pageFormat = PdfPageFormat.undefined,
    pdf_widgets.PageOrientation? pageOrientation,
    String? title,
    String? author,
    String? creator,
    String? subject,
    String? keywords,
    String? producer,
  }) async {
    Uint8List? pngByteList = await getPng();

    if(pngByteList != null) {
      return await _pngToPdf(
        pngByteList,
        pageMode: pageMode,
        compress: compress,
        pdfVersion: pdfVersion,
        pageFormat: pageFormat,
        pageOrientation: pageOrientation,
        title: title,
        author: author,
        creator: creator,
        subject: subject,
        keywords: keywords,
        producer: producer
      );
    }

    return null;
  }

  Future<void> savePdf({
    required String fileName,
    SaveMode saveMode = SaveMode.filePicker,
    String filePickerTitle = "",
    PdfPageMode pageMode = PdfPageMode.thumbs,
    bool compress = false,
    PdfVersion pdfVersion = PdfVersion.pdf_1_5,
    PdfPageFormat pageFormat = PdfPageFormat.undefined,
    pdf_widgets.PageOrientation? pageOrientation,
    String? title,
    String? author,
    String? creator,
    String? subject,
    String? keywords,
    String? producer,
  }) async {
    Uint8List? pdfByteList = await getPdf(
      pageMode: pageMode,
      compress: compress,
      pdfVersion: pdfVersion,
      pageFormat: pageFormat,
      pageOrientation: pageOrientation,
      title: title,
      author: author,
      creator: creator,
      subject: subject,
      keywords: keywords,
      producer: producer
    );

    if(pdfByteList != null) {
      saveBytes(
        byteList: pdfByteList, 
        fileName: fileName, 
        fileExtension: "pdf",
        saveMode: saveMode,
        filePickerTitle: filePickerTitle
      );

      return;
    }

    throw Exception("An error occurred during the Widget conversion to PDF.");
  }

  Future<void> trySavePdf({
    required String fileName,
    SaveMode saveMode = SaveMode.filePicker,
    String filePickerTitle = "",
    PdfPageMode pageMode = PdfPageMode.thumbs,
    bool compress = false,
    PdfVersion pdfVersion = PdfVersion.pdf_1_5,
    PdfPageFormat pageFormat = PdfPageFormat.undefined,
    pdf_widgets.PageOrientation? pageOrientation,
    String? title,
    String? author,
    String? creator,
    String? subject,
    String? keywords,
    String? producer,
    void Function()? onError
  }) async {
    try {
      await savePdf(
        fileName: fileName,
        saveMode: saveMode,
        filePickerTitle: filePickerTitle,
        pageMode: pageMode,
        compress: compress,
        pdfVersion: pdfVersion,
        pageFormat: pageFormat,
        pageOrientation: pageOrientation,
        title: title,
        author: author,
        creator: creator,
        subject: subject,
        keywords: keywords,
        producer: producer
      );
    } on Exception catch(_) {
      if(onError != null) {
        onError();
      }
    }
  }

  Future<void> printPdf({
    required String fileName,
    PdfPageMode pageMode = PdfPageMode.thumbs,
    bool compress = false,
    PdfVersion pdfVersion = PdfVersion.pdf_1_5,
    PdfPageFormat pageFormat = PdfPageFormat.undefined,
    pdf_widgets.PageOrientation? pageOrientation,
    String? title,
    String? author,
    String? creator,
    String? subject,
    String? keywords,
    String? producer,
  }) async {
    if(!(await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => await getPdf(
        pageMode: pageMode,
        compress: compress,
        pdfVersion: pdfVersion,
        pageFormat: format,
        pageOrientation: pageOrientation,
        title: title,
        author: author,
        creator: creator,
        subject: subject,
        keywords: keywords,
        producer: producer
      ) ?? Uint8List(0),
      name: fileName,
      format: pageFormat
    ))) {
      throw Exception(
        "An error occurred while gererating the PDF printing layout."
      );
    }
  }

  Future<void> tryPrintPdf({
    required String fileName,
    PdfPageMode pageMode = PdfPageMode.thumbs,
    bool compress = false,
    PdfVersion pdfVersion = PdfVersion.pdf_1_5,
    PdfPageFormat pageFormat = PdfPageFormat.undefined,
    pdf_widgets.PageOrientation? pageOrientation,
    String? title,
    String? author,
    String? creator,
    String? subject,
    String? keywords,
    String? producer,
    void Function()? onError
  }) async {
    try {
      await printPdf(
        fileName: fileName,
        pageMode: pageMode,
        compress: compress,
        pdfVersion: pdfVersion,
        pageFormat: pageFormat,
        pageOrientation: pageOrientation,
        title: title,
        author: author,
        creator: creator,
        subject: subject,
        keywords: keywords,
        producer: producer
      );
    } on Exception catch(_) {
      if(onError != null) {
        onError();
      }
    }
  }
}