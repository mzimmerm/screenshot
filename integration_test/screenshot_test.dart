import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart' show IntegrationTestWidgetsFlutterBinding;

import 'package:screenshot/main.dart' as app;

/// Test taking a screenshot from a running Flutter app.
///
/// Run the test (which creates screenshot) from command line 
///       #+BEGIN_SRC shell
///         cd dev/my-projects-source/public-on-github/screenshot
///         flutter emulator --launch "Nexus_6_API_29_2"
///         sleep 20
///         flutter clean 
///         flutter pub get
///         flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart
///         # Check if file screenshot-1.png exists on top level
///       #+END_SRC
///     
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;

  testWidgets('screenshot', (WidgetTester tester) async {
    // Build the app.
    app.main();

    // This is required prior to taking the screenshot (Android only).
    await binding.convertFlutterSurfaceToImage();
 
    // Trigger a frame.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-1');
  });
}
