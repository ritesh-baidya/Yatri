import 'package:flutter_test/flutter_test.dart';
import 'package:yatri_dashboard/main.dart';

void main() {
  testWidgets('Dashboard renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the dashboard header or upcoming ride section is rendered.
    expect(find.text('Upcoming Ride'), findsOneWidget);
  });
}
