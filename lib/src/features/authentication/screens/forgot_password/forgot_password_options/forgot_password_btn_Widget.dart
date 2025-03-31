import 'package:flutter/material.dart';

class ForgetPasswordBtnWidget extends StatelessWidget {
  final IconData btnIcon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  const ForgetPasswordBtnWidget({
    super.key,
    required this.btnIcon,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white, // Set background color to white
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black), // Black border for contrast
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(btnIcon, size: 30, color: Colors.black), // Set icon color to black
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set text color to black
                  ),
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black, // Set subtitle text color to black
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
