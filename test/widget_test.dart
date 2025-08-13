import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/controllers/weather_controller.dart';

void main() {
  testWidgets('WeatherApp renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => WeatherController(),
        child: const WeatherApp(),
      ),
    );

    expect(find.byType(WeatherApp), findsOneWidget);
    expect(find.byType(WeatherScreen), findsOneWidget);
  });
}
