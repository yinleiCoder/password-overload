import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:layout/layout.dart';
import 'package:password_overload/common/values/values.dart';
import 'package:password_overload/common/widgets/countdown.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '密码过载',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: AppResponsive.primaryFontSize.resolve(context).sp,
                        ),
                      ),
                      Text(
                        '一款专为你减轻密码记忆负担的跨平台开源软件.',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: CountdownCircle(
                    onComplete: () {
                      context.go('/application');
                    },
                    countdownDuration: Duration(
                      seconds: 5,
                    ),
                    circleRadius: AppResponsive.circleRadius.resolve(context).w,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
