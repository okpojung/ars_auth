import 'package:flutter/material.dart';
import '../res/custom_colors.dart';
import '../res/custom_theme.dart';
import '../utils/custom_page_route.dart';
import '../model/enum_list.dart';
import 'terms.dart';

class TermsLinkWidget extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;
  final String title;
  final String url;
  final bool isRequired;

  const TermsLinkWidget({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.title,
    required this.url,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: CustomColors.negative,
          checkColor: CustomColors.surface,
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _openTermsScreen(context);
          },
          child: Text(
            title,
            style: CustomTheme.bodyText.copyWith(
              decoration: TextDecoration.underline,
              color: CustomColors.primary,
            ),
          ),
        ),
        const Text('에 동의합니다.', style: CustomTheme.bodyText),
        const SizedBox(width: 5),
        if (isRequired) const Text('(필수)', style: CustomTheme.optionText),
      ],
    );
  }

  void _openTermsScreen(BuildContext context) {
    // URL을 기반으로 적절한 TermsType 결정
    TermsType termsType;

    if (url.contains('use_info')) {
      termsType = TermsType.service;
    } else if (url.contains('privacy')) {
      termsType = TermsType.privacy;
    } else {
      // 기본값이나 커스텀 URL인 경우 - 제목을 기반으로 결정
      if (title.contains('개인정보')) {
        termsType = TermsType.privacy;
      } else {
        termsType = TermsType.service;
      }
    }

    // 아래에서 위로 슬라이드 업 애니메이션 사용 (모달 스타일)
    Navigator.of(context).push(
      CupertinoSlidePageRoute(
        child: TermsScreen(termsType: termsType),
        duration: const Duration(milliseconds: 350), // 부드러운 속도
      ),
    );
  }
}
