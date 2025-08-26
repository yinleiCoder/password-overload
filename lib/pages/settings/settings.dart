import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';
import 'package:password_overload/common/extensions/extensions.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/utils/utils.dart';
import 'package:password_overload/common/values/values.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {

  bool softwareAutoFill = false;

  late TextEditingController userTextEditingController;
  late TabController tabController;

  List<String> bannerUrls = [
    "https://img.zcool.cn/community/01uopernjlprmnotyvst7k3030.jpg?imageMogr2/format/webp",
    // "https://img.zcool.cn/community/01nqd2rysuenwtyrnmmxa13132.jpg?imageMogr2/format/webp",
    // "https://img.zcool.cn/community/01thr1maqohbwqb0g2pukc3739.jpg?imageMogr2/format/webp",
    // "https://img.zcool.cn/community/01kyjkiiuok8bldssrmt3j3932.jpg?imageMogr2/format/webp",
  ];

  @override
  void initState() {
    super.initState();
    userTextEditingController = TextEditingController();
    userTextEditingController.text = context.read<AppConfig>().userName ?? '';
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    userTextEditingController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Widget buildAppBar() {
    double bannerHeight = context.layout.value(xs: 120, md: 300);
    return SliverAppBar(
      floating: true,
      expandedHeight: bannerHeight.h,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: bannerUrls.getRandomElement(),
          imageBuilder: (context, imageProvider) => Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      // colorFilter: ColorFilter.mode(Colors.black, BlendMode.colorBurn),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.6, 1.0]
                    ),
                  ),
                ),
              ),
            ],
          ),
          // progressIndicatorBuilder: (context, url, downloadProgress) =>
          //   CircularProgressIndicator(value: downloadProgress.progress, constraints: BoxConstraints(
          //     maxWidth: 50.w,
          //     maxHeight: 50.w,
          //   ),),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget buildAppBuildBar() {
    double footerHeight = context.layout.value(xs: 100, md: 150, lg: 150);
    return SliverToBoxAdapter(
      child: Center(
        child: SizedBox(
          height: footerHeight.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(),
              Text('Google Flutter开源技术驱动', style: TextStyle(
                color: Colors.grey,
                fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
              ),),
              Text('我说你是我的春天,繁花似锦的第一春(for TangTao).', style: TextStyle(
                color: Colors.grey,
                fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
              ),),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPersistentHeader(Widget child, {double? maxHeight, double? minHeight}) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverDelegate(
        minHeight: minHeight ?? 50.h,
        maxHeight: maxHeight ?? 50.h,
        child: child
    ),
    );
  }

  Widget buildFirstTabView() {
    return ListView(
      children: [
        ListTile(
          title: Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              border: BoxBorder.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
              shape: BoxShape.rectangle,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomCircleAvatar(
                  child: Text(
                    context.watch<AppConfig>().userFirstName,
                  ),
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  context.watch<AppConfig>().userLastName,
                  style: TextStyle(
                    fontSize: AppResponsive.primaryFontSize.resolve(context).sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: TextField(
            controller: userTextEditingController,
            onChanged: (String value) async {
              if(value.characters.length <= 4) {
                context.read<AppConfig>().handleChangeUserName(value);
                await StorageHelper().setString(userNameKey, value);
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '真实姓名',
              hintText: '限制4个字符内',
              counterText: '',
            ),
            maxLength: 4,
          ),
        ),
      ],
    );
  }

  Widget buildSecondTabView() {
    return ListView(
      children: [
        ListTile(
          title: Text(
              '数据导入导出',
          ),
          subtitle: Text(
              '方便数据备份或迁移',
            style: TextStyle(
              fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
              color: Colors.grey,
            ),
          ),
          onTap: () => showCustomDialog(
            context: context,
            actions: [
              TextButton(onPressed: (){

              }, child: Text('待开发')),
            ],
          ),
        ),
        SwitchListTile(
          value: softwareAutoFill,
          thumbIcon: WidgetStateProperty<Icon>.fromMap(
            <WidgetStatesConstraint, Icon>{
              WidgetState.selected: Icon(Icons.check),
              WidgetState.any: Icon(Icons.close),
            },
          ),
          onChanged: (bool value) => setState((){
            softwareAutoFill = value;
          }),
          title: Text(
              '密码自动填充',
          ),
          subtitle: Text(
              '软件识别自动填充',
            style: TextStyle(
              fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          title: Text(
              '跨平台数据同步',
          ),
          subtitle: Text(
              '端到端加密同步，Asp.Net Core提供后端服务（付费可选）',
            style: TextStyle(
              fontSize: AppResponsive.secondryFontSize.resolve(context).sp,
              color: Colors.grey,
            ),
          ),
          trailing: Icon(Icons.cloud),
          onTap: (){},
        ),
      ],
    );
  }

  Widget buildThridTabView() {
    return ListView(
      children: [
        ListTile(
          title: Text('Github仓库'),
          trailing: Icon(Icons.code),
          onTap: () async {
            await Launcher.onOpenUrl(url: launcherGithubRepositoryUrl, context: context, mode: LaunchMode.inAppWebView);
          },
        ),
        ListTile(
          title: Text('联系我'),
          trailing: Icon(Icons.phone),
          onTap: () async {
            await Launcher.onOpenPhoneCall(context: context, phoneNumber: launcherMyPhone);
          },
        ),
        if(context.read<AppConfig>().userName == '唐涛')ListTile(
          title: Text('我的网站(belong to TangTao)'),
          trailing: Icon(Icons.girl),
          onTap: () async {
            await Launcher.onOpenUrl(url: launcherMyWebsiteUrl, context: context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            buildAppBar(),
            buildAppBuildBar(),
            buildPersistentHeader(
              TabBar(
                controller: tabController,
                tabs: [
                  Tab(text: '我', ),
                  Tab(text: '软件设置',),
                  Tab(text: '开发者',),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: tabController,
                children: [
                  buildFirstTabView(),
                  buildSecondTabView(),
                  buildThridTabView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _SliverDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
  }

}
