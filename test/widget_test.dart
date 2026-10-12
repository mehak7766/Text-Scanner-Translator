import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_scanner/main.dart';
import 'package:text_scanner/screens/intro_screen.dart';
import 'package:text_scanner/screens/onboard_screen.dart';
import 'package:text_scanner/widgets/translation_bubble_illustration.dart';

void main() {
  testWidgets('Screen 1: SplashScreen displays branding and widgets correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TextScannerApp());

    // Verify app title & subtitle on SplashScreen
    expect(find.text('Text Scanner'), findsOneWidget);
    expect(
      find.text('OCR Scanner & Instant Translator'),
      findsOneWidget,
    );
  });

  testWidgets('Screen 2: IntroScreen displays walkthrough slides and navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: IntroScreen(),
      ),
    );

    // Verify first slide title & buttons
    expect(find.text('Scan & Extract Text'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next to advance slide
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify second slide title
    expect(find.text('Translate 100+ Languages'), findsOneWidget);
  });

  testWidgets(
      'Screen 3: OnboardScreen matches design with terms and continue button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardScreen(),
      ),
    );

    // Verify headline and subtitle
    expect(find.text('Language Translator'), findsOneWidget);
    expect(
      find.text('Translate your text in any language'),
      findsOneWidget,
    );

    // Verify Illustration presence
    expect(find.byType(TranslationBubbleIllustration), findsOneWidget);

    // Verify "Continue" button
    expect(find.text('Continue'), findsOneWidget);

    // Verify "I accept the Privacy policy" RichText
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('I accept the'),
      ),
      findsOneWidget,
    );

    // Tapping Continue without checking checkbox triggers snackbar reminder
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(
      find.text('Please accept the Privacy Policy to proceed.'),
      findsOneWidget,
    );
  });
}
