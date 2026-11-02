import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// 인증 번호로 전화를 거는 방법. 테스트나 커스텀 발신을 위해 바꿀 수 있습니다.
abstract class ArsDialer {
  /// [telUri] 예: `tel:0507-1234-5678`. 발신을 시작했으면 true.
  Future<bool> dial(String telUri);
}

/// 기본 발신기.
/// - Android: 바로 발신합니다(번호가 다이얼러에 머물지 않음). 전화 권한(CALL_PHONE)이 없으면
///   발신 모듈이 시스템 권한 창을 띄우고, 허용되면 그대로 발신합니다.
///   거부되었거나 바로 발신이 실패하면 `tel:`로 다이얼러를 열어 사용자가 통화 버튼을 누르게 합니다.
///   (권한 창은 CALL_PHONE만 요청합니다. READ_PHONE_STATE 등 다른 전화 권한은 필요 없습니다.)
/// - iOS: `tel:` (시스템이 발신 확인을 띄움).
class DefaultArsDialer implements ArsDialer {
  const DefaultArsDialer({this.directCall = true, this.requestPermission = true});

  final bool directCall;

  /// false면 권한이 이미 있을 때만 바로 발신하고, 권한 창은 띄우지 않습니다.
  final bool requestPermission;

  @override
  Future<bool> dial(String telUri) async {
    final number = telUri.replaceFirst(RegExp(r'^tel:'), '');
    if (directCall && defaultTargetPlatform == TargetPlatform.android) {
      var allowed = requestPermission;
      if (!allowed) {
        try {
          allowed = await Permission.phone.isGranted;
        } catch (_) {
          allowed = false;
        }
      }
      if (allowed) {
        try {
          // CALL_PHONE이 없으면 이 호출이 권한 창을 띄우고, 허용되면 발신 후 true를 돌려줍니다.
          final ok = await FlutterPhoneDirectCaller.callNumber(number);
          if (ok == true) return true;
        } catch (_) {
          // 다이얼러로 넘어갑니다.
        }
      }
    }
    final uri = Uri.parse('tel:$number');
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
