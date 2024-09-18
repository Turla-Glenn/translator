import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  late stt.SpeechToText _speech;  // Speech to text object
  bool _isListening = false;
  String _recognizedText = "Press the button and start speaking";
  String _translatedText = '';
  List<dynamic> _dictionaryData = [];
  FlutterTts flutterTts = FlutterTts();  // Text-to-Speech object

  // Dropdown list of language translation modes
  String _selectedTranslationMode = 'Kapampangan to English';
  final List<String> _translationModes = [
    'Kapampangan to English',
    'English to Kapampangan',
    'Tagalog to Kapampangan',
    'Kapampangan to Tagalog',
    'English to Tagalog',
    'Tagalog to English',
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadDictionaryData(); // Load translation data from JSON
  }

  // Load JSON data for translation
  Future<void> _loadDictionaryData() async {
    final String response = await rootBundle.loadString('assets/data/kapampangan_table_kapampangan.json');
    final data = await json.decode(response);
    setState(() {
      _dictionaryData = data['data'];  // Extract the data array from JSON
    });
  }

  // Start speech-to-text listening
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _recognizedText = val.recognizedWords;
            _translateText(_recognizedText);  // Translate recognized text based on mode
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // Translate the recognized text based on the selected mode
  void _translateText(String input) {
    String normalizedInput = input.trim().toLowerCase();  // Normalize input

    var translation;
    switch (_selectedTranslationMode) {
      case 'Kapampangan to English':
        translation = _dictionaryData.firstWhere(
              (entry) => entry['kapampangan'].toString().toLowerCase() == normalizedInput,
          orElse: () => null,
        );
        setState(() {
          _translatedText = translation != null ? translation['english'] : 'Translation not found';
        });
        break;

      case 'English to Kapampangan':
        translation = _dictionaryData.firstWhere(
              (entry) => entry['english'].toString().toLowerCase() == normalizedInput,
          orElse: () => null,
        );
        setState(() {
          _translatedText = translation != null ? translation['kapampangan'] : 'Translation not found';
        });
        break;

      case 'Tagalog to Kapampangan':
        translation = _dictionaryData.firstWhere(
              (entry) => entry['filipino'].toString().toLowerCase() == normalizedInput,
          orElse: () => null,
        );
        setState(() {
          _translatedText = translation != null ? translation['kapampangan'] : 'Translation not found';
        });
        break;

      case 'Kapampangan to Tagalog':
        translation = _dictionaryData.firstWhere(
              (entry) => entry['kapampangan'].toString().toLowerCase() == normalizedInput,
          orElse: () => null,
        );
        setState(() {
          _translatedText = translation != null ? translation['filipino'] : 'Pagsasalin hindi natagpuan';
        });
        break;

      case 'English to Tagalog':
        translation = _dictionaryData.firstWhere(
              (entry) => entry['english'].toString().toLowerCase() == normalizedInput,
          orElse: () => null,
        );
        setState(() {
          _translatedText = translation != null ? translation['filipino'] : 'Pagsasalin hindi natagpuan';
        });
        break;

      case 'Tagalog to English':
        translation = _dictionaryData.firstWhere(
              (entry) => entry['filipino'].toString().toLowerCase() == normalizedInput,
          orElse: () => null,
        );
        setState(() {
          _translatedText = translation != null ? translation['english'] : 'Translation not found';
        });
        break;
    }
  }

  // Function to speak the input or translated text
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US"); // Set the language of the TTS
    await flutterTts.setPitch(1.0); // Set pitch level
    await flutterTts.speak(text); // Speak the text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice to Text with Translation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dropdown for selecting translation mode
              DropdownButton<String>(
                value: _selectedTranslationMode,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.blue, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTranslationMode = newValue!;
                  });
                },
                items: _translationModes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Container for displaying recognized text
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recognized Text:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _recognizedText,
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Button to listen to the recognized text
              ElevatedButton(
                onPressed: () => _speak(_recognizedText),
                child: Text('Listen to Recognized Text'),
              ),
              SizedBox(height: 30),

              // Display translated text
              Text(
                'Translation: $_translatedText',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Button to listen to the translated text
              ElevatedButton(
                onPressed: () => _speak(_translatedText),
                child: Text('Listen to Translated Text'),
              ),
              SizedBox(height: 40),

              // Floating Action Button to start/stop listening
              FloatingActionButton(
                onPressed: _startListening,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
              SizedBox(height: 10),
              Text(
                _isListening ? "Listening..." : "Tap the microphone to speak",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
