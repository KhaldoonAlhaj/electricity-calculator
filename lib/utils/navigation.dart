import 'package:flutter/material.dart';

// Reusable fade transition for any page
Route<T> fadeTransition<T>(Widget page, {Duration duration = const Duration(milliseconds: 400)}) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: duration,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}