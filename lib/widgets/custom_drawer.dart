import 'package:flutter/material.dart';
import 'package:translator/screens/text_to_text_screen.dart';
import 'package:translator/screens/text_to_speech_screen.dart';
import 'package:translator/screens/voice_to_text_screen.dart';
import 'package:translator/screens/camera_to_text_screen.dart';
import 'package:translator/screens/dictionary_screen.dart';
import 'package:translator/screens/phrasebook_screen.dart';
import 'package:translator/screens/history_screen.dart';
import 'package:translator/screens/suggest_translations_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Translator Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Text to Text'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextToTextScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text('Text to Speech'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextToSpeechScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.mic),
            title: Text('Voice to Text'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VoiceToTextScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera to Text'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraToTextScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Dictionary'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DictionaryScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Phrasebook'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhrasebookScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
    ListTile(
    leading: Icon(Icons.settings_suggest_rounded),
    title: Text('Suggest Translations'),  // New Suggest Translations section
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SuggestTranslationsScreen()),
    );
    },
    )
        ],
      ),
    );
  }
}
