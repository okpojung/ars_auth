import 'package:ars_login/model/enum_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/login_model.dart';
import '../repository/network_repository.dart';
import '../repository/hive_repository.dart';
import '../utils/phone_checker.dart';

part 'login_provider.g.dart';

// 로그인 상태 관리 Provider
@riverpod
class LoginNotifier extends _$LoginNotifier {
  final Logger _logger = Logger();
  dynamic _installData; // ARS 설치 데이터 저장

  // 콜백 함수들
  ArsAuthStartCallback? _onAuthStart;
  ArsAuthCompleteCallback? _onAuthComplete;
  ArsAuthFailureCallback? _onAuthFailure;
  ArsManualInputCallback? _onManualInputRequired;

  @override
  LoginState build() {
    return const LoginState();
  }

  // 모든 콜백 함수 설정
  void setCallbacks({
    ArsAuthStartCallback? onAuthStart,
    ArsAuthCompleteCallback? onAuthComplete,
    ArsAuthFailureCallback? onAuthFailure,
    ArsManualInputCallback? onManualInputRequired,
  }) {
    _onAuthStart = onAuthStart;
    _onAuthComplete = onAuthComplete;
    _onAuthFailure = onAuthFailure;
    _onManualInputRequired = onManualInputRequired;
  }

  // 개별 콜백 함수 설정 (기존 호환성 유지)
  void setOnAuthComplete(ArsAuthCompleteCallback? callback) {
    _onAuthComplete = callback;
  }

  // 전체 약관 동의 상태 업데이트
  void updateAllTermsAccepted(bool accepted) {
    state = state.copyWith(
      allTermsAccepted: accepted,
      ageConfirmed: accepted,
      serviceTermsAccepted: accepted,
      privacyTermsAccepted: accepted,
      pushNotificationAccepted: accepted,
    );
  }

  // 개별 약관 동의 상태 업데이트
  void updateTermsAccepted({
    bool? ageConfirmed,
    bool? serviceTermsAccepted,
    bool? privacyTermsAccepted,
    bool? pushNotificationAccepted,
  }) {
    state = state.copyWith(
      ageConfirmed: ageConfirmed ?? state.ageConfirmed,
      serviceTermsAccepted: serviceTermsAccepted ?? state.serviceTermsAccepted,
      privacyTermsAccepted: privacyTermsAccepted ?? state.privacyTermsAccepted,
      pushNotificationAccepted:
          pushNotificationAccepted ?? state.pushNotificationAccepted,
    );

    // 모든 필수 약관이 동의되었는지 확인
    final allAccepted =
        state.ageConfirmed &&
        state.serviceTermsAccepted &&
        state.privacyTermsAccepted;

    state = state.copyWith(allTermsAccepted: allAccepted);
  }

  // 나이 확인 상태 업데이트
  void updateAgeConfirmed(bool confirmed) {
    state = state.copyWith(ageConfirmed: confirmed);
    _checkAllTermsAccepted();
  }

  // 서비스 약관 동의 상태 업데이트
  void updateServiceTermsAccepted(bool accepted) {
    state = state.copyWith(serviceTermsAccepted: accepted);
    _checkAllTermsAccepted();
  }

  // 개인정보 약관 동의 상태 업데이트
  void updatePrivacyTermsAccepted(bool accepted) {
    state = state.copyWith(privacyTermsAccepted: accepted);
    _checkAllTermsAccepted();
  }

  // 푸시 알림 동의 상태 업데이트
  void updatePushNotificationAccepted(bool accepted) {
    state = state.copyWith(pushNotificationAccepted: accepted);
    _checkAllTermsAccepted();
  }

  // 모든 필수 약관이 동의되었는지 확인
  void _checkAllTermsAccepted() {
    final allAccepted =
        state.ageConfirmed &&
        state.serviceTermsAccepted &&
        state.privacyTermsAccepted;

    state = state.copyWith(allTermsAccepted: allAccepted);
  }

