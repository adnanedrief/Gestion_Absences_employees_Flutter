import 'dart:ui';
import 'package:flutter/cupertino.dart';

class AppColours {
  const AppColours();

  static const Color colorStart = const Color.fromARGB(255, 215, 67, 67);
  static const Color colorEnd = const Color.fromARGB(255, 215, 67, 67);

  static const buttonGradient = const LinearGradient(
    colors: const [colorStart, colorEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
