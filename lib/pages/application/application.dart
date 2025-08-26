import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:layout/layout.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/values/values.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:password_overload/pages/password/password.dart';
import 'package:password_overload/pages/settings/settings.dart';
import 'package:provider/provider.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> with TickerProviderStateMixin {

  late PageController pageViewController;
  int currentPageIndex = 0;

  DateTime? currentBackPressTime;

  final displaySidebarLabel = LayoutValue(xs: false, lg: true);
  
  @override
  void initState() {
    super.initState();
    pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  bool closeOnConfirm() {
    DateTime now = DateTime.now();
    if(currentBackPressTime == null || now.difference(currentBackPressTime!) > const
        Duration(seconds: 3)) {
      currentBackPressTime = now;
      showSnackbar(context: context, content: Text('再按一次退出程序'));
      return false;
    }
    currentBackPressTime = null;
    return true;
  }

  void handlePageViewChanged(int currentPageIndex) {
    setState(() {
      this.currentPageIndex = currentPageIndex;
    });
  }

  Widget LayoutWithBottomNavigationBar() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        if(didPop) {
          return;
        }
        if(closeOnConfirm()) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: pageViewController,
          onPageChanged: handlePageViewChanged,
          children: [
            PasswordPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            pageViewController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.lock),
              icon: Icon(Icons.lock_outline),
              label: '密码',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }

  Widget LayoutWithSideNavigationBar() {
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = PasswordPage();
        break;
      case 1:
        page = SettingsPage();
        break;
      default:
        page = Center(
          child: Text('路由加载出错，无该页面！'),
        );
        throw UnimplementedError('no widget for $currentPageIndex');
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: displaySidebarLabel.resolve(context),
              leading: Center(
                child: Margin(
                  child: CustomCircleAvatar(
                    maxRadius: AppResponsive.circleRadius.resolve(context).w,
                    child: Text(
                      context.watch<AppConfig>().userFirstName,
                      style: TextStyle(
                        fontSize: AppResponsive.primaryFontSize.resolve(context).sp,
                      ),
                    ),
                  ),
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.lock),
                  icon: Icon(Icons.lock_outline),
                  label: Text('密码'),
                ),
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.settings),
                  icon: Icon(Icons.settings_outlined),
                  label: Text('设置'),
                ),
              ],
              selectedIndex: currentPageIndex,
              onDestinationSelected: (value) {
                setState(() {
                  currentPageIndex = value;
                });
              },
            ),
          ),
          VerticalDivider(
            width: 1.w,
          ),
          Expanded(
            child: page,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      xs: (context) => LayoutWithBottomNavigationBar(),
      md: (context) => LayoutWithSideNavigationBar(),
    );
  }
}

