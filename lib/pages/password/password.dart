import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:password_overload/common/state/state.dart';
import 'package:password_overload/common/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextStyle copyrightStyle = TextStyle(
    color: Colors.grey,
    fontSize: 10.sp,
  );

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
                SearchAnchor(
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
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    suggestionsBuilder: (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    }
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      return Future<void>.delayed(const Duration(seconds: 3));
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      addAutomaticKeepAlives: true,
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return _KeepAliveItem(index: index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  ),
                ),
                Padding(
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
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.push('/application/passwords/create');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _KeepAliveItem extends StatefulWidget {
  const _KeepAliveItem({super.key, required this.index});

  final int index;

  @override
  State<_KeepAliveItem> createState() => _KeepAliveItemState();
}

class _KeepAliveItemState extends State<_KeepAliveItem> with AutomaticKeepAliveClientMixin<_KeepAliveItem> {

  bool isShowPassword = false;

  @override
  void didUpdateWidget(covariant _KeepAliveItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListTile(
      leading: CustomCircleAvatar(child: Text('G'),),
      title: Wrap(
        children: [
          Baseline(
            baseline: 30,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              '账号 ${widget.index}',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.copy),
              iconSize: 16.sp,
          ),
        ],
      ),
      subtitle: Wrap(
        children: [
          Baseline(
            baseline: 35,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              isShowPassword ? '密码 ${widget.index}' : '*' * 5,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.copy),
            iconSize: 16.sp,
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: (){
          setState(() {
            isShowPassword = true;
          });
        },
        isSelected: isShowPassword,
        icon: Icon(Icons.remove_red_eye),
        iconSize: 18.sp,
        selectedIcon: CountdownCircle(
          countdownDuration: Duration(
            seconds: 5,
          ),
          circleRadius: 20,
          color: Theme.of(context).primaryColor,
          onComplete: () {
            setState(() {
              isShowPassword = false;
            });
          },
        ),
      ),
      onTap: () {
        context.go('/application/passwords/details');
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

