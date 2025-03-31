import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service that handles AI-powered sign language translation using Gemini API
class AISignLanguageService {
  static final AISignLanguageService _instance =
      AISignLanguageService._internal();

  factory AISignLanguageService() => _instance;

  // Gemini API configuration
  String _geminiApiKey =
      "AIzaSyCgdWQb-Cyz3tTe6PqIe1TEMx8UM0p8O08"; // Default API key
  final String _geminiApiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  // Flag to determine if we're using the mock implementation or Gemini
  // With the default API key, we'll use Gemini by default
  bool _useMock = false;

  bool get useMock => _useMock;
  bool get hasApiKey => _geminiApiKey.isNotEmpty;

  AISignLanguageService._internal() {
    // Load API key on initialization
    _loadApiKey();
  }

  // Load the API key from shared preferences
  Future<void> _loadApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('gemini_api_key') ??
          _geminiApiKey; // Use the default if not set

      _geminiApiKey = apiKey;
      _useMock = apiKey.isEmpty;

      debugPrint(
          'AI service initialized. Using ${_useMock ? "mock" : "Gemini API"}.');
    } catch (e) {
      debugPrint('Error loading API key: $e');
      _useMock = false; // Still use the default API key on error
    }
  }

  // Save the API key to shared preferences
  Future<void> saveApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gemini_api_key', apiKey);
      _geminiApiKey = apiKey;
      _useMock = apiKey.isEmpty;
    } catch (e) {
      debugPrint('Error saving API key: $e');
      throw Exception('Failed to save API key');
    }
  }

  // Test if an API key is valid by making a simple request
  Future<bool> testApiKey(String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse(_geminiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': 'Hello'}
              ]
            }
          ]
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error testing API key: $e');
      return false;
    }
  }

  // Translate text to sign language using Gemini API
  Future<Map<String, dynamic>> translateToSignLanguage(String text) async {
    if (_useMock) {
      // Return mock animation data for testing - updated to match the expected format
      return {
        'success': true,
        'animationSequence': [
          {'word': 'hello', 'duration': 1.0},
          {'word': 'world', 'duration': 1.0},
        ]
      };
    }

    try {
      final response = await http.post(
        Uri.parse(_geminiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_geminiApiKey',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Convert this text to a sequence of sign language gestures. Format your response as a JSON array with each item having "word" and "duration" (in seconds) properties. For advanced signs, add "handshape" and "movement" descriptions. Example: [{"word":"hello", "duration":1.0, "handshape":"open palm", "movement":"wave"}]. Text to convert: "$text"'
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to translate text: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      final content =
          jsonResponse['candidates'][0]['content']['parts'][0]['text'];

      // Parse the AI response into animation data
      final animationSequence = _parseAIResponse(content);

      return {'success': true, 'animationSequence': animationSequence};
    } catch (e) {
      debugPrint('Error translating to sign language: $e');
      // Return a generic response in case of error to avoid crashes
      return {
        'success': false,
        'error': e.toString(),
        'animationSequence': [
          {'word': 'error', 'duration': 1.0}
        ]
      };
    }
  }

  List<Map<String, dynamic>> _parseAIResponse(String aiResponse) {
    final animationSequence = <Map<String, dynamic>>[];

    try {
      // First try to parse as JSON
      if (aiResponse.contains('[') && aiResponse.contains(']')) {
        // Extract JSON array from the response
        final jsonStart = aiResponse.indexOf('[');
        final jsonEnd = aiResponse.lastIndexOf(']') + 1;
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          final jsonStr = aiResponse.substring(jsonStart, jsonEnd);
          try {
            final List<dynamic> parsed = jsonDecode(jsonStr);
            for (final item in parsed) {
              if (item is Map<String, dynamic> && item.containsKey('word')) {
                // Ensure duration is a double in seconds
                double duration = 1.0;
                if (item.containsKey('duration')) {
                  if (item['duration'] is int) {
                    // Convert from milliseconds to seconds if it seems like milliseconds
                    duration = (item['duration'] as int) > 100
                        ? (item['duration'] as int) / 1000
                        : (item['duration'] as int).toDouble();
                  } else if (item['duration'] is double) {
                    duration = item['duration'];
                  }
                }

                animationSequence.add({
                  'word': item['word'],
                  'duration': duration,
                  'handshape': item['handshape'] ?? 'neutral',
                  'movement': item['movement'] ?? 'none',
                });
              }
            }
          } catch (e) {
            debugPrint('Error parsing JSON from AI response: $e');
          }
        }
      }

      // If we couldn't parse JSON or got no results, fall back to text parsing
      if (animationSequence.isEmpty) {
        final lines = aiResponse.split('\n');
        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          // Try to extract word and duration
          final wordMatch =
              RegExp(r'word[:\s]+([^\s,:]+)', caseSensitive: false)
                  .firstMatch(line);
          final durationMatch =
              RegExp(r'duration[:\s]+(\d+(?:\.\d+)?)', caseSensitive: false)
                  .firstMatch(line);

          if (wordMatch != null) {
            final word = wordMatch.group(1)!;
            double duration = 1.0;
            if (durationMatch != null) {
              duration = double.tryParse(durationMatch.group(1)!) ?? 1.0;
            }

            animationSequence.add({
              'word': word,
              'duration': duration,
              'handshape': 'neutral',
              'movement': 'none',
            });
          }
        }
      }

      // If still no results, create at least one entry with the first word
      if (animationSequence.isEmpty) {
        final words = aiResponse.split(' ');
        if (words.isNotEmpty) {
          animationSequence.add({
            'word': words[0],
            'duration': 1.0,
            'handshape': 'neutral',
            'movement': 'none',
          });
        }
      }
    } catch (e) {
      debugPrint('Error in _parseAIResponse: $e');
    }

    // Always return something, even if parsing failed
    if (animationSequence.isEmpty) {
      animationSequence.add({
        'word': 'error',
        'duration': 1.0,
        'handshape': 'neutral',
        'movement': 'none',
      });
    }

    return animationSequence;
  }
}
