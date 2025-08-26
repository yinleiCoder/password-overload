 import 'package:flutter/material.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher {
    static Future<void> onOpenUrl({required String url, required BuildContext context, LaunchMode? mode}) async {
      Uri uri = Uri.parse(url);
      if(!await canLaunchUrl(uri)) {
        showSnackbar(context: context, content: Text('不支持访问: $url'));
        return;
      }
      if(!await launchUrl(uri, mode: mode ?? LaunchMode.platformDefault)) {
        showSnackbar(context: context, content: Text('不支持访问: $url'));
        return;
      }
    }

    static Future<void> onOpenPhoneCall({required String phoneNumber, required BuildContext context, LaunchMode? mode}) async {
      Uri uri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      if(!await canLaunchUrl(uri)) {
        showSnackbar(context: context, content: Text('不支持手机号: $phoneNumber'));
        return;
      }
      if(!await launchUrl(uri, mode: mode ?? LaunchMode.platformDefault)) {
        showSnackbar(context: context, content: Text('不支持手机号: $phoneNumber'));
        return;
      }
    }
 }