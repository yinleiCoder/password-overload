import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/utils/update.dart';
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Global.isFirstOpen == true ? WelcomePage() : ApplicationPage(),
    );
  }

  Future runAppUpdate() async {
    await Future.delayed(Duration(seconds: 3), () async {
      // request permission
      AppUpdateHelper().run();
    });
  }
}
