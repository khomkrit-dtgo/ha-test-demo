import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  WebViewController webviewController = WebViewController();

  var url = '';
  var token = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadConfigure());
    super.initState();
  }

  void _loadConfigure() async {
    final prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url') ?? '';
    token = prefs.getString('token') ?? '';

    webviewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) =>
              (kDebugMode) ? debugPrint('$progress') : null,
        ),
      )
      ..addJavaScriptChannel('getExternalAuth', onMessageReceived: (
        JavaScriptMessage message,
      ) {
        webviewController.runJavaScript(
          "window.externalAuthSetToken(true, { access_token: '$token', expires_in: 1800 });",
        );
      })
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            onPressed: () => webviewController.reload(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          )
        ],
      ),
      body: Center(
        child: WebViewWidget(controller: webviewController),
      ),
    );
  }
}
