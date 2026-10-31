/// ars2fa 발신 ARS 휴대폰 인증 SDK.
library;

import 'package:flutter/material.dart';

import 'src/config.dart';
import 'src/login_ars.dart';
import 'src/models.dart';

export 'src/ars2fa_client.dart';
export 'src/ars_auth_controller.dart';
export 'src/config.dart';
export 'src/dialer.dart';
export 'src/login_ars.dart';
export 'src/models.dart';

/// 간단 사용: 인증 화면을 띄우고 결과를 돌려받는다. 사용자가 닫으면 실패(canceled_by_client) 또는 null.
class Ars2fa {
  Ars2fa._();

  static Future<ArsResult?> authenticate(BuildContext context, Ars2faConfig config, {bool autoStart = true}) {
    return Navigator.of(context).push<ArsResult>(
      MaterialPageRoute(builder: (_) => LoginARS(config: config, autoStart: autoStart)),
    );
  }
}
