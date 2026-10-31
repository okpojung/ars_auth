/// ars2fa API 데이터 모델.
library;

/// 세션 상태 (서버 `status`).
enum ArsSessionStatus {
  pending,
  callConfirmed,
  verified,
  failed,
  expired,
  canceled,
  unknown;

  static ArsSessionStatus parse(String? v) {
    switch (v) {
      case 'PENDING':
        return ArsSessionStatus.pending;
      case 'CALL_CONFIRMED':
        return ArsSessionStatus.callConfirmed;
      case 'VERIFIED':
        return ArsSessionStatus.verified;
      case 'FAILED':
        return ArsSessionStatus.failed;
      case 'EXPIRED':
        return ArsSessionStatus.expired;
      case 'CANCELED':
        return ArsSessionStatus.canceled;
      default:
        return ArsSessionStatus.unknown;
    }
  }

  /// 더 이상 바뀌지 않는 최종 상태인지.
  bool get isFinal =>
      this == verified || this == failed || this == expired || this == canceled;
}

/// 서버 실패 사유 코드와 사용자에게 보여줄 한국어 문구.
class ArsFailReason {
  ArsFailReason._();

  static const Map<String, String> labels = {
    'hidden_caller': '발신번호가 숨겨져 있습니다. 발신번호 표시를 켜고 다시 시도해 주세요.',
    'not_mobile': '휴대폰으로만 인증할 수 있습니다.',
    'not_confirmed': '안내에 따라 번호를 누르지 않았습니다.',
    'no_authlog': '통신사 확인이 되지 않았습니다. 다시 시도해 주세요.',
    'no_session': '진행 중인 인증이 없습니다.',
    'multiple_calls': '같은 번호로 여러 통의 전화가 걸려 인증을 중단했습니다.',
    'second_call': '이미 처리된 인증입니다.',
    'phone_mismatch': '요청한 휴대폰 번호와 다른 번호로 전화했습니다.',
    'timeout': '인증 시간이 지났습니다.',
    'canceled_by_client': '인증을 취소했습니다.',
    'pool_mismatch': '인증 회선이 일치하지 않습니다.',
    'pc_code_wrong': '인증번호가 틀렸습니다.',
    'code_timeout': '인증번호 입력 시간이 지났습니다.',
    'invalid_access': '인증 요청이 아닌 전화입니다.',
    // SDK 자체 사유
    'dial_failed': '전화를 걸 수 없습니다.',
    'network_error': '네트워크 오류가 발생했습니다.',
  };

  static String label(String? code) =>
      labels[code] ?? '인증에 실패했습니다${code == null ? '' : ' ($code)'}.';
}

/// POST /v1/ars/sessions 응답 (APP 모드).
class ArsSession {
  ArsSession({
    required this.sessionId,
    required this.status,
    required this.dialUri,
    required this.expiresAt,
    required this.expiresIn,
    required this.displayName,
    required this.notice,
    required this.integrity,
    required this.clockOffset,
    this.dialNumber,
  });

  final String sessionId;
  final ArsSessionStatus status;

  /// 앱이 직접 거는 번호. **화면에 표시하거나 로그에 남기지 마세요.**
  final String? dialNumber;

  /// `tel:0507-....` 형식.
  final String dialUri;
  final DateTime expiresAt;
  final int expiresIn;
  final String displayName;
  final String notice;
  final String integrity;

  /// 서버 시계 - 기기 시계. 남은 시간 계산에 사용.
  final Duration clockOffset;

  factory ArsSession.fromJson(Map<String, dynamic> j, {DateTime? receivedAt}) {
    final now = receivedAt ?? DateTime.now();
    final dialNumber = j['dial_number'] as String?;
    final dialUri = (j['dial_uri'] as String?) ??
        (dialNumber != null ? 'tel:$dialNumber' : '');
    if (dialUri.isEmpty) {
      throw const FormatException('dial_uri missing (PC mode session?)');
    }
    return ArsSession(
      sessionId: j['session_id'] as String,
      status: ArsSessionStatus.parse(j['status'] as String?),
      dialNumber: dialNumber,
      dialUri: dialUri,
      expiresAt: DateTime.parse(j['expires_at'] as String),
      expiresIn: (j['expires_in'] as num?)?.toInt() ?? 30,
      displayName: (j['display_name'] as String?) ?? '',
      notice: (j['notice'] as String?) ?? '',
      integrity: (j['integrity'] as String?) ?? 'NOT_PROVIDED',
      clockOffset: serverOffset(j['server_time'] as String?, now),
    );
  }

