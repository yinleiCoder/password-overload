import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layout/layout.dart';
import 'package:password_overload/common/values/values.dart';
import 'package:password_overload/global.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/entity/entity.dart';
import 'package:password_overload/common/widgets/widgets.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> with TickerProviderStateMixin {

  List<PasswordItem>? items;
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(duration: Duration(seconds: 3) ,vsync: this)..repeat(reverse: true);
    rotationAnimation = CurvedAnimation(parent: rotationController, curve: Curves.elasticOut);
    rotationController.stop();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double paddingVertical = context.layout.value(xs: 4.h, md: 10.h);
    final canRefreshData = LayoutValue(xs: false, md: true);
    return Layout(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: paddingVertical),
        child: SearchAnchor(
            viewHintText: '来源简称/账号/备注',
            viewOnChanged: (String searchText) async {
              List<PasswordItem> searchRes = await Global.databaseHelper.queryItemsByAccountOrSourceOrNote(searchText);
              setState(() {
                items = searchRes;
              });
            },
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                autoFocus: false,
                elevation: const WidgetStatePropertyAll<double>(0),
                backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5)),
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                ),
                hintText: '搜索',
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
                trailing: [
                  if(canRefreshData.resolve(context))RotationTransition(
                    turns: rotationAnimation,
                    child: IconButton(
                      onPressed: () async {
                        rotationController.forward();
                        await Future<void>.delayed(Duration(seconds: 3,), (){
                          rotationController.reset();
                          widget.onRefresh();
                        });
                      },
                      icon: Icon(Icons.refresh),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                      ),
                      tooltip: '刷新数据',
                    ),
                  ),
                ],
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) async {
              return List<ListTile>.generate(items?.length??0, (int index) {
                final PasswordItem? item = items?[index];
                return ListTile(
                  trailing: CustomCircleAvatar(
                    maxRadius: AppResponsive.circleRadius.resolve(context).w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppResponsive.circleRadiusWithPadding.resolve(context).w),
                      child: Text(
                        item?.source ?? '',
                        style: TextStyle(fontSize: AppResponsive.secondryFontSize.resolve(context).sp, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  title: Text(
                    item?.account ?? '',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: AppResponsive.primaryFontSize.resolve(context).sp,
                    ),
                  ),
                  subtitle: Text(item?.note ?? '',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
                    ),
                  ),
                  onTap: () async {
                    controller.closeView(item?.account);
                    bool? canRefresh = await context.push<bool>('/application/passwords/details', extra: item?.id);
                    if(canRefresh ?? false) {
                      widget.onRefresh();
                    }
                  },
                );
              });
            }
        ),
      ),
    );
  }
}
