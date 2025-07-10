import 'package:freezed_annotation/freezed_annotation.dart';
import 'enum_list.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

// 콜백 함수 타입 정의 추가
typedef ArsAuthStartCallback = void Function();
typedef ArsAuthCompleteCallback = void Function(Map<String, dynamic> userInfo);
typedef ArsAuthFailureCallback = void Function(String error);
typedef ArsManualInputCallback = void Function();

// 로그인 상태 모델
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(AuthStatus.initial) AuthStatus status,
    @Default(false) bool isLoading,
    @Default(false) bool allTermsAccepted,
    @Default(false) bool ageConfirmed,
    @Default(false) bool serviceTermsAccepted,
    @Default(false) bool privacyTermsAccepted,
    @Default(false) bool pushNotificationAccepted,
    String? errorMessage,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, dynamic> json) =>
      _$LoginStateFromJson(json);
}

/*
{
"appsid":"3da3bf62b04589f827bce25dbfb26921e1b7568e203e8aa594373ccf835f3de248467f9416a0e1cc594917ff3be02c0aa5c3068843e77d350d10e6cd0f6cdd94",
"appip":"192.168.94.1",
"now":"2025-07-07 16:02:46",
"phonenum":"+8270-7540-1426",
"return":true,
"lease_time":"2025-07-07 16:03:16",
"appuuid":"C5CECB54-6930-670E-93F1-4F7F3BE102C7",
"gcmid":"deprecated",
"playerid":"deprecated",
"msg":"succeeded",
}
*/

/*
          * {appsid: 41c136b229d088ce08316f21ddcc01549752f3a4f525749a3749bc86e667caf25085d6b1289ae53eb9430954d4a8d7b0b150c6d5375278e5186838b0439ae307,
          *  appuuid: E39E023F-5835-CE9B-E8EB-91010CBB9926,
          *  appip: 210.57.238.143,
          *  return: true,
          *  now: 2022-03-03 15-36-36,
          *  call_count: 1,
          *  app_cid: 01021581108,
          *  msg: WARNING: existing APP is disabled,
          *  inst_phone_no: ,
          *  inst_time: ,
          *  prnts_phone_no: ,
          *  myapp: }
          *
          * */

// ARS 인증 응답 모델
@freezed
class ArsAuthResponse with _$ArsAuthResponse {
  const factory ArsAuthResponse({
    required String appsid,
    required String appuuid,
    required String appip,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'return') required bool returnValue,
    required String now,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'call_count') @Default(0) int callCount,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'app_cid') required String appCid,
    required String msg,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'inst_phone_no') String? instPhoneNo,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'inst_time') String? instTime,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'prnts_phone_no') String? prntsPhoneNo,
    String? myapp,
  }) = _ArsAuthResponse;

  factory ArsAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$ArsAuthResponseFromJson(json);
}

// 권한 상태 모델
@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    @Default(false) bool isPermissionGranted,
    @Default({}) Set<PermissionType> grantedPermissions,
    @Default({}) Set<PermissionType> deniedPermissions,
  }) = _PermissionState;

  factory PermissionState.fromJson(Map<String, dynamic> json) =>
      _$PermissionStateFromJson(json);
}
