import 'package:flutter/widgets.dart';

const List<String> _faD = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

String faDigits(Object value) {
  final String s = value.toString();
  final StringBuffer b = StringBuffer();
  for (final String ch in s.split('')) {
    final int? d = int.tryParse(ch);
    if (d != null) {
      b.write(_faD[d]);
    } else {
      b.write(ch);
    }
  }
  return b.toString();
}

bool hasArabicScript(String s) => RegExp(r'[\u0600-\u06FF]').hasMatch(s);

TextDirection dirFor(String s) => hasArabicScript(s) ? TextDirection.rtl : TextDirection.ltr;
