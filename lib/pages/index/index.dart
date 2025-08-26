import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:layout/layout.dart';
import 'package:password_overload/common/utils/utils.dart';
import 'package:password_overload/global.dart';
import 'package:password_overload/pages/application/application.dart';
import 'package:password_overload/pages/welcome/welcome.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  @override
  void initState() {
    super.initState();
    // app update
    runAppUpdate();
  }

  Future runAppUpdate() async {
    await Future.delayed(Duration(seconds: 3), () async {
      // request permission
      AppUpdateHelper().run();
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
        xs: 0 – 599
        sm: 600 – 1023
        md: 1024 – 1439
        lg: 1440 – 1919
        xl: 1920 +
     */
    if(context.breakpoint == LayoutBreakpoint.xl) {
      ScreenUtil.init(context, designSize: const Size(1920, 1080));
    } else if(context.breakpoint == LayoutBreakpoint.lg) {
      ScreenUtil.init(context, designSize: const Size(1280, 800));
    } else if(context.breakpoint == LayoutBreakpoint.md) {
      ScreenUtil.init(context, designSize: const Size(1024, 768));
    } else if(context.breakpoint == LayoutBreakpoint.sm) {
      ScreenUtil.init(context, designSize: const Size(768, 1024));
    } else if(context.breakpoint == LayoutBreakpoint.xs) {
      ScreenUtil.init(context, designSize: const Size(375, 667));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Global.isFirstOpen == true ? WelcomePage() : ApplicationPage(),
    );
  }
}
