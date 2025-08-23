import 'package:flutter/material.dart';
import 'package:password_overload/pages/password/password.dart';
import 'package:password_overload/pages/settings/settings.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> with TickerProviderStateMixin {
  late PageController pageViewController;
  int currentPageIndex = 0;

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

  void handlePageViewChanged(int currentPageIndex) {
    setState(() {
      this.currentPageIndex = currentPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

