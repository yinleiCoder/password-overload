import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPasswordStrengthEstimator extends StatelessWidget {
  const CustomPasswordStrengthEstimator({super.key, required this.passwordStrength});

  final double passwordStrength;

  Color dynamicPasswordColor(double strength) => switch(strength){
    >= 0.7 => Colors.green,
    >= 0.4 => Colors.yellow,
    _ => Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('密码安全强度', style: TextStyle(fontSize: 10.sp),),
        SizedBox(
          width: 4.w,
        ),
        Expanded(
          child: LinearProgressIndicator(
            color: dynamicPasswordColor(passwordStrength),
            borderRadius: BorderRadius.circular(5.r),
            value: passwordStrength,
          ),
        ),
      ],
    );
  }
}
