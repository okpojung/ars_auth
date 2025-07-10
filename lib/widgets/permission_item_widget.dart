import 'package:flutter/material.dart';
import '../res/custom_colors.dart';
import '../res/custom_theme.dart';

class PermissionItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  const PermissionItemWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Icon(icon, size: 30, color: CustomColors.icon),
        ),
        Expanded(
          flex: 7,
          child: Text(
            title,
            style: CustomTheme.bodyText.copyWith(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
