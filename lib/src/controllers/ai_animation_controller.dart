import 'package:flutter/foundation.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import '../services/ai_sign_language_service.dart';

class AIAnimationController {
  final Flutter3DController modelController;
  final AISignLanguageService _aiService = AISignLanguageService();

  // States
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  // Currently playing animation data
  Map<String, dynamic>? _currentAnimationData;

  AIAnimationController({required this.modelController});

  /// Generate and play sign language animation for the given text
  ///
  /// Returns true if the process started successfully, false otherwise
  Future<bool> generateAndPlayAnimation(String text) async {
    if (_isProcessing) {
      debugPrint('Already processing an animation request');
      return false;
    }

    try {
      _isProcessing = true;

      // First play an "idle" or "thinking" animation if available
      _playTransitionAnimation('Idle');

      // Get animation data from AI service
      final animationData = await _aiService.translateToSignLanguage(text);
      _currentAnimationData = animationData;

      // Process the animation data and control the 3D model
      await _playAnimationSequence(animationData);

      // Return to idle state
      _playTransitionAnimation('Idle');

      _isProcessing = false;
      return true;
    } catch (e) {
      debugPrint('Error generating animation: $e');
      _isProcessing = false;
      return false;
    }
  }

  /// Play a transition animation (idle, thinking, etc.)
  void _playTransitionAnimation(String animationName) {
    try {
      modelController.playAnimation(animationName: animationName);
    } catch (e) {
      debugPrint('Error playing transition animation: $e');
    }
  }

  /// Process and play a sequence of animation steps
  Future<void> _playAnimationSequence(
      Map<String, dynamic> animationData) async {
    try {
      final sequence = animationData['animationSequence'] as List<dynamic>;

      for (final step in sequence) {
        await _playAnimationStep(step as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error in animation sequence: $e');
      // If there's an error in the sequence, return to idle
      _playTransitionAnimation('Idle');
    }
  }

  /// Play a single animation step
  Future<void> _playAnimationStep(Map<String, dynamic> step) async {
    try {
      final word = step['word'] as String;

      // First try to play a predefined animation for common words
      bool usedPredefined = _tryPlayPredefinedAnimation(word);

      // If no predefined animation was found, try to interpret AI instructions
      if (!usedPredefined) {
        usedPredefined = _tryInterpretAIInstructions(step);
      }

      // If all else fails, play a generic animation for this word
      if (!usedPredefined) {
        _playGenericAnimationForWord(word);
      }

      // Wait for the step duration
      final duration = step['duration'] as double? ?? 1.0;
      await Future.delayed(Duration(milliseconds: (duration * 1000).round()));
    } catch (e) {
      debugPrint('Error playing animation step: $e');
      // If there's an error, continue to the next step
    }
  }

  /// Try to interpret AI-generated instructions and map them to model animations
  bool _tryInterpretAIInstructions(Map<String, dynamic> step) {
    try {
      final word = step['word'] as String;
      final handshape = step['handshape'] as String? ?? 'neutral';
      final movement = step['movement'] as String? ?? 'none';

      // Analyze the handshape description to determine which animation might be appropriate
      String? animationToPlay = _mapHandshapeToAnimation(handshape, word);

      if (animationToPlay != null) {
        try {
          modelController.playAnimation(animationName: animationToPlay);
          return true;
        } catch (e) {
          debugPrint('Error playing mapped animation: $e');
          return false;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Error interpreting AI instructions: $e');
      return false;
    }
  }

  /// Map AI-described handshapes to available animations in the model
  String? _mapHandshapeToAnimation(String handshape, String word) {
    // Map common handshape descriptions to animation names

    // First check if the handshape directly maps to a letter
    if (handshape.contains('fist')) {
      return 'A';
    } else if (handshape.contains('flat')) {
      return 'B';
    } else if (handshape.contains('curved') || handshape.contains('circle')) {
      return 'C';
    } else if (handshape.contains('index finger pointing up')) {
      return 'D';
    } else if (handshape.contains('thumb and index')) {
      return 'L';
    } else if (handshape.contains('index and middle finger in V')) {
      return 'V';
    } else if (handshape.contains('index, middle, and ring')) {
      return 'W';
    } else if (handshape.contains('thumb and pinky')) {
      return 'Y';
    } else if (handshape.contains('pinky')) {
      return 'I';
    } else if (handshape.contains('index finger')) {
      return 'D';
    }

    // Then check for common words/concepts
    if (word.contains('hello')) {
      return 'Hello';
    } else if (word.contains('love')) {
      return 'Love';
    } else if (word.contains('thank') || word.contains('thanks')) {
      return 'Thankyou';
    } else if (word.contains('fine')) {
      return 'Fine';
    } else if (word.contains('good')) {
      return 'Good';
    } else if (word.contains('please')) {
      return 'Please';
    }

    return null;
  }

  /// Play a generic animation for a word when no specific mapping is available
  void _playGenericAnimationForWord(String word) {
    // Choose a generic animation based on the first letter of the word
    if (word.isNotEmpty) {
      final firstLetter = word[0].toUpperCase();
      // Check if we have an animation for this letter
      try {
        if (['A', 'B', 'D', 'F', 'I', 'L', 'V', 'W', 'Y']
            .contains(firstLetter)) {
          modelController.playAnimation(animationName: firstLetter);
          return;
        }
      } catch (e) {
        debugPrint('Error playing letter animation: $e');
      }
    }

    // Fallback to idle animation
    try {
      modelController.playAnimation(animationName: 'Idle');
    } catch (e) {
      debugPrint('Error playing idle animation: $e');
    }
  }

  /// Try to play a predefined animation for common words
  bool _tryPlayPredefinedAnimation(String word) {
    // Convert to lowercase for easier matching
    final lowerWord = word.toLowerCase();

    // Check if we have a predefined animation for this word
    String? animationName = _getPredefinedAnimationName(lowerWord);

    if (animationName != null) {
      try {
        modelController.playAnimation(animationName: animationName);
        return true;
      } catch (e) {
        debugPrint('Error playing predefined animation: $e');
        return false;
      }
    }

    return false;
  }

  /// Get the name of a predefined animation for common words
  String? _getPredefinedAnimationName(String word) {
    switch (word) {
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
      case 'thank':
      case 'thanks':
        return 'Thankyou';
      case 'fine':
        return 'Fine';
      case 'please':
        return 'Please';
      case 'good':
        return 'Good';
      case 'great':
        return 'Great';
      case 'whatsup':
        return 'Whatsup';
      case 'howareyou':
        return 'Howareyou';
      default:
        return null; // No predefined animation
    }
  }

  /// Stop any current animation and reset to idle
  void stopAnimation() {
    _isProcessing = false;
    _currentAnimationData = null;
    _playTransitionAnimation('Idle');
  }
}
