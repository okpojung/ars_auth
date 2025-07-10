// 전화번호 포맷팅 유틸리티
import 'package:flutter/services.dart';

// TextInputFormatter for phone number formatting
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 숫자만 추출
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 최대 11자리 제한
    if (digitsOnly.length > 11) {
      return oldValue;
    }

    // 포맷팅 적용
    String formatted = '';
    if (digitsOnly.length >= 3) {
      formatted += digitsOnly.substring(0, 3);
      if (digitsOnly.length >= 7) {
        formatted += '-${digitsOnly.substring(3, 7)}';
        if (digitsOnly.length > 7) {
          formatted += '-${digitsOnly.substring(7)}';
        }
      } else if (digitsOnly.length > 3) {
        formatted += '-${digitsOnly.substring(3)}';
      }
    } else {
      formatted = digitsOnly;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PhoneFormatter {
  // 전화번호 입력 시 실시간 포맷팅
  static String formatPhoneNumber(String full, String? input, bool isAppend) {
    if (isAppend) {
      if (full.length < 3) {
        return full + (input ?? '');
      } else if (full.length > 2 && full.length < 8) {
        if (!full.contains('-')) {
          return '$full-${input ?? ''}';
        } else {
          return full + (input ?? '');
        }
      } else if (full.length > 7 && full.length < 13) {
        final check = full.substring(4);
        if (!check.contains('-')) {
          return '$full-${input ?? ''}';
        } else {
          return full + (input ?? '');
        }
      }
      return full;
    } else {
      if (full.length == 5 || full.length == 10) {
        if (full.contains('-')) {
          return full.substring(0, full.length - 2);
        }
      }
      return full.substring(0, full.length - 1);
    }
  }

  // 비밀번호 마스킹
  static String formatPassword(String full, String? input, bool isAppend) {
    String maskedPassword = '';
    for (int i = 0; i < full.length; i++) {
      maskedPassword += ' ●';
    }
    if (isAppend) {
      maskedPassword += ' ●';
    } else {
      if (maskedPassword.length == 1) {
        maskedPassword = maskedPassword.substring(0, maskedPassword.length - 1);
      } else if (maskedPassword.length > 1) {
        maskedPassword = maskedPassword.substring(0, maskedPassword.length - 2);
      }
    }
    return maskedPassword;
  }

  // 전화번호 전체 포맷팅 (저장된 번호 표시용)
  static String formatFullPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      final first = phoneNumber.substring(0, 3);
      final second = phoneNumber.substring(3, 7);
      final third = phoneNumber.substring(7, 11);
      return '$first-$second-$third';
    }
    return phoneNumber;
  }

  // 전화번호 유효성 검사
  static bool isValidPhoneNumber(String phoneNumber) {
    // 한국 전화번호 패턴
    final RegExp phoneRegex = RegExp(r'^(010|011|016|017|018|019)\d{7,8}$');
    return phoneRegex.hasMatch(phoneNumber.replaceAll('-', ''));
  }

  // 한국 전화번호 전용 검증 (010-xxxx-xxxx)
  static bool isValidKoreanPhoneNumber(String phoneNumber) {
    // 하이픈 제거
    final cleanNumber = phoneNumber.replaceAll('-', '');

    // 총 11자리인지 확인 (010 + 8자리)
    if (cleanNumber.length != 11) {
      return false;
    }

    // 모든 문자가 숫자인지 확인
    return RegExp(r'^\d+$').hasMatch(cleanNumber);
  }

  // 전화번호 검증 오류 메시지 반환 (입력 시 실시간 검증용)
  static String? getPhoneNumberErrorMessage(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll('-', '');

    if (cleanNumber.isEmpty) {
      return null; // 빈 입력은 에러로 표시하지 않음
    }

    if (!cleanNumber.startsWith('010')) {
      return '010으로 시작하는 전화번호를 입력해주세요.';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return '숫자만 입력해주세요.';
    }

    return null; // 유효한 경우
  }

  // 전화번호 완전 검증 (버튼 클릭 시 사용)
  static String? getCompletePhoneNumberErrorMessage(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll('-', '');

    if (cleanNumber.isEmpty) {
      return '전화번호를 입력해주세요.';
    }

    if (!cleanNumber.startsWith('010')) {
      return '010으로 시작하는 전화번호를 입력해주세요.';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return '숫자만 입력해주세요.';
    }

    if (cleanNumber.length != 11) {
      return '올바른 전화번호 형식이 아닙니다. (11자리 입력 필요)';
    }

    return null; // 모든 검증 통과
  }

  // 전화번호에서 하이픈 제거
  static String removeHyphen(String phoneNumber) {
    return phoneNumber.replaceAll('-', '');
  }
}
