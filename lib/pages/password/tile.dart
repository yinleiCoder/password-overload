import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/entity/entity.dart';
import 'package:password_overload/common/values/values.dart';
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

    return Layout(
      child: Dismissible(
        key: Key(widget.item.id.toString()),
        direction: DismissDirection.startToEnd,
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
          child: Icon(Icons.delete,),
        ),
        onDismissed: (direction) async {
          var deletedCount = await Global.databaseHelper.delete(widget.item.id!);
          if(deletedCount == 1) {
            widget.onRefresh();
            showSnackbar(
              content: Text('id: ${widget.item.id} 的数据已从数据库中删除'),
              context: context,
            );
          }
        },
        child: RepaintBoundary(
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 16.w, right: 4.w),
            onTap: () async {
              bool? canRefresh = await context.push<bool>('/application/passwords/details', extra: widget.item.id);
              if(canRefresh ?? false) {
                widget.onRefresh();
              }
            },
            leading: CustomCircleAvatar(
              maxRadius: AppResponsive.circleRadius.resolve(context).r,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppResponsive.circleRadiusWithPadding.resolve(context).w),
                child: Text(
                  widget.item.source,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
                  ),
                ),
              ),
            ),
            title: Wrap(
              children: [
                Text(
                  widget.item.account,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: AppResponsive.tileTitleSize.resolve(context).sp,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomClipboard(copyText: widget.item.account, iconSize: AppResponsive.iconSize.resolve(context).sp,),
              ],
            ),
            subtitle: Wrap(
              children: [
                Text(
                  isShowPassword ? widget.item.password : List.filled(widget.item.password.length, '*').join(''),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: AppResponsive.titleSubtitleSize.resolve(context).sp,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                CustomClipboard(copyText: widget.item.password, iconSize: AppResponsive.iconSize.resolve(context).sp,),
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
              iconSize: AppResponsive.iconSize.resolve(context).sp,
              selectedIcon: CountdownCircle(
                countdownDuration: Duration(
                  seconds: 5,
                ),
                circleRadius: AppResponsive.iconSize.resolve(context).sp,
                color: Theme.of(context).primaryColor,
                onComplete: () {
                  setState(() {
                    isShowPassword = false;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}