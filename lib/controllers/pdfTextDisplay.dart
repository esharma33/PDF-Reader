import 'dart:io';

import 'package:pdf_text/pdf_text.dart';

// This class is used to extract text from Pdf.
class ExtractText {
  static Future<String> extractTextFromPDF(String path) async {
PDFDoc doc = await PDFDoc.fromPath(path);
  String docText = await doc.text;
  return docText;
}
}
