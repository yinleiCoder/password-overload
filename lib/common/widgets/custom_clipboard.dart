import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_overload/common/widgets/widgets.dart';

class CustomClipboard extends StatefulWidget {
  const CustomClipboard({super.key, this.iconSize = 16, required this.copyText});
  final double? iconSize;
  final String copyText;

  @override
  State<CustomClipboard> createState() => _CustomClipboardState();
}

class _CustomClipboardState extends State<CustomClipboard> {

  bool isCopied = false;

  @override
  void initState() {
    super.initState();
  }

  void handleCopyToSystemClipboard(String copyText) async {
    if(isCopied) {
      return;
    }
    // 复制内容到剪贴板，并30秒后清空
    try {
      await FlutterClipboard.copy(copyText);
      showSnackbar(context: context, content: Text('数据已复制至剪贴板，30秒后清空系统剪贴板'), duration: Duration(seconds: 2));
    } on ClipboardException catch (e) {
      showSnackbar(context: context, content: Text('数据复制到剪贴板操作失败: ${e.code} ${e.message}'), duration: Duration(seconds: 2));
    }
    /**
     * 剪贴板监控
     * // Add clipboard change listener
        void onClipboardChanged(EnhancedClipboardData data) {
        print('Clipboard changed: ${data.text}');
        }

        FlutterClipboard.addListener(onClipboardChanged);

        // Start automatic monitoring
        FlutterClipboard.startMonitoring(interval: Duration(milliseconds: 500));

        // Stop monitoring
        FlutterClipboard.stopMonitoring();

        // Remove listener
        FlutterClipboard.removeListener(onClipboardChanged);

        实用方法
        // Check if clipboard has content
        bool hasData = await FlutterClipboard.hasData();

        // Check if clipboard is empty
        bool isEmpty = await FlutterClipboard.isEmpty();

        // Get clipboard content type
        ClipboardContentType type = await FlutterClipboard.getContentType();

        // Get clipboard data size
        int size = await FlutterClipboard.getDataSize();

        // Validate input before copying
        bool isValid = FlutterClipboard.isValidInput('Hello World');
     */
    setState(() {
      isCopied = !isCopied;
    });
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isCopied = !isCopied;
      });
    });
    await Future.delayed(Duration(seconds: 30), () async {
      await FlutterClipboard.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => handleCopyToSystemClipboard(widget.copyText),
      isSelected: isCopied,
      icon: Icon(Icons.copy),
      selectedIcon: Icon(Icons.done),
      iconSize: widget.iconSize,
    );
  }

}