  // ARS 인증 시작 (앱 라이프사이클 기반)
  Future<void> startArsAuthentication() async {
    if (!state.allTermsAccepted) {
      state = state.copyWith(
        status: AuthStatus.failure,
        errorMessage: '필수 약관에 동의해주세요.',
      );
      // 인증 실패 콜백 호출
      _onAuthFailure?.call('필수 약관에 동의해주세요.');
      return;
    }

    // 인증 시작 콜백 호출
    _onAuthStart?.call();

    state = state.copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      errorMessage: null,
    );

    try {
      // 1. 통화 기능 확인
      final phoneCapability = await PhoneChecker.checkPhoneCapability();
      if (!phoneCapability.canMakeCall) {
        final errorMsg =
            '${phoneCapability.reason}${phoneCapability.recommendedAction != null ? '\n${phoneCapability.recommendedAction}' : ''}';
        state = state.copyWith(
          status: AuthStatus.failure,
          isLoading: false,
          errorMessage: errorMsg,
        );
        // 인증 실패 콜백 호출
        _onAuthFailure?.call(errorMsg);
        return;
      }

      final networkRepository = ref.read(networkRepositoryProvider.notifier);
      final hiveRepository = ref.read(hiveRepositoryProvider.notifier);

      // 2. 앱 라이프사이클 기반 ARS 인증 실행
      // 반환값은 임시 객체이므로 사용하지 않음
      await networkRepository.executeArsAuthenticationWithLifecycle(
        hiveRepository,
        _onPhoneCallCompleted,
      );

      // 3. 앱 복귀 대기 상태로 변경
      state = state.copyWith(
        status: AuthStatus.waitingForAppReturn,
        isLoading: true,
        errorMessage: '통화 종료 후 앱으로 돌아와주세요.',
      );
    } catch (e) {
      _logger.e('ARS Authentication Start Error: $e');
      final errorMsg = '인증 시작 중 오류가 발생했습니다. 다시 시도해주세요.';
      state = state.copyWith(
        status: AuthStatus.failure,
        isLoading: false,
        errorMessage: errorMsg,
      );
      // 인증 실패 콜백 호출
      _onAuthFailure?.call(errorMsg);
    }
  }

  // 전화통화 완료 콜백
  void _onPhoneCallCompleted(dynamic installData) {
    _logger.i('전화통화 완료. 설치 데이터 저장: $installData');
    _installData = installData;
  }

  // 앱이 포그라운드로 돌아올 때 호출되는 메서드
  Future<void> onAppResumed() async {
    // 앱 복귀 대기 상태에서만 실행
    if (state.status != AuthStatus.waitingForAppReturn ||
        _installData == null) {
      return;
    }

    _logger.i('앱 포그라운드 복귀 감지. Confirm API 호출 시작...');

    // 확인 중 상태로 변경
    state = state.copyWith(
      status: AuthStatus.confirming,
      isLoading: true,
      errorMessage: '인증을 확인하고 있습니다...',
    );

    try {
      final networkRepository = ref.read(networkRepositoryProvider.notifier);
      final hiveRepository = ref.read(hiveRepositoryProvider.notifier);

      final result = await networkRepository.executeConfirmAuthentication(
        _installData,
        hiveRepository,
      );

      // 수동 인증이 필요한 경우가 아닐 때만 installData 초기화
      if (result.callCount != 2) {
        _installData = null; // 사용 완료 후 초기화
      }

      if (result.callCount == 1) {
        state = state.copyWith(
          status: AuthStatus.success,
          isLoading: false,
          errorMessage: null,
        );

        // 인증 성공 시 콜백 호출
        _onAuthComplete?.call(result.toJson());
      } else if (result.callCount == 2) {
        // 수동 인증으로 이동 (UI에서 처리) - installData 유지
        state = state.copyWith(
          status: AuthStatus.manualInputRequired,
          isLoading: false,
          errorMessage: 'ARS 자동인증에 실패했습니다. 수동인증을 진행해주세요.',
        );
        // 수동 입력 필요 콜백 호출
        _onManualInputRequired?.call();
      } else if (result.callCount == 0) {
        final errorMsg = 'ARS 인증을 다시 시도해주세요.';
        state = state.copyWith(
          status: AuthStatus.failure,
          isLoading: false,
          errorMessage: errorMsg,
        );
        // 인증 실패 콜백 호출
        _onAuthFailure?.call(errorMsg);
      } else {
        final errorMsg = '인증에 실패했습니다.';
        state = state.copyWith(
          status: AuthStatus.failure,
          isLoading: false,
          errorMessage: errorMsg,
        );
        // 인증 실패 콜백 호출
        _onAuthFailure?.call(errorMsg);
      }
    } catch (e) {
      _logger.e('Confirm Authentication Error: $e');
      _installData = null;
      final errorMsg = '인증 확인 중 오류가 발생했습니다: ${e.toString()}';
      state = state.copyWith(
        status: AuthStatus.failure,
        isLoading: false,
        errorMessage: errorMsg,
      );
      // 인증 실패 콜백 호출
      _onAuthFailure?.call(errorMsg);
    }
  }

  // 상태 초기화
  void reset() {
    _installData = null;
    _onAuthStart = null;
    _onAuthComplete = null;
    _onAuthFailure = null;
    _onManualInputRequired = null;
    state = const LoginState();
  }

  // 수동 인증 시작
  Future<void> startManualAuthentication(String phoneNumber) async {
    if (_installData == null) {
      final errorMsg = '인증 데이터가 없습니다. 다시 시도해주세요.';
      state = state.copyWith(
        status: AuthStatus.failure,
        isLoading: false,
        errorMessage: errorMsg,
      );
      // 인증 실패 콜백 호출
      _onAuthFailure?.call(errorMsg);
      return;
    }

    state = state.copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      errorMessage: null,
    );

    try {
      final networkRepository = ref.read(networkRepositoryProvider.notifier);
      final hiveRepository = ref.read(hiveRepositoryProvider.notifier);

      // 수동 인증 확인 요청 (install API의 appuuid 사용)
      final result = await networkRepository.requestManualConfirm(
        phoneNumber,
        _installData['appuuid'],
      );

      if (result.callCount == 1) {
        // 인증 성공
        await hiveRepository.saveUserData({
          'appuuid': result.appuuid,
          'appsid': result.appsid,
          'prnts_phone_no': result.prntsPhoneNo,
          'app_cid': result.appCid,
          'isLogged': true,
        });

        // 수동 인증 완료 후 installData 초기화
        _installData = null;

        state = state.copyWith(
          status: AuthStatus.success,
          isLoading: false,
          errorMessage: null,
        );

        // 인증 성공 시 콜백 호출
        _onAuthComplete?.call(result.toJson());
      } else {
        final errorMsg = '입력하신 전화번호로 인증할 수 없습니다. 다시 확인해주세요.';
        state = state.copyWith(
          status: AuthStatus.failure,
          isLoading: false,
          errorMessage: errorMsg,
        );
        // 인증 실패 콜백 호출
        _onAuthFailure?.call(errorMsg);
      }
    } catch (e) {
      _logger.e('Manual Authentication Error: $e');
      final errorMsg = '수동 인증 중 오류가 발생했습니다: ${e.toString()}';
      state = state.copyWith(
        status: AuthStatus.failure,
        isLoading: false,
        errorMessage: errorMsg,
      );
      // 인증 실패 콜백 호출
      _onAuthFailure?.call(errorMsg);
    }
  }
}

// 로그인 상태 확인 Provider
@riverpod
Future<bool> isLoggedIn(Ref ref) async {
  final hiveRepository = ref.read(hiveRepositoryProvider.notifier);
  return hiveRepository.isLoggedIn();
}

// 사용자 정보 Provider
@riverpod
Future<Map<String, dynamic>> userInfo(Ref ref) async {
  final hiveRepository = ref.read(hiveRepositoryProvider.notifier);
  return hiveRepository.getUserData();
}
