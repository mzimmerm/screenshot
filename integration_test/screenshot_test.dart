import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart' show IntegrationTestWidgetsFlutterBinding;

import 'package:screenshot/main.dart' as app;

/// Test taking a screenshot from a running Flutter app.
/// 
/// Part of a Github project https://github.com/mzimmerm/screenshot 
/// which duplicates an issue reported on Flutter.
/// 
/// # Issue description (tl;dr): 
///   Presence of a directory named `example` on project top level causes to fail the `flutter drive ..` integration test.
///   This is very specific to the directory name `example`. The contents of the directory does not matter - just 
///   the presence of it Directories with other names do not cause this issue.
///   Worse, this failure prevents library projects to contain a example app, which by convention should be in a directory 
///   named `example`.
/// 
/// I created a project on Github  https://github.com/mzimmerm/screenshot 
/// which can be used to duplicate the issue.
/// The project is a rudimentary Flutter example app created from command line,
/// with added files `test_driver/integration_test.dart` and `integration_test/screenshot_test.dart`.
/// 
/// # To duplicate the issue: 
/// Install the duplication project from Github as follows:
///    - On your local system, from the command line, run the following commands:
///    
/// ```shell
///   cd ~/tmp # create if not exist
///   git clone https://github.com/mzimmerm/screenshot.git
///   cd screenshot
///   # Note that the project top level does NOT contain a directory named `example`.
///   
///   # Clean and run the test (which creates a screenshot) from command line
///   flutter clean
///   flutter emulator --launch "Nexus_6_API_29_2" # Change the emulator name to one on your system 
///   sleep 25 # make sure the emulator starts fully
///   
///   # Run the added Flutter integration (drive) test which creates a screenshot of the app
///   flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart
///   # Expected: screenshot-1.png is created in the project top level
///   # Actual:   screenshot-1.png is created in the project top level
///   
///   # Remove the screenshot to ensure we continue from the same initial state
///   rm screenshot-1.png
///   # Exit the emulator to ensure we continue from the same initial state.
///   
///   # Now create an empty directory `example` which will cause the same test to fail
///   
///   mkdir example
///  
///   # Run the same test as above again
///   # Clean and run the test (which creates a screenshot) from command line
///   flutter clean
///   flutter emulator --launch "Nexus_6_API_29_2" # Change the emulator name to one on your system 
///   sleep 25
///   flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart
///   # Expected: screenshot-1.png is created in the project top level
///   # Actual:   Build exception: 
///   
///   #    ~/tmp/screenshot/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java:19: error: package dev.flutter.plugins.integration_test does not exist
///   #    flutterEngine.getPlugins().add(new dev.flutter.plugins.integration_test.IntegrationTestPlugin()); ^
///   #    1 error
///   #    FAILURE: Build failed with an exception. 
///  
///   # Note: renaming `example` to `example1` or any other name makes the test to work again.
/// ```
///
/// Supplemental information: The project https://github.com/mzimmerm/screenshot on Github 
/// was created as follows:
/// ```shell
///   cd ~/tmp
///   flutter create --template=app screenshot
///   # - Edited pubspec.yaml and added test, integration_test and flutter_test
///   # - Added directory and file `integration_test/screenshot_test.dart`
///   #   as described in https://github.com/flutter/flutter/tree/master/packages/integration_test#integration_test.
///   #   (alternative in https://dev.to/mjablecnik/take-screenshot-during-flutter-integration-tests-435k is almost the same 
///   #   and also does not work)
///   # - Added directory and file `test_driver/integration_test.dart`
///   #   as described in https://github.com/flutter/flutter/tree/master/packages/integration_test#integration_test.
///   #   (alternative in https://dev.to/mjablecnik/take-screenshot-during-flutter-integration-tests-435k is almost the same 
///   #   and also does not work)
///   # - Added directory named `example1` for now
///   # - Added project `screenshot` on Github
///   #     `https://github.com/mzimmerm/screenshot` 
///   # 
/// ```
/// 
/// Supplemental information: The result of the first successful test
///     Running "flutter pub get" in screenshot...                         819ms
///     Running Gradle task 'assembleDebug'...                             24.1s
///     ✓  Built build/app/outputs/flutter-apk/app-debug.apk.
///     Installing build/app/outputs/flutter-apk/app.apk...                618ms
///     D/EGL_emulation( 4947): eglMakeCurrent: 0xe2a38b00: ver 3 0 (tinfo 0xda90fc90)
///     VMServiceFlutterDriver: Connecting to Flutter application at http://127.0.0.1:34567/i7VCyPBOS58=/
///     VMServiceFlutterDriver: Isolate found with number: 4413108995828315
///     VMServiceFlutterDriver: Isolate is paused at start.
///     VMServiceFlutterDriver: Attempting to resume isolate
///     I/flutter ( 4947): 00:00 +0: screenshot
///     VMServiceFlutterDriver: Connected to Flutter application.
///     W/Gralloc3( 4947): allocator 3.x is not supported
///     D/EGL_emulation( 4947): eglMakeCurrent: 0xda91a120: ver 3 0 (tinfo 0xda90fc10)
///     D/EGL_emulation( 4947): eglMakeCurrent: 0xe2a38b00: ver 3 0 (tinfo 0xda90fc90)
///     D/EGL_emulation( 4947): eglMakeCurrent: 0xe2a38b00: ver 3 0 (tinfo 0xda90fc90)
///     D/EGL_emulation( 4947): eglCreateContext: 0xda91a7e0: maj 3 min 0 rcv 3
///     D/EGL_emulation( 4947): eglMakeCurrent: 0xda91a7e0: ver 3 0 (tinfo 0xda90fc90)
///     D/EGL_emulation( 4947): eglMakeCurrent: 0xe2a38b00: ver 3 0 (tinfo 0xda90fc90)
///     D/EGL_emulation( 4947): eglMakeCurrent: 0xe2a38b00: ver 3 0 (tinfo 0xda90fc90)
///     I/flutter ( 4947): 00:01 +1: (tearDownAll)
///     W/mple.screensho( 4947): Accessing hidden method
///     Lsun/misc/Unsafe;->compareAndSwapObject(Ljava/lang/Object;JLjava/lang/Object;Ljava/lang/Object;)Z
///     (greylist, linking, allowed)
///     I/flutter ( 4947): 00:01 +2: All tests passed!
///     All tests passed.
///     
/// Supplemental information: The result of the failed test when directory `example` exists:
///     Running "flutter pub get" in screenshot...                       1,864ms
///     ~/tmp/screenshot/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java:19: error: package dev.flutter.plugins.integration_test does not exist
///           flutterEngine.getPlugins().add(new dev.flutter.plugins.integration_test.IntegrationTestPlugin());
///                                                                                  ^
///     1 error
///     
///     FAILURE: Build failed with an exception.
///     
///     * What went wrong:
///     Execution failed for task ':app:compileDebugJavaWithJavac'.
///     > Compilation failed; see the compiler error output for details.
///     
///     * Try:
///     Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.
///     
///     * Get more help at https://help.gradle.org
///     
///     BUILD FAILED in 10s
///     Running Gradle task 'assembleDebug'...                             10.5s
///     Gradle task assembleDebug failed with exit code 1
///     mzimmermann@home-server:~/tmp/screenshot>

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
