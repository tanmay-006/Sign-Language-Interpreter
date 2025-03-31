import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReportIssuePage(),
  ));
}

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otherIssueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedIssue = "Video problem";
  final List<String> issueTypes = ["Video problem", "Sound problem", "Other"];
  bool isSubmitting = false;
  List<File> attachments = [];

  // Function to pick a photo or video
  Future<void> pickMedia(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickImage(source: source);

    if (media != null) {
      setState(() {
        attachments.add(File(media.path));
      });
    }
  }

  // Function to pick a video
  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        attachments.add(File(video.path));
      });
    }
  }

  // Function to send email using SendGrid API
  Future<void> sendEmail() async {
    final String? sendGridApiKey =
        const String.fromEnvironment('SENDGRID_API_KEY');
    if (sendGridApiKey == null || sendGridApiKey.isEmpty) {
      print("SendGrid API key not found in environment variables");
      return;
    }
    const String sendGridUrl = 'https://api.sendgrid.com/v3/mail/send';

    // Prepare the email body
    final emailBody = {
      "personalizations": [
        {
          "to": [
            {"email": "testermail2056@gmail.com"}
          ],
          "subject": "Issue Report: $selectedIssue"
        }
      ],
      "from": {"email": emailController.text},
      "content": [
        {
          "type": "text/plain",
          "value": "Email: ${emailController.text}\n"
              "Issue Type: $selectedIssue\n"
              "Description: ${descriptionController.text}"
        }
      ],
      "attachments": await _prepareAttachments(),
    };

    // Send the email
    final response = await http.post(
      Uri.parse(sendGridUrl),
      headers: {
        'Authorization': 'Bearer $sendGridApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(emailBody),
    );

    if (response.statusCode == 202) {
      print("Email sent successfully!");
    } else {
      print("Failed to send email: ${response.body}");
    }
  }

  // Function to prepare attachments for SendGrid
  Future<List<Map<String, dynamic>>> _prepareAttachments() async {
    List<Map<String, dynamic>> attachmentsList = [];
    for (var file in attachments) {
      final bytes = await file.readAsBytes();
      final base64File = base64Encode(bytes);
      attachmentsList.add({
        "content": base64File,
        "filename": basename(file.path),
        "type": "image/jpeg", // Adjust based on file type
        "disposition": "attachment"
      });
    }
    return attachmentsList;
  }

  // Simulate form submission
  void submitForm() {
    setState(() {
      isSubmitting = true;
    });

    // Simulate a delay for form submission
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isSubmitting = false;
      });

      // Clear form after submission
      emailController.clear();
      otherIssueController.clear();
      descriptionController.clear();
      setState(() {
        attachments.clear();
      });

      // Send email
      sendEmail();

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(
          content: Text("Issue reported successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Report an Issue",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Field
            const Text("E-mail",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter your email",
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor:
                    isDarkMode ? Colors.grey[900] : Colors.green.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Dropdown for Issue Type
            const Text("Issue Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedIssue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedIssue = newValue!;
                    });
                  },
                  items: issueTypes.map((issue) {
                    return DropdownMenuItem(
                      value: issue,
                      child: Text(issue),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Other Issue (Only if "Other" is selected)
            if (selectedIssue == "Other") ...[
              const Text("Other Issue",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              TextField(
                controller: otherIssueController,
                decoration: InputDecoration(
                  hintText: "Enter the issue...",
                  filled: true,
                  fillColor:
                      isDarkMode ? Colors.grey[900] : Colors.green.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],

            // Description
            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Describe the issue...",
                filled: true,
                fillColor:
                    isDarkMode ? Colors.grey[900] : Colors.green.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Attach Photo Button
            ElevatedButton.icon(
              onPressed: () => pickMedia(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text("Attach Photo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 10),

            // Attach Video Button
            ElevatedButton.icon(
              onPressed: pickVideo,
              icon: const Icon(Icons.video_library),
              label: const Text("Attach Video"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 10),

            // Display Selected Attachments
            if (attachments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: attachments.map((attachment) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "Attached: ${attachment.path.split('/').last}",
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  elevation: 4,
                ),
                onPressed: isSubmitting
                    ? null
                    : () {
                        submitForm();
                      },
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
