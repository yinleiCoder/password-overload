import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:password_overload/common/entity/entity.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:password_overload/global.dart';

class PasswordCreatePage extends StatefulWidget {
  const PasswordCreatePage({super.key});

  @override
  State<PasswordCreatePage> createState() => _PasswordCreatePageState();
}

class _PasswordCreatePageState extends State<PasswordCreatePage> {

  late TextEditingController accountTextController;
  late TextEditingController passwordTextController;
  late TextEditingController noteTextController;
  late TextEditingController sourceTextController;

  bool isObscurePassword = false;

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
        title: Text('新建密码', style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontSize: 18.sp,
        ),),
        actions: [
          IconButton(
            onPressed: () async {
              if(sourceTextController.text.isNotEmpty &&
                  accountTextController.text.isNotEmpty &&
                  passwordTextController.text.isNotEmpty) {

                PasswordItem item = await Global.databaseHelper.insert(PasswordItem(
                  source: sourceTextController.text,
                  account: accountTextController.text,
                  password: passwordTextController.text,
                  note: noteTextController.text,
                ));

                showSnackbar(
                  content: Text('id: ${item.id} 的数据已插入至数据库.'),
                  context: context,
                );

                context.pop(true);// 已经插入数据了，返回上个界面时应刷新
              }
            },
            tooltip: '加密保存数据库',
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        children: [
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
              trailing: Tooltip(
                message: '随机生成强安全密码',
                child: IconButton(
                  icon: Icon(Icons.generating_tokens),
                  onPressed: () {  },
                )
              ),
              obscureText: isObscurePassword,
              onTapInside: (PointerDownEvent event) {
                setState(() {
                  isObscurePassword = false;
                });
              },
              onTapOutside: (PointerDownEvent event) async {
                setState(() {
                  isObscurePassword = true;
                });
                await Future.delayed(Duration(seconds: 3));
              },
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
          ListTile(
            title: Text('注：完成所有必填项，右上方保存按钮，软件将加密保存数据至数据库.', style: TextStyle(
              fontSize: 12.sp,
            ),),
            subtitle: Text('常见的加密算法Plain text password、MD5 & SHA1、SHA256 + Salt、PBKDF2 + Salt、Bcrypt等',style: TextStyle(
              fontSize: 10.sp,
            ),),
          ),
        ],
      ),
    );
  }
}
