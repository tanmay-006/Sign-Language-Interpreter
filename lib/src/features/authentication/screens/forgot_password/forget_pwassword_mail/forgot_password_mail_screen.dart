import 'package:flutter/material.dart';

class ForgotPasswordMailScreen extends StatelessWidget {
  const ForgotPasswordMailScreen({
    super.key,
    this.imageColor,
    this.heightbetween,
    required this.image,
    required this.title,
    required this.subTitle,
    this.imageheight = 0.2,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final Color? imageColor;
  final double imageheight;
  final double? heightbetween;
  final String image, title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(image: AssetImage(image), color: imageColor, height: size.height * imageheight),
        SizedBox(height: heightbetween),
        Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),),
        SizedBox(height: heightbetween),
        Text(subTitle,textAlign: textAlign, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),),
      ],
    );
  }
}
