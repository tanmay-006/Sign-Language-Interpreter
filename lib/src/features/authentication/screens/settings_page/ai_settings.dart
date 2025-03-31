// import 'package:flutter/material.dart';
// import 'package:sign_language_2/src/services/ai_sign_language_service.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AISettingsPage extends StatefulWidget {
//   const AISettingsPage({super.key});

//   @override
//   _AISettingsPageState createState() => _AISettingsPageState();
// }

// class _AISettingsPageState extends State<AISettingsPage> {
//   final TextEditingController _apiKeyController = TextEditingController();
//   final AISignLanguageService _aiService = AISignLanguageService();
//   bool _isLoading = false;
//   bool _isTesting = false;
//   bool _isObscured = true;
//   String _statusMessage = '';
//   bool _hasApiKey = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadApiKeyStatus();
//   }

//   @override
//   void dispose() {
//     _apiKeyController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadApiKeyStatus() async {
//     setState(() {
//       _isLoading = true;
//     });

//     // No need to actually load the API key text for security
//     // Just check if we have one stored
//     final hasKey = _aiService.hasApiKey;

//     setState(() {
//       _hasApiKey = hasKey;
//       _isLoading = false;
//       if (hasKey) {
//         _statusMessage =
//             'API key is configured. AI sign language generation is enabled and ready to use!';
//       } else {
//         _statusMessage =
//             'No API key configured. The app will use basic sign language generation.';
//       }
//     });
//   }

//   Future<void> _testAndSaveApiKey() async {
//     final apiKey = _apiKeyController.text.trim();

//     if (apiKey.isEmpty) {
//       setState(() {
//         _statusMessage = 'Please enter an API key.';
//       });
//       return;
//     }

//     setState(() {
//       _isTesting = true;
//       _statusMessage = 'Testing API key...';
//     });

//     try {
//       final isValid = await _aiService.testApiKey(apiKey);

//       if (isValid) {
//         await _aiService.saveApiKey(apiKey);
//         setState(() {
//           _hasApiKey = true;
//           _statusMessage =
//               'API key saved successfully! AI sign language generation is now enabled.';
//           _apiKeyController.clear(); // Clear for security
//         });
//       } else {
//         setState(() {
//           _statusMessage = 'Invalid API key. Please check and try again.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _statusMessage = 'Error testing API key: $e';
//       });
//     } finally {
//       setState(() {
//         _isTesting = false;
//       });
//     }
//   }

//   Future<void> _clearApiKey() async {
//     setState(() {
//       _isLoading = true;
//       _statusMessage = 'Removing API key...';
//     });

//     try {
//       await _aiService.saveApiKey('');

//       setState(() {
//         _hasApiKey = false;
//         _statusMessage =
//             'API key removed. The app will use basic sign language generation.';
//       });
//     } catch (e) {
//       setState(() {
//         _statusMessage = 'Error removing API key: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primaryColor = Theme.of(context).primaryColor;
//     final accentColor = Theme.of(context).colorScheme.secondary;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AI Settings'),
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Success banner when API key is set
//                   if (_hasApiKey)
//                     Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.only(bottom: 24),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.green.withOpacity(0.5),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.green.withOpacity(0.2),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.check_circle,
//                               color: Colors.green,
//                               size: 28,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'AI Features Ready!',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Your Gemini API key is configured. You can now use AI-powered sign language generation.',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color:
//                                         isDark ? Colors.white : Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                   // Info card
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     color: isDark
//                         ? const Color(0xFF2D2D2D)
//                         : const Color(0xFFF8F9FA),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.auto_awesome,
//                                 color: accentColor,
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 8),
//                               const Text(
//                                 'AI Sign Language Generation',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'This feature uses Google\'s Gemini AI to generate more accurate and natural sign language animations.',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'Status: ${_hasApiKey ? 'Enabled' : 'Disabled'}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: _hasApiKey
//                                   ? Colors.green
//                                   : Colors.grey.shade600,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'How to use AI sign language:',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           const Text(
//                             '1. Go to the main screen\n'
//                             '2. Toggle the AI button in the top right corner\n'
//                             '3. Type or speak any phrase\n'
//                             '4. The AI will generate appropriate sign language animations',
//                             style: TextStyle(fontSize: 15),
//                           ),
//                           const SizedBox(height: 16),
//                           OutlinedButton.icon(
//                             icon: const Icon(Icons.open_in_new),
//                             label: const Text('Learn More About Gemini AI'),
//                             onPressed: () async {
//                               const url = 'https://ai.google.dev/';
//                               if (await canLaunch(url)) {
//                                 await launch(url);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Could not open URL'),
//                                     duration: Duration(seconds: 3),
//                                   ),
//                                 );
//                               }
//                             },
//                             style: OutlinedButton.styleFrom(
//                               side: BorderSide(color: accentColor),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // API key input
//                   if (!_hasApiKey) ...[
//                     const Text(
//                       'Enter your Gemini API Key:',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: _apiKeyController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         hintText: 'Paste your API key here',
//                         prefixIcon: const Icon(Icons.key),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isObscured
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isObscured = !_isObscured;
//                             });
//                           },
//                         ),
//                       ),
//                       obscureText: _isObscured,
//                       enableSuggestions: false,
//                       autocorrect: false,
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         icon: _isTesting
//                             ? SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Icon(Icons.save),
//                         label: Text(_isTesting ? 'Testing...' : 'Save API Key'),
//                         onPressed: _isTesting ? null : _testAndSaveApiKey,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: accentColor,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ] else ...[
//                     // API key management when already set
//                     const Text(
//                       'API Key Management:',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ListTile(
//                       leading: Icon(
//                         Icons.check_circle,
//                         color: Colors.green,
//                       ),
//                       title: const Text(
//                         'API Key Configured',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: const Text(
//                         'Your API key is securely stored',
//                       ),
//                       tileColor: isDark
//                           ? Colors.grey.shade800.withOpacity(0.3)
//                           : Colors.grey.shade100,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.delete),
//                         label: const Text('Remove API Key'),
//                         onPressed: _isLoading ? null : _clearApiKey,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],

//                   // Status message
//                   if (_statusMessage.isNotEmpty) ...[
//                     const SizedBox(height: 24),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: _hasApiKey
//                             ? Colors.green.withOpacity(0.1)
//                             : Colors.blue.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: _hasApiKey
//                               ? Colors.green.withOpacity(0.5)
//                               : Colors.blue.withOpacity(0.5),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             _hasApiKey ? Icons.check_circle : Icons.info,
//                             color: _hasApiKey ? Colors.green : Colors.blue,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Text(
//                               _statusMessage,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: _hasApiKey
//                                     ? Colors.green.shade800
//                                     : Colors.blue.shade800,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//     );
//   }

//   Future<bool> canLaunch(String url) async {
//     return await canLaunchUrl(Uri.parse(url));
//   }

//   Future<void> launch(String url) async {
//     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//   }
// }
