// 애플리케이션 전반에 사용되는 상수들
class AppConstants {
  // ARS 인증 API URLs
  static const String hoServerInstallIOS =
      'https://barocall.baro.so/install_app_ios.php';
  static const String hoServerConfirmIOS =
      'https://barocall.baro.so/confirm_auth_ios.php';
  static const String hoServerConfirmRecheckIOS =
      'https://barocall.baro.so/confirm_auth_recheck.php';

  static const String hoServerInstallAndroid =
      'https://barocall.baro.so/install_app.php';
  static const String hoServerConfirmAndroid =
      'https://barocall.baro.so/confirm_auth.php';
  static const String hoServerConfirmRecheckAndroid =
      'https://barocall.baro.so/confirm_auth_recheck.php';

  // 음성인식 후처리 API
  static const String hoServerApi = 'https://barocall.baro.so/baro_call.php';

  // 약관 URL (로컬 assets 사용)
  static const String termsOfServiceUrl =
      'packages/ars_login/assets/html/terms_of_service.html';
  static const String privacyPolicyUrl =
      'packages/ars_login/assets/html/privacy_policy.html';
  
  // 외부 URL (백업용)
  static const String termsOfServiceUrlRemote =
      'https://mobile.barosvc.com/info/use_info2.html';
  static const String privacyPolicyUrlRemote =
      'https://mobile.barosvc.com/info/privacy2.html';

  // 폰트 패밀리
  static const String fontLeferi = 'Leferi';
  static const String fontSCDream = 'SCDream';
}
