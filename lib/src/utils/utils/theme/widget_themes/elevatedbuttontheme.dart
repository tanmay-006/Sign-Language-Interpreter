import 'package:flutter/material.dart';
import 'package:sign_language_2/src/constants/color.dart';
import 'package:sign_language_2/src/constants/textsize.dart';

final lightElevatedButtonTheme =  ElevatedButton(
  style: ElevatedButton.styleFrom(
      elevation: 0 ,
      foregroundColor: tWhitecolor,
      backgroundColor: tSecondaryColor,
      side: const BorderSide(color: tSecondaryColor ),
      padding : const EdgeInsets.symmetric(vertical: tButtonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))

  ), onPressed: () {  }, child: null,
);
final darkElevatedButtonTheme =  ElevatedButton(
  style: ElevatedButton.styleFrom(
    elevation: 0 ,
    foregroundColor: tWhitecolor,
    backgroundColor: tSecondaryColor,
    side: const BorderSide(color: tWhitecolor ),
    padding : const EdgeInsets.symmetric(vertical: tButtonHeight),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))

  ), onPressed: () {  }, child: null,
);