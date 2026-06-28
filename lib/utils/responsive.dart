import 'package:flutter/material.dart';

extension Responsive on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  // Horizontal sizing (based on screen width)
  double w(double percent) => width * percent;

  // Vertical sizing (based on screen height)
  double h(double percent) => height * percent;

  // Font size (scaled by width, but you can use height too)
  double fs(double percent) => width * percent;

  // Convenience for padding/margin
  EdgeInsets all(double p) => EdgeInsets.all(w(p));
  EdgeInsets symH(double p) => EdgeInsets.symmetric(horizontal: w(p));
  EdgeInsets symV(double p) => EdgeInsets.symmetric(vertical: h(p));
  EdgeInsets sym(double hP, double vP) =>
      EdgeInsets.symmetric(horizontal: w(hP), vertical: h(vP));
}