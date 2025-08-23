import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({super.key, required this.textEditingController, this.hintText, this.obscureText, this.maxLength, this.maxLines = 1, this.trailing, this.onSubmitted, this.onEditingComplete, this.onChanged, this.onTapOutside, this.onTapInside,});

  final TextEditingController textEditingController;
  final String? hintText;
  final bool? obscureText;
  final int? maxLength;
  final int? maxLines;
  final Widget? trailing;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent event)? onTapOutside;
  final void Function(PointerDownEvent event)? onTapInside;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: TapRegion(
              onTapOutside: widget.onTapOutside,
              onTapInside: widget.onTapInside,
              child: TextField(
                controller: widget.textEditingController,
                onSubmitted: widget.onSubmitted,
                onEditingComplete: widget.onEditingComplete,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                autocorrect: false,
                obscureText: widget.obscureText ?? false,
                enableSuggestions: false,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
              ),
            ),
          ),
          if(widget.trailing != null)widget.trailing!
        ],
      ),
    );
  }
}
