import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class CameraToTextScreen extends StatefulWidget {
  @override
  _CameraToTextScreenState createState() => _CameraToTextScreenState();
}

class _CameraToTextScreenState extends State<CameraToTextScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  String _extractedText = 'No text recognized';
  String _translatedText = '';
  late TextRecognizer textRecognizer;
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
    _initializeCamera();
    textRecognizer = GoogleMlKit.vision.textRecognizer();
  }

  // Initialize the camera
  void _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  // Capture the image and recognize text
  void _captureAndRecognizeText() async {
    final image = await _cameraController.takePicture();
    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _extractedText = recognizedText.text;
      _translateText(_extractedText);  // Perform translation based on mode
    });
  }

  // Translate the recognized text based on the selected mode
  void _translateText(String input) {
    // Translation logic here (similar to the text-to-text or voice-to-text logic)
    // For now, it will just set the translation equal to input for example purposes.
    setState(() {
      _translatedText = 'Translated Text: ' + input;
    });
  }

  // Copy text to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera to Text'),
      ),
      body: Column(
        children: [
          if (_isCameraInitialized)
            Expanded(
              child: CameraPreview(_cameraController),  // Full-screen camera preview
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Translation mode selection dropdown
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
                SizedBox(height: 10),

                // Recognized and translated text display
                Text(
                  'Recognized Text: $_extractedText',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  _translatedText,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Copy buttons for recognized and translated text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _copyToClipboard(_extractedText),
                        child: Text('Copy Recognized Text'),
                      ),
                    ),
                    SizedBox(width: 10), // Space between the buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _copyToClipboard(_translatedText),
                        child: Text('Copy Translated Text'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Capture and Translate Button
                ElevatedButton(
                  onPressed: _captureAndRecognizeText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Translate',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    textRecognizer.close();
    super.dispose();
  }
}
