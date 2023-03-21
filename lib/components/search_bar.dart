import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.controller,
    required this.callback,
    this.hint,
    this.focus,
    this.autofocus = false,
    this.icon,
    this.onIconTap,
  }) : super(key: key);

  final TextEditingController controller;
  final void Function(String text) callback;
  final String? hint;
  final FocusNode? focus;
  final bool autofocus;
  final IconData? icon;
  final void Function()? onIconTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE1E2E6),
          width: 1,
        ),
        color: const Color(0xFFEFF0F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        autofocus: autofocus,
        onChanged: callback,
        controller: controller,
        focusNode: focus,
        style: CliaryTextStyle.get(),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: CliaryInkWell(
            onTap: onIconTap ?? () {},
            child: Icon(
              icon ?? Icons.search,
              color: CliaryColors.textBlack,
            ),
          ),
          suffixIcon: Offstage(
            offstage: controller.text.isEmpty,
            child: InkWell(
              onTap: () {
                controller.clear();
                callback('');
              },
              child: const Icon(
                Icons.cancel,
                color: Color(0xFF999999),
              ),
            ),
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: CliaryColors.descriptionTextGray,
          ),
        ),
      ),
    );
  }
}
