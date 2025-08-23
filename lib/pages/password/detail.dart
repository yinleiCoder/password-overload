import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/widgets/widgets.dart';
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
            },
            icon: Icon(Icons.clear_all)
          ),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.save_as),
            tooltip: '保存更改',
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                Chip(
                  onDeleted: () {
                    sourceTextController.clear();
                  },
                  avatar: CustomCircleAvatar(child: Text('G', style: TextStyle(fontSize: 12.sp)),),
                  label: Text('ithub', style: TextStyle(fontSize: 14.sp)),
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
      ),
    );
  }
}
