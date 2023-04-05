import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_reader/widgets/flutterToast.dart';
 // This page displays the pdf content in a form of a dialogue box along with buttons to start reading a pdf, pause and then resume reading it.
class PdfReaderPage extends StatefulWidget {
  String docText = "";
  PdfReaderPage({required this.docText, super.key});

  @override
  State<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  late FlutterTts flutterTts;
  String? _newVoiceText;

  double volume = 0.5;
  double rate = 0.5;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() async {
    flutterTts = FlutterTts();
    await initText();
    _setAwaitOptions();
    flutterTts.setLanguage("en-US");
  // This function is called in order to convert text into speech.
    flutterTts.setStartHandler(() {
      setState(() {
        log("Playing");
      });
    });
 // This function is called to pause the flutter tts.
    flutterTts.setPauseHandler(() {
      setState(() {
        log("Paused");
        flutterTts.pause();
      });
    });
    // this is the error Handing function for flutter tts.
    flutterTts.setErrorHandler((msg) {
      setState(() {
        MyToast.show("The pdf cannot be read, Sorry.");

        log("error: $msg");
      });
    });
  }
 // this method is called to initialize the pdf text to the speech text.
  Future<void> initText() async {
    List<String> lines = widget.docText.split("\n");
    List<String> nonEmptyLines =
        lines.where((line) => line.trim().isNotEmpty).toList();
    String result = nonEmptyLines.join(" ");
    _newVoiceText = result;
  }
 // this method is called to speak the text extracted from pdf.
  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    //await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }
 // This is an important function as it waits if some other speaking is going on and then continue speaking.
  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }
 // This method is called to stop the speech.
  Future _stop() async {
     await flutterTts.stop();
  }
  // This method is called to pause the speech.

  Future _pause() async {
  await flutterTts.pause();
    // if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDF TEXT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade400,
                      blurRadius: 5.0, 
                      spreadRadius: 2.0, 
                      // offset: const Offset(
                      //   0.0, // Move to right 5  horizontally
                      //   0.0, // Move to bottom 5 Vertically
                      // ),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.docText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(Colors.green, Colors.greenAccent, Icons.play_arrow,
                  Colors.green.shade200, 'PLAY', _speak),
              _buildButton(Colors.red, Colors.redAccent, Icons.stop,
                  Colors.red.shade200, 'STOP', _stop),
              _buildButton(Colors.blue, Colors.blueAccent, Icons.pause,
                  Colors.blue.shade200, 'PAUSE', _pause),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
 // reusable button widget.
  Column _buildButton(Color color, Color splashColor, IconData icon,
      Color shadowColor, String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: shadowColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 4.0, // soften the shadow
                  spreadRadius: 1.0, //extend the shadow
                  offset: const Offset(
                    0.0, // Move to right 5  horizontally
                    0.0, // Move to bottom 5 Vertically
                  ),
                ),
              ],
            ),
            child: IconButton(
                icon: Icon(icon),
                color: color,
                iconSize: 30,
                splashColor: splashColor,
                onPressed: () => func()),
          ),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: color)))
        ]);
  }
}
