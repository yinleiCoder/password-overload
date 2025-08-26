import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:layout/layout.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/global.dart';
import 'package:password_overload/router.dart';

Future<void> main() async {
  // await myErrorsHandler.initialize();
  // await SentryFlutter.init( (options) => options.dsn = 'https://example@sentry.io/example', appRunner: () => runApp(const MyApp()), );
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // myErrorsHandler.onErrorDetails(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // myErrorsHandler.onError(error, stack);
    // await Sentry.captureException(exception, stackTrace: stackTrace);
    return true;
  };
  await Global.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConfig>(create: (context) => AppConfig(), lazy: false,),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          title: '密码过载',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          ),
          builder: (ctx, child) {
            ScreenUtil.init(ctx);
            return child!;
          },
      ),
    );
  }
}
