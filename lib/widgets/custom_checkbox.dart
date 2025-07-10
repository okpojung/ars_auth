import 'package:flutter/material.dart';
import '../res/custom_colors.dart';
import '../res/custom_theme.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;
  final String title;
  final TextStyle? titleStyle;
  final bool isRequired;
  final bool showRequiredText;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.title,
    this.titleStyle,
    this.isRequired = false,
    this.showRequiredText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor:
              isRequired ? CustomColors.negative : CustomColors.textPrimary,
          checkColor: CustomColors.surface,
        ),
        const SizedBox(width: 10),
        Text(title, style: titleStyle ?? CustomTheme.bodyText),
        const SizedBox(width: 5),
        if (showRequiredText)
          if (isRequired)
            const Text('(필수)', style: CustomTheme.optionText)
          else
            Text(
              '(선택)',
              style: CustomTheme.optionText.copyWith(
                color: CustomColors.textPrimary,
              ),
            ),
      ],
    );
  }
}
