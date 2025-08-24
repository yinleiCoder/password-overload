import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:password_overload/common/entity/entity.dart';
import 'package:provider/provider.dart';
import 'package:password_overload/global.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:password_overload/pages/password/tile.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {

  late Future<List<PasswordItem>> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = Global.databaseHelper.queryItems();
  }

  void refreshDataFromDB() {
    setState(() {
      itemsFuture = Global.databaseHelper.queryItems();
    });
  }

  Widget buildCopyrightFooter() {
    TextStyle copyrightStyle = TextStyle(
      color: Colors.grey,
      fontSize: 10.sp,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Copyright', style: copyrightStyle,),
              Icon(Icons.copyright, size: 10.sp, color: Colors.grey,),
              Text('2025.', style: copyrightStyle,),
              Text('All rights reserved.', style: copyrightStyle,),
            ],
          ),
          Text('一款专为你减轻密码记忆负担的开源软件', style: copyrightStyle,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                CustomSearchBar(
                  onRefresh: refreshDataFromDB,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      return Future.delayed(const Duration(seconds: 2), refreshDataFromDB);
                    },
                    child: CustomFutureBuilder(
                      future: itemsFuture,
                      onSuccess: (AsyncSnapshot asyncSnapshot) {
                        List<PasswordItem> items = asyncSnapshot.data as List<PasswordItem>;
                        if(items.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('数据库中无数据', style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  color: Theme.of(context).primaryColor,
                                ),),
                                Text('请点击屏幕右下方的按钮新建数据', style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),),
                              ],
                            ),
                          );
                        } else {
                          return ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            addAutomaticKeepAlives: true,
                            itemCount: asyncSnapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return KeepAliveItem(item: items[index], onRefresh: refreshDataFromDB,);
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                buildCopyrightFooter(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? canRefresh = await context.push<bool>('/application/passwords/create');
          if(canRefresh ?? false) {
            refreshDataFromDB();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
