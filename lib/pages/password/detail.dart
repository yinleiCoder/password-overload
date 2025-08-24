import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:password_overload/common/entity/entity.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:password_overload/global.dart';
import 'package:provider/provider.dart';

class PasswordDetailPage extends StatefulWidget {
  const PasswordDetailPage({super.key});

  @override
  State<PasswordDetailPage> createState() => _PasswordDetailPageState();
}

class _PasswordDetailPageState extends State<PasswordDetailPage> {

  late TextEditingController accountTextController;
  late TextEditingController passwordTextController;
  late TextEditingController noteTextController;
  late TextEditingController sourceTextController;

  late Future<PasswordItem?> itemFuture;
  late int id;

  bool isShowPassword = false;

  @override
  void initState() {
    super.initState();
    accountTextController = TextEditingController();
    passwordTextController = TextEditingController();
    noteTextController = TextEditingController();
    sourceTextController = TextEditingController();
  }

  @override
  void dispose() {
    accountTextController.dispose();
    passwordTextController.dispose();
    noteTextController.dispose();
    sourceTextController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id = GoRouterState.of(context).extra! as int;
    itemFuture = Global.databaseHelper.queryItemById(id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: '全部清空当前数据',
            onPressed: () {
              accountTextController.clear();
              passwordTextController.clear();
              noteTextController.clear();
              sourceTextController.clear();
              showSnackbar(
                content: Text('已清空当前所有输入的内容.'),
                context: context,
              );
            },
            icon: Icon(Icons.clear_all),
          ),
          IconButton(
            onPressed: () async {
              if (accountTextController.text.isEmpty ||
                  passwordTextController.text.isEmpty ||
                  sourceTextController.text.isEmpty) {
                showSnackbar(
                  content: Text('请完成所有必填项，方可同步更新数据库.'),
                  context: context,
                );
                return;
              } else {
                showSnackbar(
                  content: Text('id: $id 的数据已更新至数据库'),
                  context: context,
                );
                Global.databaseHelper.update(PasswordItem(
                  id: GoRouterState.of(context).extra! as int,
                  source: sourceTextController.text,
                  account: accountTextController.text,
                  password: passwordTextController.text,
                  note: noteTextController.text,
                ));
                context.pop(true);// 已经插入数据了，返回上个界面时应刷新
              }
            },
            icon: Icon(Icons.save_as),
            tooltip: '保存更改',
          ),
        ],
      ),
      body: CustomFutureBuilder(
          future: itemFuture,
          onSuccess: (AsyncSnapshot asyncSnapshot) {
            PasswordItem? item = asyncSnapshot.data as PasswordItem?;
            if(item != null) {
              accountTextController.text = item.account;
              passwordTextController.text = item.password;
              noteTextController.text = item.note ?? '';
              sourceTextController.text = item.source;
              return ListView(
                children: [
                  ListTile(
                    title: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        Chip(
                          avatar: CustomCircleAvatar(child: Text('id', style: TextStyle(fontSize: 12.sp)),),
                          label: Text('${item.id}', style: TextStyle(fontSize: 14.sp)),
                        ),
                        Chip(
                          avatar: CustomCircleAvatar(child: Text(context.watch<AppConfig>().userFirstName, style: TextStyle(fontSize: 12.sp)),),
                          label: Text(context.watch<AppConfig>().userLastName, style: TextStyle(fontSize: 14.sp)),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomInput(
                      textEditingController: sourceTextController,
                      hintText: '来源简称（如：Github）',
                    ),
                  ),
                  ListTile(
                    title: CustomInput(
                      textEditingController: accountTextController,
                      hintText: '账号（如：手机号、用户名、银行卡号）',
                    ),
                  ),
                  ListTile(
                    title: CustomInput(
                      textEditingController: passwordTextController,
                      hintText: '密码',
                      trailing: IconButton(
                        isSelected: isShowPassword,
                        onPressed: (){
                          setState(() {
                            isShowPassword = !isShowPassword;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye),
                        selectedIcon: Icon(Icons.lock),
                      ),
                      obscureText: !isShowPassword,
                    ),
                  ),
                  ListTile(
                    title: CustomInput(
                      textEditingController: noteTextController,
                      hintText: '备注（可选）',
                      maxLines: 5,
                      maxLength: 120,
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('数据库获取id: $id 的数据失败.', style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: Theme.of(context).primaryColor,
                ),),
              );
            }
          }
      ),
    );
  }
}
