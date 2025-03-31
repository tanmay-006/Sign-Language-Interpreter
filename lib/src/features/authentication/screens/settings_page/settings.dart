import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_2/src/features/authentication/screens/settings_page/report.dart';
import 'package:vibration/vibration.dart';
import '../FQAS/faq.dart';
import '../welcome/welcome.dart';
import 'help.dart';
import 'location.dart'; // Import the real LocationPage
import '../main_page/main_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Settings(),
    ),
  );
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF52796F),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF52796F),
          secondary: Color(0xFF84A98C),
          tertiary: Color(0xFFCAD2C5),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF52796F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF52796F),
          secondary: Color(0xFF84A98C),
          tertiary: Color(0xFFCAD2C5),
        ),
      ),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = const Color(0xFF52796F);
    final secondaryColor = const Color(0xFF84A98C);
    final tertiaryColor = const Color(0xFFCAD2C5);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () {
            handleInteraction("Back to Main Page");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Modelpage(
                        cameras: [],
                      )),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),

                  // AI Settings button with prominent styling
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 16),
                  //   decoration: BoxDecoration(
                  //     color: primaryColor,
                  //     borderRadius: BorderRadius.circular(12),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: primaryColor.withOpacity(0.2),
                  //         blurRadius: 8,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: ListTile(
                  //     onTap: () {
                  //       handleInteraction("AI Settings");
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const AISettingsPage()),
                  //       );
                  //     },
                  //     contentPadding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 8),
                  //     leading: const Icon(Icons.smart_toy,
                  //         color: Colors.white, size: 30),
                  //     title: const Text(
                  //       "AI Settings",
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     subtitle: const Text(
                  //       "Configure AI behavior and preferences",
                  //       style: TextStyle(color: Colors.white70),
                  //     ),
                  //     trailing: const Icon(Icons.arrow_forward_ios,
                  //         color: Colors.white),
                  //   ),
                  // ),

                  // Existing settings options
                  buildSwitchTile(
                    "Haptic Feedback",
                    themeProvider.isHapticEnabled,
                    (value) {
                      themeProvider.setHapticFeedback(value);
                      handleInteraction(
                          "Haptic Feedback ${value ? 'enabled' : 'disabled'}");
                    },
                    secondaryColor,
                  ),
                  buildSwitchTile(
                    "Dark Mode",
                    themeProvider.isDarkMode,
                    (value) {
                      themeProvider.toggleTheme(value);
                      handleInteraction(
                          "Dark Mode ${value ? 'enabled' : 'disabled'}");
                    },
                    secondaryColor,
                  ),
                  buildSwitchTile(
                    "TalkBack (Screen Reader)",
                    themeProvider.isTalkBackEnabled,
                    (value) {
                      themeProvider.setTalkBack(value);
                      handleInteraction(
                          "TalkBack ${value ? 'enabled' : 'disabled'}");
                    },
                    secondaryColor,
                  ),

                  const SizedBox(height: 24),

                  // Additional settings options
                  buildSettingsButton(
                    "Location",
                    Icons.location_on,
                    const LocationPage(), // Use the proper LocationPage widget with const
                    secondaryColor,
                  ),
                  buildSettingsButton(
                    "Report a problem",
                    Icons.error_outline,
                    const ReportIssuePage(),
                    secondaryColor,
                  ),
                  buildSettingsButton(
                    "Help",
                    Icons.help_outline,
                    HelpPage(),
                    secondaryColor,
                  ),
                  buildSettingsButton(
                    "FAQs",
                    Icons.question_answer,
                    FAQPageState(),
                    secondaryColor,
                  ),
                ],
              ),
            ),
            buildSettingsButton(
                "Log out", Icons.logout, null, Colors.red.shade400,
                isLogout: true),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void handleInteraction(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (themeProvider.isHapticEnabled) {
      HapticFeedback.lightImpact();
      triggerVibration(500);
    }
    if (themeProvider.isTalkBackEnabled) {
      speak(message);
    }
  }

  void triggerVibration(int duration) async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: duration);
    }
  }

  void speak(String text) async {
    await flutterTts.speak(text);
  }

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged,
      Color backgroundColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF52796F),
        value: value,
        onChanged: (newValue) {
          onChanged(newValue);
        },
      ),
    );
  }

  Widget buildSettingsButton(
      String title, IconData icon, Widget? targetScreen, Color backgroundColor,
      {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(title,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          handleInteraction(title);
          if (isLogout) {
            showLogoutDialog(context);
          } else if (targetScreen != null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => targetScreen));
          }
        },
      ),
    );
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color(0xFFCAD2C5),
        title: const Center(
            child: Text("Logout Account",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF2C3639)))),
        content: const Text("Are you sure you want to log out?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF2C3639))),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF84A98C)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
                child:
                    const Text("Logout", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isHapticEnabled = false;
  bool _isTalkBackEnabled = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isHapticEnabled => _isHapticEnabled;
  bool get isTalkBackEnabled => _isTalkBackEnabled;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setHapticFeedback(bool value) {
    _isHapticEnabled = value;
    notifyListeners();
  }

  void setTalkBack(bool value) {
    _isTalkBackEnabled = value;
    notifyListeners();
  }
}
