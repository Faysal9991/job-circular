import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPage extends StatelessWidget {
  final String url;
  const WebPage({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Job Circuler BD"),
        ),
        body: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(url)),
            ),
            onLoadStart: (controller, url) {},
            onUpdateVisitedHistory: (controllerWeb, url, isReload) async {
              if (url != null) {
                final uri = Uri.parse(url.toString());
                final status = uri.queryParameters['status'];
                final message = uri.queryParameters['message'];
              }
              print("---------------------${controllerWeb.platform}");
            }));
  }
}
