import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import 'settings.dart';

class SpeedPage extends StatelessWidget {
  const SpeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Morse Code Translator"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MorseConverterScreen(),
      ),
    );
  }
}

class MorseConverterScreen extends StatefulWidget {
  const MorseConverterScreen({super.key});

  @override
  _MorseConverterScreenState createState() => _MorseConverterScreenState();
}

class _MorseConverterScreenState extends State<MorseConverterScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String morseInput = "";
  String outputText = "";
  String accumulatedText = "";
  DateTime? pressStartTime;

  final Map<String, String> morseToLetter = {
    ".-": "A",
    "-...": "B",
    "-.-.": "C",
    "-..": "D",
    ".": "E",
    "..-.": "F",
    "--.": "G",
    "....": "H",
    "..": "I",
    ".---": "J",
    "-.-": "K",
    ".-..": "L",
    "--": "M",
    "-.": "N",
    "---": "O",
    ".--.": "P",
    "--.-": "Q",
    ".-.": "R",
    "...": "S",
    "-": "T",
    "..-": "U",
    "...-": "V",
    ".--": "W",
    "-..-": "X",
    "-.--": "Y",
    "--..": "Z",
    ".----": "1",
    "..---": "2",
    "...--": "3",
    "....-": "4",
    ".....": "5",
    "-....": "6",
    "--...": "7",
    "---..": "8",
    "----.": "9",
    "-----": "0",
    ".-.-.-": ".",
    "--..--": ",",
    "..--..": "?",
    "-.-.--": "!",
    "-..-.": "/",
    "-.--.": "(",
    "-.--.-": ")",
    ".-...": "&",
    "---...": ":",
    "-.-.-.": ";",
    "-...-": "=",
    ".-.-.": "+",
    "-....-": "-",
    "..--.-": "_",
    ".-..-.": "\"",
    ".--.-.": "@",
  };

  void processMorse() {
    setState(() {
      String convertedChar = morseToLetter[morseInput.trim()] ?? "?";
      outputText = convertedChar;
      accumulatedText += convertedChar;
      morseInput = "";
    });
  }

  void clearOutput() {
    setState(() {
      outputText = "";
      accumulatedText = "";
      morseInput = "";
    });
  }

  void speakText() async {
    if (accumulatedText.isNotEmpty) {
      await flutterTts.speak(accumulatedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = const Color(0xFF52796F);
    final secondaryColor = const Color(0xFF84A98C);
    final tertiaryColor = const Color(0xFFCAD2C5);

    return Column(
      children: [
        // Instructions Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: isDark ? Colors.grey.shade800 : tertiaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How to use Morse Code:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "• Tap for dot (.)\n• Swipe for dash (-)\n• Double tap for space\n• Long press to speak text",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Output display
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    outputText,
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Current Morse Code:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    morseInput.isEmpty ? "No input" : morseInput,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Accumulated text display
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: secondaryColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Translated Text:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                accumulatedText.isEmpty ? "No text yet" : accumulatedText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // Morse input area
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              setState(() => morseInput += ".");
              Vibration.vibrate(duration: 100);
            },
            onHorizontalDragEnd: (_) {
              setState(() => morseInput += "-");
              Vibration.vibrate(duration: 200);
            },
            onLongPressStart: (_) {
              pressStartTime = DateTime.now();
            },
            onLongPressEnd: (_) {
              if (pressStartTime == null) return;
              final pressDuration = DateTime.now().difference(pressStartTime!);
              if (pressDuration.inSeconds >= 1) {
                speakText();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Speaking text..."),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: secondaryColor,
                  ),
                );
              }
            },
            onDoubleTap: () {
              setState(() => accumulatedText += " ");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Space added"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: secondaryColor,
                  duration: const Duration(milliseconds: 500),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.shade900
                    : tertiaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: secondaryColor,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 40,
                    color: isDark ? secondaryColor : primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tap or Swipe Here",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap for dot • Swipe for dash",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: clearOutput,
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear All"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: processMorse,
                  icon: const Icon(Icons.translate),
                  label: const Text("Convert"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
