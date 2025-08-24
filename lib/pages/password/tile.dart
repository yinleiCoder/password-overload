import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/entity/entity.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:password_overload/global.dart';

class KeepAliveItem extends StatefulWidget {
  const KeepAliveItem({super.key, required this.item, required this.onRefresh});

  final PasswordItem item;
  final VoidCallback onRefresh;

  @override
  State<KeepAliveItem> createState() => _KeepAliveItemState();
}

class _KeepAliveItemState extends State<KeepAliveItem> with AutomaticKeepAliveClientMixin<KeepAliveItem> {

  bool isShowPassword = false;

  @override
  void didUpdateWidget(covariant KeepAliveItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Dismissible(
      key: Key(widget.item.id.toString()),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
            ],
            stops: [0.4, 1.0],
          ),
        ),
          child: Icon(Icons.delete, color: Colors.white,)
      ),
      onDismissed: (direction) async {
        if(direction == DismissDirection.startToEnd ||
            direction == DismissDirection.endToStart) {
            var deletedCount = await Global.databaseHelper.delete(widget.item.id!);
            if(deletedCount == 1) {
              widget.onRefresh();
              showSnackbar(
                content: Text('id: ${widget.item.id} 的数据已从数据库中删除.'),
                context: context,
              );
            }
        }
      },
      child: ListTile(
        dense: true,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0,),
        leading: CustomCircleAvatar(
          maxRadius: 24.r,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              widget.item.source,
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
              ),),
          ),),
        title: Wrap(
          children: [
            Baseline(
              baseline: 30,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                widget.item.account,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.copy),
              iconSize: 16.sp,
            ),
          ],
        ),
        subtitle: Wrap(
          children: [
            Baseline(
              baseline: 30,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                isShowPassword ? widget.item.password : List.filled(widget.item.password.length, '*').join(''),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.copy),
              iconSize: 16.sp,
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: (){
            setState(() {
              isShowPassword = true;
            });
          },
          isSelected: isShowPassword,
          icon: Icon(Icons.remove_red_eye),
          iconSize: 24.sp,
          selectedIcon: CountdownCircle(
            countdownDuration: Duration(
              seconds: 5,
            ),
            circleRadius: 24,
            color: Theme.of(context).primaryColor,
            onComplete: () {
              setState(() {
                isShowPassword = false;
              });
            },
          ),
        ),
        onTap: () async {
          bool? canRefresh = await context.push<bool>('/application/passwords/details', extra: widget.item.id);
          if(canRefresh ?? false) {
            widget.onRefresh();
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}