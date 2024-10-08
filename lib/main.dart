import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:time_machine/WebAddressInput.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './YearSelect.dart';
import './PlayerOnRocket.dart';
import './WebView.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => TimeMachineApp(),
      '/webview': (context) => WaybackMachineWebview(
            webAddress: '',
          ),
    },
  ));
}

class TimeMachineApp extends StatefulWidget {
  @override
  _TimeMachineAppState createState() => _TimeMachineAppState();
}

class _TimeMachineAppState extends State<TimeMachineApp> {
  final ValueNotifier<bool> startAnimationNotifier = ValueNotifier(false);
  String webAddress = ''; // Tracks the validity of the TextField
  String? inputError; // Error message
  int selectedYear = 1998;

  void handleYearChange(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }

  void updateWebAddress(String newWebAddress) {
    setState(() {
      if (isValidWebAddress(newWebAddress)) {
        inputError = null;
      }
      webAddress = newWebAddress;
    });
  }

  String extractWebsiteName(String url) {
    // Ensure the URL has a scheme (like 'http') to be properly parsed
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url'; // Add a default scheme to ensure parsing works
    }

    Uri uri = Uri.parse(url);
    String host = uri.host; // Extracts the full host like "www.example.com"

    // Remove "www." prefix if present
    if (host.startsWith('www.')) {
      host = host.substring(4);
    }

    return host;
  }

  void handleAnimationEnd() {
    final String finalWebAddress =
        'https://web.archive.org/web/${selectedYear}0101000000/$webAddress';

    final String webViewTitle =
        '${extractWebsiteName(webAddress)} in $selectedYear';

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            WaybackMachineWebview(
          webAddress: finalWebAddress,
          webViewTitle: webViewTitle,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ));
        },
      ),
    );
  }

  bool isValidWebAddress(String webAddress) {
    if (webAddress.isEmpty) {
      return false;
    }
    final urlPattern = r'\.[a-zA-Z]{2,}$';
    final result =
        RegExp(urlPattern, caseSensitive: false).hasMatch(webAddress);
    if (!result) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Color(0xFF0A0513),
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 96),
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          semanticsLabel: 'Time Machine',
                        ))),
                Align(
                    // Year Selector
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 142),
                        child: YearDropdown(
                          selectedYear: selectedYear,
                          onYearChange: handleYearChange,
                        ))),
                Align(
                    // Web Address Input
                    alignment: Alignment.topCenter,
                    child: WebAddressInput(
                        onValueChange: updateWebAddress,
                        inputError: inputError)),
                Align(
                  // Animation
                  alignment: Alignment.center,
                  child: Material(
                      color: Colors.transparent,
                      child: Container(
                          margin: const EdgeInsets.only(top: 40.0),
                          child: GestureDetector(
                              onTap: () {
                                if (webAddress.isEmpty) {
                                  setState(() {
                                    inputError = 'Enter an address';
                                  });
                                  return;
                                }
                                if (!isValidWebAddress(webAddress)) {
                                  setState(() {
                                    inputError = 'Enter a valid address';
                                  });
                                  return;
                                }
                                startAnimationNotifier.value = true;
                              },
                              child: Container(
                                  width: 380,
                                  height: 240,
                                  child: rive.RiveAnimation.asset(
                                      'assets/animations/first.riv',
                                      fit: BoxFit.contain
                                      // artboard: 'Truck', // Optional: Specify the artboard to use
                                      ))))),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: PlayerOnRocket(
                          startAnimationNotifier: startAnimationNotifier,
                          onAnimationEnd: handleAnimationEnd,
                        )))
              ],
            )));
  }
}
