import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final String initialUrl = 'https://gls-group.com/GROUP/en/parcel-tracking';
  late WebViewController _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    _hideHeaderAndFooter();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back, color: Colors.black,)),

      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onPageStarted: (String url) {
               _hideHeaderAndFooter();
              setState(() {
                isLoading = false;
              });
            },
            onPageFinished: (String url) {
               _hideHeaderAndFooter();
              setState(() {
                isLoading = false;
              });
            },
            navigationDelegate: (NavigationRequest request) {
              if (_isInternalUrl(request.url)) {
                return NavigationDecision.navigate;
              } else {
                return NavigationDecision.prevent;
              }
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  bool _isInternalUrl(String url) {
    return url.startsWith('https://gls-group.com');
  }

  void _hideHeaderAndFooter() async {
    await _webViewController.evaluateJavascript(
      """
    var header = document.querySelector('header');
    var footer = document.querySelector('footer');
    if (header) {
      header.style.display = 'none';
    }
    /
    if (footer) {
       footer.style.display = 'none';
     }
    """,
    );
    //
    // Change text color of h1 with class 'headline' to green
    // await _webViewController.evaluateJavascript(
    //   """
    // var headline = document.querySelector('.headline');
    // if (headline) {
    //   headline.style.color = '#039D55';
    // }
    // """,
    // );

    await _webViewController.evaluateJavascript(
      """
    var customHeader = document.createElement('div');
    // customHeader.innerHTML = '<h1>Custom Header</h1>';
    // customHeader.style.backgroundColor = 'blue';  // Change background color as needed
    customHeader.querySelector('h1').style.color = 'white';  // Change text color as needed
    customHeader.style.textAlign = 'center';  // Center text horizontally
    customHeader.style.lineHeight = '100vh';  // Center text vertically
    document.body.insertBefore(customHeader, document.body.firstChild);
    """,
    );
  }
}
