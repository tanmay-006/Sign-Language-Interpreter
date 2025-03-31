import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import '../settings_page/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CameraScreen(cameras: cameras),
  ));
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  int _selectedCameraIndex = 0;
  FlutterTts flutterTts = FlutterTts();
  String textFieldValue = "";
  Timer? _frameTimer;
  bool _isProcessing = false;
  bool _isFlashOn = false;
  final String _serverUrl =
      'http://172.16.254.247:5000/process_frame'; // Update this URL

  // Updated color palette
  final Color primaryColor = const Color(0xFF52796F);
  final Color secondaryColor = const Color(0xFF84A98C);
  final Color lightColor = const Color(0xFFCAD2C5);
  final Color textDarkColor = const Color(0xFF2C3639);

  @override
  void initState() {
    super.initState();
    _initializeCamera(_selectedCameraIndex);
  }

  void _initializeCamera(int cameraIndex) {
    _cameraController = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameraController.initialize().then((_) {
      _frameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        _captureAndProcessFrame();
      });
    });
  }

  Future<void> _captureAndProcessFrame() async {
    if (!_cameraController.value.isInitialized || _isProcessing) return;

    _isProcessing = true;
    try {
      final XFile imageFile = await _cameraController.takePicture();
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(_serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'frame': base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String recognizedLetter = data['letter'] ?? '';
        if (recognizedLetter.isNotEmpty) {
          setState(() {
            textFieldValue += recognizedLetter; // Append the recognized letter
          });
        }
      }
    } catch (e) {
      print('Error processing frame: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void _switchCamera() {
    _frameTimer?.cancel();
    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    _initializeCamera(_selectedCameraIndex);
  }

  void _toggleFlash() async {
    if (!_cameraController.value.isInitialized) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    await _cameraController.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  void _speakText() async {
    if (textFieldValue.isNotEmpty) {
      await flutterTts.speak(textFieldValue);
    }
  }

  void _clearText() {
    setState(() {
      textFieldValue = ""; // Clear the text
    });
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: Column(
        children: [
          // Top App Bar with Back Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: primaryColor, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  Text(
                    "Sign Language Camera",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
          ),
          // Camera Preview
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 3),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CameraPreview(_cameraController),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Initializing camera...",
                          style: TextStyle(
                            color: textDarkColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          // Text Display and Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                          color: secondaryColor.withOpacity(0.5), width: 1),
                    ),
                    child: Text(
                      textFieldValue.isNotEmpty
                          ? textFieldValue
                          : "Waiting for sign...",
                      style: TextStyle(
                        fontSize: 16,
                        color: textDarkColor,
                        fontWeight: textFieldValue.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.volume_up, color: primaryColor, size: 30),
                  onPressed: _speakText,
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.red.shade400, size: 25),
                  onPressed: _clearText,
                ),
              ],
            ),
          ),
          // Bottom Bar with Flash, Camera Switch, and Settings
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Flash Button
                IconButton(
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFlash,
                ),
                // Camera Switch Button
                IconButton(
                  icon: const Icon(Icons.switch_camera,
                      size: 35, color: Colors.white),
                  onPressed: _switchCamera,
                ),
                // Settings Button
                IconButton(
                  icon:
                      const Icon(Icons.settings, size: 35, color: Colors.white),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
