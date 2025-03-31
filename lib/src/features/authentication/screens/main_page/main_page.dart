import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

// Updated import path for the AI controller to match the actual file location
import '../../../../controllers/ai_animation_controller.dart';
import '../Camera_page/cam_py.dart';
import '../History_page/history.dart';
import '../account_page/account.dart';
import '../settings_page/lessons.dart';
import '../settings_page/settings.dart';
import '../settings_page/morse.dart';

class Modelpage extends StatelessWidget {
  final List<CameraDescription> cameras;

  const Modelpage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          primaryColor: const Color(0xFF52796F),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF52796F),
            secondary: const Color(0xFF84A98C),
            tertiary: const Color(0xFFCAD2C5),
          ),
          fontFamily: 'Montserrat',
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF52796F),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF52796F),
            secondary: const Color(0xFF84A98C),
            tertiary: const Color(0xFFCAD2C5),
            brightness: Brightness.dark,
          ),
        ),
        home: Chat3DPage(cameras: cameras),
      ),
    );
  }
}

class Chat3DPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Chat3DPage({super.key, required this.cameras});

  @override
  _Chat3DPageState createState() => _Chat3DPageState();
}

class _Chat3DPageState extends State<Chat3DPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';
  final Flutter3DController _modelController = Flutter3DController();
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isModelLoading = true;
  bool _isModelLoaded =
      false; // Add this flag to track when model is actually loaded

  // Add AI Animation Controller
  late AIAnimationController _aiAnimationController;

  // Flag to toggle between standard and AI modes
  bool _useAIMode = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _speech = stt.SpeechToText();

    // Show loading indicator initially
    setState(() {
      _isModelLoading = true;
    });

    // Initialize the AI Animation Controller
    _aiAnimationController = AIAnimationController(
      modelController: _modelController,
    );

    // Simulate model loading with a delayed future
    // We'll set a reasonable delay to give the model time to load
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _onModelLoaded();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) {
          setState(() {
            _isListening = false;
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
              _textController.text = _recognizedText;
            });
            _playAnimationForText(_recognizedText);
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  void _onModelLoaded() {
    // This will be called when the 3D model is fully loaded
    setState(() {
      _isModelLoaded = true;
      _isModelLoading = false;
    });

    // Now it's safe to play the animation
    _modelController.playAnimation(animationName: 'Idle');
  }

  void _playAnimationForText(String text) {
    if (!_isModelLoaded) {
      // Don't attempt to play animations if model isn't loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text("Please wait for the 3D model to finish loading"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      });
      return;
    }

    if (text.isEmpty) {
      _modelController.playAnimation(animationName: 'Idle');
      return;
    }

    // Check if we should use AI mode
    if (_useAIMode) {
      _playAIAnimationForText(text);
    } else {
      _playStandardAnimationForText(text);
    }
  }

  // Play animation using the AI controller
  void _playAIAnimationForText(String text) {
    // Show a processing indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            const Text("Generating sign language..."),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Use the AI controller to generate and play the animation
    _aiAnimationController.generateAndPlayAnimation(text).then((success) {
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Failed to generate sign language animation"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        // Add to history
        HistoryScreen.addRecentItem("AI: $text");
        _handleInteraction("AI animation played: $text");
      }
    });
  }

  // Play animation using the standard approach
  void _playStandardAnimationForText(String text) {
    String animationName = _getAnimationNameForText(text);
    if (animationName.isNotEmpty) {
      _modelController.playAnimation(animationName: animationName);
      HistoryScreen.addRecentItem(text);
      _handleInteraction("Animation played: $text");
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ No animation found for: $text"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      });
    }
  }

  String _getAnimationNameForText(String text) {
    switch (text.toLowerCase()) {
      case 'hello':
        return 'Hello';
      case 'a':
        return 'A';
      case 'b':
        return 'B';
      case 'd':
        return 'D';
      case 'f':
        return 'F';
      case 'i':
        return 'I';
      case 'l':
        return 'L';
      case 'v':
        return 'V';
      case 'w':
        return 'W';
      case 'y':
        return 'Y';
      case 'deaf':
        return 'Deaf';
      case 'love':
        return 'Love';
      case 'are':
        return 'Are';
      case 'me':
        return 'Me';
      case 'thankyou':
        return 'Thankyou';
      case 'seeing':
        return 'Seeing';
      case 'our':
        return 'Our';
      case 'project':
        return 'Project';
      case 'fine':
        return 'Fine';
      case 'idle':
        return 'Idle';
      case 'please':
        return 'Please';
      case 'imfine':
        return 'Imfine';
      case 'nicetomeetyou':
        return 'Nicetomeetyou';
      case 'whatsup':
        return 'Whatsup';
      case 'good':
        return 'Good';
      case 'great':
        return 'Great';
      case 'needhelp?':
        return 'Needhelp?';
      case 'thankyougoodbye':
        return 'Thankyougoodbye';
      case 'howareyou':
        return 'Howareyou';
      default:
        return 'Idle';
    }
  }

  void _handleInteraction(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (themeProvider.isHapticEnabled) {
      HapticFeedback.lightImpact();
      _triggerVibration(500);
      print("Haptic feedback triggered");
    }
    if (themeProvider.isTalkBackEnabled) {
      _speak(message);
      print("Talkback triggered");
    }
  }

  void _triggerVibration(int duration) async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: duration);
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white, size: 26),
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          onSelected: (String choice) {
            _handleInteraction("Menu item selected: $choice");
            if (choice == 'History') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            } else if (choice == 'Speed') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SpeedPage()));
            } else if (choice == 'Lessons') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LessonsApp()));
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'History',
              child: ListTile(
                leading: Icon(Icons.history, color: secondaryColor),
                title: Text('History',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600)),
                subtitle: Text('View your chat history',
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 12)),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'Speed',
              child: ListTile(
                leading: Icon(Icons.speed, color: secondaryColor),
                title: Text('Speed',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600)),
                subtitle: Text('Check typing speed',
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 12)),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'Lessons',
              child: ListTile(
                leading: Icon(Icons.school, color: secondaryColor),
                title: Text('Lessons',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600)),
                subtitle: Text('Learn new skills',
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 12)),
              ),
            ),
          ],
        ),
        elevation: 0,
        title: const Text(
          'Sign Language Translator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Add AI mode toggle
          IconButton(
            icon: Icon(
              _useAIMode ? Icons.auto_awesome : Icons.auto_awesome_outlined,
              color: Colors.white,
            ),
            tooltip: _useAIMode ? 'Using AI mode' : 'Using standard mode',
            onPressed: () {
              setState(() {
                _useAIMode = !_useAIMode;
              });
              _handleInteraction(
                  _useAIMode ? "AI mode activated" : "Standard mode activated");

              // Show a message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_useAIMode
                      ? "AI-powered sign language enabled"
                      : "Standard sign language enabled"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme(
                  !isDark); // Pass the opposite of current theme state
              _handleInteraction("Theme toggled");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _handleInteraction("3D model tapped"),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                        : [const Color(0xFFE8F5E9), const Color(0xFFF5F5F5)],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: _isModelLoading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: secondaryColor,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Loading 3D Model...',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : Flutter3DViewer(
                              controller: _modelController,
                              src: 'assets/model/3dmodelnew.glb',
                            ),
                    ),
                    if (!_isModelLoading)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade800.withOpacity(0.7)
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _useAIMode
                                    ? Icons.auto_awesome
                                    : Icons.info_outline,
                                size: 18,
                                color: secondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _useAIMode
                                    ? 'AI Mode Active'
                                    : 'Tap to interact',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Add AI processing indicator
                    if (_aiAnimationController.isProcessing && !_isModelLoading)
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'AI Processing',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // AI mode indicator
                if (_useAIMode)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: secondaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 18,
                            color: secondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Mode - Type any phrase for sign language',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Input area with shadow and rounded corners
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Type a word to translate...',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF3D3D3D)
                                : const Color(0xFFF8F8F8),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            prefixIcon: Icon(
                              Icons.translate,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          onChanged: (text) {
                            setState(() {
                              _recognizedText = text;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          _playAnimationForText(_textController.text);
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child:
                              const Icon(Icons.play_arrow, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _listen,
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening ? Icons.mic_off : Icons.mic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Navigation bar with modern design
                Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: Icons.account_circle_outlined,
                        label: 'Account',
                        onTap: () {
                          _handleInteraction("Account button pressed");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccountScreen()),
                          );
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onTap: () {
                          _handleInteraction("Camera button pressed");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CameraScreen(cameras: widget.cameras)),
                          );
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        onTap: () {
                          _handleInteraction("Settings button pressed");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Settings()),
                          );
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.person,
                        label: 'Profile',
                        onTap: () {
                          _handleInteraction("Profile button pressed");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MorseConverterScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedPage extends StatelessWidget {
  const SpeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typing Speed Test"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text("Speed Page Content")),
    );
  }
}
