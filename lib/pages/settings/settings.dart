import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/utils/utils.dart';
import 'package:password_overload/common/values/values.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool softwareAutoFill = false;

  late TextEditingController userTextEditingController;

  @override
  void initState() {
    super.initState();
    userTextEditingController = TextEditingController();
    userTextEditingController.text = context.read<AppConfig>().userName ?? '';
  }

  @override
  void dispose() {
    userTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            snap: false,
            floating: true,
            expandedHeight: 120.h,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: 'https://img.zcool.cn/community/6884dacbaa44doyd05du3w1194.jpg?imageMogr2/auto-orient/thumbnail/1280x%3e/sharpen/0.5/quality/100/format/webp',
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
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                dense: true,
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
                  ),
                  maxLength: 4,
                ),
              ),
              Divider(
                indent: 16.w,
                endIndent: 16.w,
              ),
              ListTile(
                title: Text('数据导入导出'),
                subtitle: Text('方便数据备份或迁移'),
                onTap: (){},
              ),
              SwitchListTile(
                value: softwareAutoFill,
                onChanged: (bool value) => setState((){
                  softwareAutoFill = value;
                }),
                title: Text('密码自动填充'),
                subtitle: Text('软件识别自动填充'),
              ),
              ListTile(
                title: Text('跨平台数据同步'),
                subtitle: Text('端到端加密同步，Asp.Net Core提供后端服务（付费可选）'),
                trailing: Icon(Icons.cloud),
                onTap: (){},
              ),
              Divider(
                indent: 16.w,
                endIndent: 16.w,
              ),
              ListTile(
                title: Text('检查新版本'),
                trailing: Icon(Icons.update),
                onTap: (){},
              ),
              ListTile(
                title: Text('Github仓库'),
                trailing: Icon(Icons.code),
                onTap: (){},
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterLogo(),
                    Text('Google Flutter开源技术驱动', style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.sp,
                    ),),
                    Text('我说你是我的春天,繁花似锦的第一春.', style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.sp,
                    ),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
