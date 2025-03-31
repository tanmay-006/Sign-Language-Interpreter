import 'package:flutter/material.dart';


class FAQPageState extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {"question": "How can I learn ASL?", "answer": "You can start by using apps, books, and video tutorials, or joining an ASL class."},
    {"question": "Do I need any prior experience to learn ASL?", "answer": "No, ASL is accessible to everyone, even beginners."},
    {"question": "Can hearing people learn sign language?", "answer": "Absolutely! Learning ASL can help communication and inclusivity."},
    {"question": "What is American Sign Language (ASL)?", "answer": "ASL is a complete language using hand movements, facial expressions, and body language."},
    {"question": "Is sign language universal?", "answer": "No, different countries have their own sign languages, like BSL, LSF, and ASL."},
  ];

  Map<int, bool> expandedState = {}; // Tracks which FAQs are open
  String searchQuery = "";

  FAQPageState({super.key});

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
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "FAQs",
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
            // Title
            Center(
              child: Text(
                "We’re here to answer all your questions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search FAQs...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {

              },
            ),
            const SizedBox(height: 20),

            // FAQ List
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  String question = faqs[index]["question"]!;
                  String answer = faqs[index]["answer"]!;
                  bool isExpanded = expandedState[index] ?? false;

                  if (searchQuery.isNotEmpty && !question.toLowerCase().contains(searchQuery)) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isExpanded ? Colors.green.shade200 : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  question,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.green.shade900,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            answer,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),

            // "See More FAQs" Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  elevation: 4,
                ),
                onPressed: () {
                  // Navigate to a full FAQ page
                },
                child: const Text("See all FAQ's", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
