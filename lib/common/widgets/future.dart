import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFutureBuilder extends StatefulWidget {
  const CustomFutureBuilder({super.key, required this.future, required this.onSuccess});

  final Future<Object?> future;
  final Widget Function(AsyncSnapshot asyncSnapshot) onSuccess;

  @override
  State<CustomFutureBuilder> createState() => _CustomFutureBuilderState();
}

class _CustomFutureBuilderState extends State<CustomFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future,
        builder: (context, asyncSnapshot) => switch (asyncSnapshot.connectionState) {
          ConnectionState.waiting => Center(child: CircularProgressIndicator()),
          ConnectionState.done => asyncSnapshot.hasData ?
          widget.onSuccess(asyncSnapshot) :
          Center(
              child: Row(
                children: [
                  Icon(Icons.face),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text('数据库中无相关数据'),
                ],
              )
          ),
          _ => Center(child: Text('')),
        }
    );
  }
}
