import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:password_overload/pages/application/application.dart';
import 'package:password_overload/pages/index/index.dart';
import 'package:password_overload/pages/password/create.dart';
import 'package:password_overload/pages/password/detail.dart';
import 'package:password_overload/pages/welcome/welcome.dart';

/// GoRouter configuration
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'index',
      path: '/',
      builder: (context, state) => IndexPage(),
    ),
    GoRoute(
      name: 'welcome',// context.goNamed('welcome', pathParameters: {'songId': 123});
      path: '/welcome',
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      name: 'application',
      path: '/application',
      builder: (context, state) => ApplicationPage(),
      routes: [
        GoRoute(
          path: 'passwords/create',
          builder: (context, state) => PasswordCreatePage(),
        ),
        GoRoute(
          path: 'passwords/details',
          builder: (context, state) => PasswordDetailPage(),
        ),
      ]
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    if(false) {
      // 如果本地存储中没有用户名数据，就重定向到欢迎页面
      // 或者命名路由context.namedLocation('welcome');
      return '/welcome';
    } else {
      return null;
    }
  },
  debugLogDiagnostics: true,
);