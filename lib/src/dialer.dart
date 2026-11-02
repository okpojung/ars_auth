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
/// - Android: CALL_PHONE 권한이 없으면 먼저 권한을 요청하고(기본), 허용되면 바로 발신합니다
///   (번호가 다이얼러에 머물지 않음). 거부되었거나 바로 발신이 실패하면 `tel:`로 다이얼러를 엽니다.
/// - iOS: `tel:` (시스템이 발신 확인을 띄움).
class DefaultArsDialer implements ArsDialer {
  const DefaultArsDialer({this.directCall = true, this.requestPermission = true});

  final bool directCall;
  final bool requestPermission;

  @override
  Future<bool> dial(String telUri) async {
    final number = telUri.replaceFirst(RegExp(r'^tel:'), '');
    if (directCall && defaultTargetPlatform == TargetPlatform.android) {
      var granted = await Permission.phone.isGranted;
      if (!granted && requestPermission && !await Permission.phone.isPermanentlyDenied) {
        granted = await Permission.phone.request().isGranted;
      }
      if (granted) {
        final ok = await FlutterPhoneDirectCaller.callNumber(number);
        if (ok == true) return true;
      }
    }
    final uri = Uri.parse('tel:$number');
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
