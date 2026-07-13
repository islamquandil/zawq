import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Thin wrappers over platform launch intents with graceful failure.
abstract final class Launchers {
  static Future<void> url(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> dial(String phone) => url('tel:$phone');

  static Future<void> email(String address, {String subject = ''}) =>
      url(Uri(scheme: 'mailto', path: address, query: 'subject=$subject')
          .toString());

  static Future<void> maps(String query) => url(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');

  static Future<void> shareText(String text) => Share.share(text);
}

/// Floating Material 3 snackbar shorthand.
void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
