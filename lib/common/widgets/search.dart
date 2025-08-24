import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_overload/global.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/entity/entity.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/widgets/widgets.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  List<PasswordItem>? items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
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
              CustomCircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  context.watch<AppConfig>().userFirstName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                child: Text(item?.source ?? '', style: TextStyle(fontSize: 10.sp),),
              ),
              title: Text(item?.account ?? '',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
              ),
              subtitle: Text(item?.note ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
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
    );
  }
}
