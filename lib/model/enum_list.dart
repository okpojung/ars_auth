import '../res/constants.dart';

/// 인증 상태 enum
enum AuthStatus {
  initial,
  loading,
  waitingForAppReturn,
  confirming,
  manualInputRequired,
  success,
  failure,
}

/// 권한 타입 enum
enum PermissionType { microphone, phone, contacts, camera, location, storage }

/// 약관 타입 enum
enum TermsType {
  service('이용약관', AppConstants.termsOfServiceUrl),
  privacy('개인정보 처리방침', AppConstants.privacyPolicyUrl);

  const TermsType(this.title, this.url);
  final String title;
  final String url;
}
