import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/controllers/pdfTextDisplay.dart';
import 'package:pdf_reader/readPdf.dart';
import 'package:pdf_reader/widgets/flutterToast.dart';

// This is the app that allows user to select a pdf file.
// It then displays the contents of the pdf and
//then read it using Text to speech feature.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF READER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'PDF Reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: false,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(100),
              bottomLeft: Radius.circular(10)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 250),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: InkWell(
          onTap: () async {
            // This allows to pick a file of extension "pdf" only and geta file path.
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            if (result != null) {
              File? file = File(result.files.single.path.toString());
              //with the help of extractTextFromPDF() method , the content of the pdf is converted to a string and sent as a parameter to PdfReaderPage().
              String docText = await ExtractText.extractTextFromPDF(file.path);
              Route route = MaterialPageRoute(
                  builder: (_) => PdfReaderPage(docText: docText));
              // ignore: use_build_context_synchronously
              Navigator.push(context, route);
            } else {
              MyToast.show(
                  "You did not select any file.\nPlease select a pdf to read.");
            }
          },
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red.shade400,
            ),
            child: const Text(
              "Get A Pdf File To Read.",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}
