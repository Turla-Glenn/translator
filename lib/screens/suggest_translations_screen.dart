import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SuggestTranslationsScreen extends StatefulWidget {
  @override
  _SuggestTranslationsScreenState createState() => _SuggestTranslationsScreenState();
}

class _SuggestTranslationsScreenState extends State<SuggestTranslationsScreen> {
  final TextEditingController _kapampanganController = TextEditingController();
  final TextEditingController _filipinoController = TextEditingController();
  final TextEditingController _englishController = TextEditingController();
  List<Map<String, String>> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();  // Load saved suggestions when the app starts
  }

  // Load saved suggestions from SharedPreferences
  Future<void> _loadSuggestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSuggestions = prefs.getString('suggestions');
    if (savedSuggestions != null) {
      print("Loaded suggestions from storage: $savedSuggestions");
      setState(() {
        _suggestions = List<Map<String, String>>.from(json.decode(savedSuggestions));
      });
    } else {
      print("No suggestions found in storage.");
    }
  }

  // Save suggestions to SharedPreferences
  Future<void> _saveSuggestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedSuggestions = json.encode(_suggestions);
    bool result = await prefs.setString('suggestions', encodedSuggestions);
    if (result) {
      print("Suggestions saved: $encodedSuggestions");
    } else {
      print("Failed to save suggestions.");
    }
  }

  // Add the user's suggestion to the list and save it
  void _addSuggestion() {
    if (_kapampanganController.text.isNotEmpty) {
      setState(() {
        _suggestions.add({
          'kapampangan': _kapampanganController.text,
          'filipino': _filipinoController.text,
          'english': _englishController.text,
        });
      });

      // Save suggestions to local storage
      _saveSuggestions();

      // Clear the input fields
      _kapampanganController.clear();
      _filipinoController.clear();
      _englishController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kapampangan word/phrase is required')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggest Translations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kapampangan input field
            TextField(
              controller: _kapampanganController,
              decoration: InputDecoration(
                labelText: 'Kapampangan Word/Phrase',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.translate),
              ),
            ),
            SizedBox(height: 10),

            // Filipino input field
            TextField(
              controller: _filipinoController,
              decoration: InputDecoration(
                labelText: 'Filipino Translation (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.g_translate),
              ),
            ),
            SizedBox(height: 10),

            // English input field
            TextField(
              controller: _englishController,
              decoration: InputDecoration(
                labelText: 'English Translation (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
            ),
            SizedBox(height: 20),

            // Submit button
            ElevatedButton(
              onPressed: _addSuggestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Submit Suggestion',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Display the suggestions
            Expanded(
              child: _suggestions.isEmpty
                  ? Center(child: Text('No suggestions yet.'))
                  : ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  var suggestion = _suggestions[index];
                  return Card(
                    child: ListTile(
                      title: Text('Kapampangan: ${suggestion['kapampangan']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (suggestion['filipino']!.isNotEmpty)
                            Text('Filipino: ${suggestion['filipino']}'),
                          if (suggestion['english']!.isNotEmpty)
                            Text('English: ${suggestion['english']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