  /// 서버 시계 기준 남은 시간.
  Duration remaining([DateTime? now]) {
    final serverNow = (now ?? DateTime.now()).add(clockOffset);
    final d = expiresAt.difference(serverNow);
    return d.isNegative ? Duration.zero : d;
  }

  @override
  String toString() => 'ArsSession($sessionId, $status)'; // 번호는 출력하지 않음
}

/// POST /v1/ars/sessions/status 응답.
class ArsSessionState {
  ArsSessionState({
    required this.sessionId,
    required this.status,
    this.failReason,
    this.phone,
    this.phoneMasked,
    this.expiresAt,
  });

  final String sessionId;
  final ArsSessionStatus status;
  final String? failReason;

  /// 통신사가 확인한 휴대폰 번호 (VERIFIED일 때만).
  final String? phone;
  final String? phoneMasked;
  final DateTime? expiresAt;

  factory ArsSessionState.fromJson(Map<String, dynamic> j) => ArsSessionState(
        sessionId: j['session_id'] as String,
        status: ArsSessionStatus.parse(j['status'] as String?),
        failReason: j['fail_reason'] as String?,
        phone: j['phone'] as String?,
        phoneMasked: j['phone_masked'] as String?,
        expiresAt: j['expires_at'] == null
            ? null
            : DateTime.tryParse(j['expires_at'] as String),
      );

  @override
  String toString() =>
      'ArsSessionState($sessionId, $status, ${failReason ?? '-'}, ${phoneMasked ?? '-'})';
}

/// 인증 결과 (호스트 앱 콜백 / `Navigator.pop` 값).
class ArsResult {
  const ArsResult._({
    required this.success,
    this.sessionId,
    this.phone,
    this.phoneMasked,
    this.reason,
    this.errorCode,
  });

  factory ArsResult.verified(ArsSessionState s) => ArsResult._(
        success: true,
        sessionId: s.sessionId,
        phone: s.phone,
        phoneMasked: s.phoneMasked,
      );

  factory ArsResult.failed({String? sessionId, String? reason, String? errorCode}) =>
      ArsResult._(success: false, sessionId: sessionId, reason: reason, errorCode: errorCode);

  final bool success;
  final String? sessionId;

  /// 인증된 휴대폰 번호 (숫자만, 예: 01012345678). 성공 시에만.
  final String? phone;
  final String? phoneMasked;

  /// 실패 사유 코드 (`fail_reason` 또는 SDK 사유).
  final String? reason;

  /// API 오류 코드 (예: NO_NUMBER_AVAILABLE, CARRIER_UNAVAILABLE, HTTP_401).
  final String? errorCode;

  /// 사용자에게 보여줄 실패 문구.
  String get message => success
      ? '인증되었습니다.'
      : errorCode != null
          ? Ars2faErrorText.of(errorCode!)
          : ArsFailReason.label(reason);

  @override
  String toString() => success
      ? 'ArsResult(success, ${phoneMasked ?? '-'})'
      : 'ArsResult(fail, reason=${reason ?? '-'}, error=${errorCode ?? '-'})';
}

/// API 오류 코드 문구.
class Ars2faErrorText {
  Ars2faErrorText._();

  static String of(String code) {
    switch (code) {
      case 'NO_NUMBER_AVAILABLE':
        return '지금은 인증 요청이 많습니다. 잠시 후 다시 시도해 주세요.';
      case 'CARRIER_UNAVAILABLE':
        return '인증 번호를 준비하지 못했습니다. 잠시 후 다시 시도해 주세요.';
      case 'APP_INTEGRITY_FAILED':
        return '앱 무결성 확인에 실패했습니다. 스토어에서 받은 정식 앱인지 확인해 주세요.';
      case 'NETWORK_ERROR':
        return '네트워크 연결을 확인해 주세요.';
      default:
        return '인증을 시작할 수 없습니다 ($code).';
    }
  }
}

/// `server_time`(ISO)과 수신 시각으로 서버-기기 시계 차를 구한다.
Duration serverOffset(String? serverTime, DateTime receivedAt) {
  if (serverTime == null) return Duration.zero;
  final t = DateTime.tryParse(serverTime);
  return t == null ? Duration.zero : t.difference(receivedAt);
}
