import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/src/google_fonts_base.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

main() {
  setUp(() async {
    httpClient = MockHttpClient();
    when(httpClient.get(any)).thenAnswer((_) async {
      return http.Response('fake response body - success', 200);
    });
  });

  tearDown(() {
    clearCache();
  });

  testWidgets('Text style with a direct match is used', (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    );

    final outputTextStyle = GoogleFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto400normal'));
  });

  testWidgets('Text style with an italics direct match is used',
      (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
    );

    final outputTextStyle = GoogleFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto400italic'));
  });

  testWidgets('Text style no direct match picks closest font weight match',
      (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
    );

    final outputTextStyle = GoogleFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto500normal'));
  });

  testWidgets('Italic text style no direct match picks closest match',
      (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );

    final outputTextStyle = GoogleFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto500italic'));
  });

  testWidgets('Text style prefers matching italics to closer weight',
      (tester) async {
    // Cardo has 400regular, 400italic, and 700 regular. Even though 700 is
    // closer in weight, when we ask for 600italic, it will give us 400 italic
    // font family.
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );

    final outputTextStyle = GoogleFonts.cardo(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Cardo400italic'));
  });

  testWidgets('Font weight and font style params are preferred',
      (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );

    final outputTextStyle = GoogleFonts.cardo(
      textStyle: inputTextStyle,
      fontWeight: FontWeight.w200,
      fontStyle: FontStyle.normal,
    );

    expect(outputTextStyle.fontWeight, equals(FontWeight.w200));
    expect(outputTextStyle.fontStyle, equals(FontStyle.normal));
  });
}
