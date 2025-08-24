import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/global.dart';
import 'package:password_overload/router.dart';

void main() => Global.init().then((e) => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConfig>(create: (context) => AppConfig(), lazy: false,),
      ],
      child: const MyApp(),
    ),
));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        title: 'Password Overload',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        builder: (ctx, child) {
          ScreenUtil.init(ctx);
          return child!;
        },
    );
  }
}
