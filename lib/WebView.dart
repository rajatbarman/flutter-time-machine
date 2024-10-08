import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:time_machine/RocketLoading.dart';

class WaybackMachineWebview extends StatefulWidget {
  final String webAddress;
  final String? webViewTitle;
  const WaybackMachineWebview(
      {super.key, required this.webAddress, this.webViewTitle});
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WaybackMachineWebview> {
  late final WebViewController _controller;
  bool isLoading = true;
  final ValueNotifier<bool> loadingFinishedNotifier = ValueNotifier(false);

  void finishLoading() {
    loadingFinishedNotifier.value = true;

    _controller.runJavaScript('''
                var checkExist = setInterval(function() {
                  var element = document.querySelector('#wm-ipp-base');
                  if (element) {
                    element.style.display = 'none'; // Hide the element
                    clearInterval(checkExist); // Stop checking once the element is found
                  }
                }, 100); // Check every 100 milliseconds
              ''');
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress > 50 && isLoading) {
              // Hide the loader once the page has partially loaded
              setState(() {
                isLoading = false;
              });
              finishLoading();
            }
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            finishLoading();
          },
          onHttpError: (HttpResponseError error) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.webAddress));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.webViewTitle ?? ''),
          backgroundColor: Color(0xFF0A0513),
          titleTextStyle: TextStyle(color: Colors.white70, fontSize: 16),
          iconTheme: IconThemeData(
            color:
                Colors.white, // Set your desired color for the back button here
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            Align(
                alignment: Alignment.bottomCenter,
                child: RocketLoading(
                  loadingFinishedNotifier: loadingFinishedNotifier,
                )),
          ],
        ));
  }
}
