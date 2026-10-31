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
/// - Android: CALL_PHONE 권한이 이미 있으면 바로 발신(번호가 다이얼러에 머물지 않음),
///   없으면 `tel:`로 다이얼러를 열어 사용자가 통화 버튼을 누르게 합니다.
/// - iOS: `tel:` (시스템이 발신 확인을 띄움).
/// 권한을 새로 요청하지 않습니다. 필요하면 [requestPermission]을 true로.
class DefaultArsDialer implements ArsDialer {
  const DefaultArsDialer({this.directCall = true, this.requestPermission = false});

  final bool directCall;
  final bool requestPermission;

  @override
  Future<bool> dial(String telUri) async {
    final number = telUri.replaceFirst(RegExp(r'^tel:'), '');
    if (directCall && defaultTargetPlatform == TargetPlatform.android) {
      var granted = await Permission.phone.isGranted;
      if (!granted && requestPermission) granted = await Permission.phone.request().isGranted;
      if (granted) {
        final ok = await FlutterPhoneDirectCaller.callNumber(number);
        if (ok == true) return true;
      }
    }
    final uri = Uri.parse('tel:$number');
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
