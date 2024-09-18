import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

class TextToTextScreen extends StatefulWidget {
  @override
  _TextToTextScreenState createState() => _TextToTextScreenState();
}

class _TextToTextScreenState extends State<TextToTextScreen> {
  final TextEditingController _controller = TextEditingController();
  String _inputText = '';
  String _translatedText = '';
  List<dynamic> _dictionaryData = [];

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

  // Text to Speech object
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
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

  // Translate the entered text based on the selected mode
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
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text to Text with Translation'),
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

              // Input text field
              TextField(
                controller: _controller,
                onChanged: (text) {
                  setState(() {
                    _inputText = text;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter text to translate',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Button to listen to the input text
              ElevatedButton(
                onPressed: () => _speak(_inputText),
                child: Text('Listen to Input Text'),
              ),
              SizedBox(height: 20),

              // Translated text display
              Text(
                'Translated Text: $_translatedText',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Button to listen to the translated text
              ElevatedButton(
                onPressed: () => _speak(_translatedText),
                child: Text('Listen to Translated Text'),
              ),
              SizedBox(height: 20),

              // Translate button
              ElevatedButton(
                onPressed: () {
                  _translateText(_controller.text);
                },
                child: Text('Translate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
