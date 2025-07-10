// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginState _$LoginStateFromJson(Map<String, dynamic> json) {
  return _LoginState.fromJson(json);
}

/// @nodoc
mixin _$LoginState {
  AuthStatus get status => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get allTermsAccepted => throw _privateConstructorUsedError;
  bool get ageConfirmed => throw _privateConstructorUsedError;
  bool get serviceTermsAccepted => throw _privateConstructorUsedError;
  bool get privacyTermsAccepted => throw _privateConstructorUsedError;
  bool get pushNotificationAccepted => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this LoginState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginStateCopyWith<LoginState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
          LoginState value, $Res Function(LoginState) then) =
      _$LoginStateCopyWithImpl<$Res, LoginState>;
  @useResult
  $Res call(
      {AuthStatus status,
      bool isLoading,
      bool allTermsAccepted,
      bool ageConfirmed,
      bool serviceTermsAccepted,
      bool privacyTermsAccepted,
      bool pushNotificationAccepted,
      String? errorMessage});
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res, $Val extends LoginState>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? allTermsAccepted = null,
    Object? ageConfirmed = null,
    Object? serviceTermsAccepted = null,
    Object? privacyTermsAccepted = null,
    Object? pushNotificationAccepted = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      allTermsAccepted: null == allTermsAccepted
          ? _value.allTermsAccepted
          : allTermsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      ageConfirmed: null == ageConfirmed
          ? _value.ageConfirmed
          : ageConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceTermsAccepted: null == serviceTermsAccepted
          ? _value.serviceTermsAccepted
          : serviceTermsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      privacyTermsAccepted: null == privacyTermsAccepted
          ? _value.privacyTermsAccepted
          : privacyTermsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotificationAccepted: null == pushNotificationAccepted
          ? _value.pushNotificationAccepted
          : pushNotificationAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginStateImplCopyWith<$Res>
    implements $LoginStateCopyWith<$Res> {
  factory _$$LoginStateImplCopyWith(
          _$LoginStateImpl value, $Res Function(_$LoginStateImpl) then) =
      __$$LoginStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthStatus status,
      bool isLoading,
      bool allTermsAccepted,
      bool ageConfirmed,
      bool serviceTermsAccepted,
      bool privacyTermsAccepted,
      bool pushNotificationAccepted,
      String? errorMessage});
}

/// @nodoc
class __$$LoginStateImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginStateImpl>
    implements _$$LoginStateImplCopyWith<$Res> {
  __$$LoginStateImplCopyWithImpl(
      _$LoginStateImpl _value, $Res Function(_$LoginStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? allTermsAccepted = null,
    Object? ageConfirmed = null,
    Object? serviceTermsAccepted = null,
    Object? privacyTermsAccepted = null,
    Object? pushNotificationAccepted = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$LoginStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      allTermsAccepted: null == allTermsAccepted
          ? _value.allTermsAccepted
          : allTermsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      ageConfirmed: null == ageConfirmed
          ? _value.ageConfirmed
          : ageConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceTermsAccepted: null == serviceTermsAccepted
          ? _value.serviceTermsAccepted
          : serviceTermsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      privacyTermsAccepted: null == privacyTermsAccepted
          ? _value.privacyTermsAccepted
          : privacyTermsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotificationAccepted: null == pushNotificationAccepted
          ? _value.pushNotificationAccepted
          : pushNotificationAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginStateImpl implements _LoginState {
  const _$LoginStateImpl(
      {this.status = AuthStatus.initial,
      this.isLoading = false,
      this.allTermsAccepted = false,
      this.ageConfirmed = false,
      this.serviceTermsAccepted = false,
      this.privacyTermsAccepted = false,
      this.pushNotificationAccepted = false,
      this.errorMessage});

  factory _$LoginStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginStateImplFromJson(json);

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool allTermsAccepted;
  @override
  @JsonKey()
  final bool ageConfirmed;
  @override
  @JsonKey()
  final bool serviceTermsAccepted;
  @override
  @JsonKey()
  final bool privacyTermsAccepted;
  @override
  @JsonKey()
  final bool pushNotificationAccepted;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'LoginState(status: $status, isLoading: $isLoading, allTermsAccepted: $allTermsAccepted, ageConfirmed: $ageConfirmed, serviceTermsAccepted: $serviceTermsAccepted, privacyTermsAccepted: $privacyTermsAccepted, pushNotificationAccepted: $pushNotificationAccepted, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.allTermsAccepted, allTermsAccepted) ||
                other.allTermsAccepted == allTermsAccepted) &&
            (identical(other.ageConfirmed, ageConfirmed) ||
                other.ageConfirmed == ageConfirmed) &&
            (identical(other.serviceTermsAccepted, serviceTermsAccepted) ||
                other.serviceTermsAccepted == serviceTermsAccepted) &&
            (identical(other.privacyTermsAccepted, privacyTermsAccepted) ||
                other.privacyTermsAccepted == privacyTermsAccepted) &&
            (identical(
                    other.pushNotificationAccepted, pushNotificationAccepted) ||
                other.pushNotificationAccepted == pushNotificationAccepted) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      isLoading,
      allTermsAccepted,
      ageConfirmed,
      serviceTermsAccepted,
      privacyTermsAccepted,
      pushNotificationAccepted,
      errorMessage);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginStateImplCopyWith<_$LoginStateImpl> get copyWith =>
      __$$LoginStateImplCopyWithImpl<_$LoginStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginStateImplToJson(
      this,
    );
  }
}

abstract class _LoginState implements LoginState {
  const factory _LoginState(
      {final AuthStatus status,
      final bool isLoading,
      final bool allTermsAccepted,
      final bool ageConfirmed,
      final bool serviceTermsAccepted,
      final bool privacyTermsAccepted,
      final bool pushNotificationAccepted,
      final String? errorMessage}) = _$LoginStateImpl;

  factory _LoginState.fromJson(Map<String, dynamic> json) =
      _$LoginStateImpl.fromJson;

  @override
  AuthStatus get status;
  @override
  bool get isLoading;
  @override
  bool get allTermsAccepted;
  @override
  bool get ageConfirmed;
  @override
  bool get serviceTermsAccepted;
  @override
  bool get privacyTermsAccepted;
  @override
  bool get pushNotificationAccepted;
  @override
  String? get errorMessage;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginStateImplCopyWith<_$LoginStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ArsAuthResponse _$ArsAuthResponseFromJson(Map<String, dynamic> json) {
  return _ArsAuthResponse.fromJson(json);
}

/// @nodoc
mixin _$ArsAuthResponse {
  String get appsid => throw _privateConstructorUsedError;
  String get appuuid => throw _privateConstructorUsedError;
  String get appip =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'return')
  bool get returnValue => throw _privateConstructorUsedError;
  String get now =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'call_count')
  int get callCount =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'app_cid')
  String get appCid => throw _privateConstructorUsedError;
  String get msg =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'inst_phone_no')
  String? get instPhoneNo =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'inst_time')
  String? get instTime =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'prnts_phone_no')
  String? get prntsPhoneNo => throw _privateConstructorUsedError;
  String? get myapp => throw _privateConstructorUsedError;

  /// Serializes this ArsAuthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArsAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArsAuthResponseCopyWith<ArsAuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArsAuthResponseCopyWith<$Res> {
  factory $ArsAuthResponseCopyWith(
          ArsAuthResponse value, $Res Function(ArsAuthResponse) then) =
      _$ArsAuthResponseCopyWithImpl<$Res, ArsAuthResponse>;
  @useResult
  $Res call(
      {String appsid,
      String appuuid,
      String appip,
      @JsonKey(name: 'return') bool returnValue,
      String now,
      @JsonKey(name: 'call_count') int callCount,
      @JsonKey(name: 'app_cid') String appCid,
      String msg,
      @JsonKey(name: 'inst_phone_no') String? instPhoneNo,
      @JsonKey(name: 'inst_time') String? instTime,
      @JsonKey(name: 'prnts_phone_no') String? prntsPhoneNo,
      String? myapp});
}

/// @nodoc
class _$ArsAuthResponseCopyWithImpl<$Res, $Val extends ArsAuthResponse>
    implements $ArsAuthResponseCopyWith<$Res> {
  _$ArsAuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArsAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appsid = null,
    Object? appuuid = null,
    Object? appip = null,
    Object? returnValue = null,
    Object? now = null,
    Object? callCount = null,
    Object? appCid = null,
    Object? msg = null,
    Object? instPhoneNo = freezed,
    Object? instTime = freezed,
    Object? prntsPhoneNo = freezed,
    Object? myapp = freezed,
  }) {
    return _then(_value.copyWith(
      appsid: null == appsid
          ? _value.appsid
          : appsid // ignore: cast_nullable_to_non_nullable
              as String,
      appuuid: null == appuuid
          ? _value.appuuid
          : appuuid // ignore: cast_nullable_to_non_nullable
              as String,
      appip: null == appip
          ? _value.appip
          : appip // ignore: cast_nullable_to_non_nullable
              as String,
      returnValue: null == returnValue
          ? _value.returnValue
          : returnValue // ignore: cast_nullable_to_non_nullable
              as bool,
      now: null == now
          ? _value.now
          : now // ignore: cast_nullable_to_non_nullable
              as String,
      callCount: null == callCount
          ? _value.callCount
          : callCount // ignore: cast_nullable_to_non_nullable
              as int,
      appCid: null == appCid
          ? _value.appCid
          : appCid // ignore: cast_nullable_to_non_nullable
              as String,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      instPhoneNo: freezed == instPhoneNo
          ? _value.instPhoneNo
          : instPhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      instTime: freezed == instTime
          ? _value.instTime
          : instTime // ignore: cast_nullable_to_non_nullable
              as String?,
      prntsPhoneNo: freezed == prntsPhoneNo
          ? _value.prntsPhoneNo
          : prntsPhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      myapp: freezed == myapp
          ? _value.myapp
          : myapp // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArsAuthResponseImplCopyWith<$Res>
    implements $ArsAuthResponseCopyWith<$Res> {
  factory _$$ArsAuthResponseImplCopyWith(_$ArsAuthResponseImpl value,
          $Res Function(_$ArsAuthResponseImpl) then) =
      __$$ArsAuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String appsid,
      String appuuid,
      String appip,
      @JsonKey(name: 'return') bool returnValue,
      String now,
      @JsonKey(name: 'call_count') int callCount,
      @JsonKey(name: 'app_cid') String appCid,
      String msg,
      @JsonKey(name: 'inst_phone_no') String? instPhoneNo,
      @JsonKey(name: 'inst_time') String? instTime,
      @JsonKey(name: 'prnts_phone_no') String? prntsPhoneNo,
      String? myapp});
}

/// @nodoc
class __$$ArsAuthResponseImplCopyWithImpl<$Res>
    extends _$ArsAuthResponseCopyWithImpl<$Res, _$ArsAuthResponseImpl>
    implements _$$ArsAuthResponseImplCopyWith<$Res> {
  __$$ArsAuthResponseImplCopyWithImpl(
      _$ArsAuthResponseImpl _value, $Res Function(_$ArsAuthResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArsAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appsid = null,
    Object? appuuid = null,
    Object? appip = null,
    Object? returnValue = null,
    Object? now = null,
    Object? callCount = null,
    Object? appCid = null,
    Object? msg = null,
    Object? instPhoneNo = freezed,
    Object? instTime = freezed,
    Object? prntsPhoneNo = freezed,
    Object? myapp = freezed,
  }) {
    return _then(_$ArsAuthResponseImpl(
      appsid: null == appsid
          ? _value.appsid
          : appsid // ignore: cast_nullable_to_non_nullable
              as String,
      appuuid: null == appuuid
          ? _value.appuuid
          : appuuid // ignore: cast_nullable_to_non_nullable
              as String,
      appip: null == appip
          ? _value.appip
          : appip // ignore: cast_nullable_to_non_nullable
              as String,
      returnValue: null == returnValue
          ? _value.returnValue
          : returnValue // ignore: cast_nullable_to_non_nullable
              as bool,
      now: null == now
          ? _value.now
          : now // ignore: cast_nullable_to_non_nullable
              as String,
      callCount: null == callCount
          ? _value.callCount
          : callCount // ignore: cast_nullable_to_non_nullable
              as int,
      appCid: null == appCid
          ? _value.appCid
          : appCid // ignore: cast_nullable_to_non_nullable
              as String,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      instPhoneNo: freezed == instPhoneNo
          ? _value.instPhoneNo
          : instPhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      instTime: freezed == instTime
          ? _value.instTime
          : instTime // ignore: cast_nullable_to_non_nullable
              as String?,
      prntsPhoneNo: freezed == prntsPhoneNo
          ? _value.prntsPhoneNo
          : prntsPhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      myapp: freezed == myapp
          ? _value.myapp
          : myapp // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArsAuthResponseImpl implements _ArsAuthResponse {
  const _$ArsAuthResponseImpl(
      {required this.appsid,
      required this.appuuid,
      required this.appip,
      @JsonKey(name: 'return') required this.returnValue,
      required this.now,
      @JsonKey(name: 'call_count') this.callCount = 0,
      @JsonKey(name: 'app_cid') required this.appCid,
      required this.msg,
      @JsonKey(name: 'inst_phone_no') this.instPhoneNo,
      @JsonKey(name: 'inst_time') this.instTime,
      @JsonKey(name: 'prnts_phone_no') this.prntsPhoneNo,
      this.myapp});

  factory _$ArsAuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArsAuthResponseImplFromJson(json);

  @override
  final String appsid;
  @override
  final String appuuid;
  @override
  final String appip;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'return')
  final bool returnValue;
  @override
  final String now;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'call_count')
  final int callCount;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'app_cid')
  final String appCid;
  @override
  final String msg;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'inst_phone_no')
  final String? instPhoneNo;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'inst_time')
  final String? instTime;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'prnts_phone_no')
  final String? prntsPhoneNo;
  @override
  final String? myapp;

  @override
  String toString() {
    return 'ArsAuthResponse(appsid: $appsid, appuuid: $appuuid, appip: $appip, returnValue: $returnValue, now: $now, callCount: $callCount, appCid: $appCid, msg: $msg, instPhoneNo: $instPhoneNo, instTime: $instTime, prntsPhoneNo: $prntsPhoneNo, myapp: $myapp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArsAuthResponseImpl &&
            (identical(other.appsid, appsid) || other.appsid == appsid) &&
            (identical(other.appuuid, appuuid) || other.appuuid == appuuid) &&
            (identical(other.appip, appip) || other.appip == appip) &&
            (identical(other.returnValue, returnValue) ||
                other.returnValue == returnValue) &&
            (identical(other.now, now) || other.now == now) &&
            (identical(other.callCount, callCount) ||
                other.callCount == callCount) &&
            (identical(other.appCid, appCid) || other.appCid == appCid) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.instPhoneNo, instPhoneNo) ||
                other.instPhoneNo == instPhoneNo) &&
            (identical(other.instTime, instTime) ||
                other.instTime == instTime) &&
            (identical(other.prntsPhoneNo, prntsPhoneNo) ||
                other.prntsPhoneNo == prntsPhoneNo) &&
            (identical(other.myapp, myapp) || other.myapp == myapp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appsid,
      appuuid,
      appip,
      returnValue,
      now,
      callCount,
      appCid,
      msg,
      instPhoneNo,
      instTime,
      prntsPhoneNo,
      myapp);

  /// Create a copy of ArsAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArsAuthResponseImplCopyWith<_$ArsAuthResponseImpl> get copyWith =>
      __$$ArsAuthResponseImplCopyWithImpl<_$ArsAuthResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArsAuthResponseImplToJson(
      this,
    );
  }
}

abstract class _ArsAuthResponse implements ArsAuthResponse {
  const factory _ArsAuthResponse(
      {required final String appsid,
      required final String appuuid,
      required final String appip,
      @JsonKey(name: 'return') required final bool returnValue,
      required final String now,
      @JsonKey(name: 'call_count') final int callCount,
      @JsonKey(name: 'app_cid') required final String appCid,
      required final String msg,
      @JsonKey(name: 'inst_phone_no') final String? instPhoneNo,
      @JsonKey(name: 'inst_time') final String? instTime,
      @JsonKey(name: 'prnts_phone_no') final String? prntsPhoneNo,
      final String? myapp}) = _$ArsAuthResponseImpl;

  factory _ArsAuthResponse.fromJson(Map<String, dynamic> json) =
      _$ArsAuthResponseImpl.fromJson;

  @override
  String get appsid;
  @override
  String get appuuid;
  @override
  String get appip; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'return')
  bool get returnValue;
  @override
  String get now; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'call_count')
  int get callCount; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'app_cid')
  String get appCid;
  @override
  String get msg; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'inst_phone_no')
  String? get instPhoneNo; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'inst_time')
  String? get instTime; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'prnts_phone_no')
  String? get prntsPhoneNo;
  @override
  String? get myapp;

  /// Create a copy of ArsAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArsAuthResponseImplCopyWith<_$ArsAuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PermissionState _$PermissionStateFromJson(Map<String, dynamic> json) {
  return _PermissionState.fromJson(json);
}

/// @nodoc
mixin _$PermissionState {
  bool get isPermissionGranted => throw _privateConstructorUsedError;
  Set<PermissionType> get grantedPermissions =>
      throw _privateConstructorUsedError;
  Set<PermissionType> get deniedPermissions =>
      throw _privateConstructorUsedError;

  /// Serializes this PermissionState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionStateCopyWith<PermissionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionStateCopyWith<$Res> {
  factory $PermissionStateCopyWith(
          PermissionState value, $Res Function(PermissionState) then) =
      _$PermissionStateCopyWithImpl<$Res, PermissionState>;
  @useResult
  $Res call(
      {bool isPermissionGranted,
      Set<PermissionType> grantedPermissions,
      Set<PermissionType> deniedPermissions});
}

/// @nodoc
class _$PermissionStateCopyWithImpl<$Res, $Val extends PermissionState>
    implements $PermissionStateCopyWith<$Res> {
  _$PermissionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPermissionGranted = null,
    Object? grantedPermissions = null,
    Object? deniedPermissions = null,
  }) {
    return _then(_value.copyWith(
      isPermissionGranted: null == isPermissionGranted
          ? _value.isPermissionGranted
          : isPermissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
      grantedPermissions: null == grantedPermissions
          ? _value.grantedPermissions
          : grantedPermissions // ignore: cast_nullable_to_non_nullable
              as Set<PermissionType>,
      deniedPermissions: null == deniedPermissions
          ? _value.deniedPermissions
          : deniedPermissions // ignore: cast_nullable_to_non_nullable
              as Set<PermissionType>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionStateImplCopyWith<$Res>
    implements $PermissionStateCopyWith<$Res> {
  factory _$$PermissionStateImplCopyWith(_$PermissionStateImpl value,
          $Res Function(_$PermissionStateImpl) then) =
      __$$PermissionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isPermissionGranted,
      Set<PermissionType> grantedPermissions,
      Set<PermissionType> deniedPermissions});
}

/// @nodoc
class __$$PermissionStateImplCopyWithImpl<$Res>
    extends _$PermissionStateCopyWithImpl<$Res, _$PermissionStateImpl>
    implements _$$PermissionStateImplCopyWith<$Res> {
  __$$PermissionStateImplCopyWithImpl(
      _$PermissionStateImpl _value, $Res Function(_$PermissionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPermissionGranted = null,
    Object? grantedPermissions = null,
    Object? deniedPermissions = null,
  }) {
    return _then(_$PermissionStateImpl(
      isPermissionGranted: null == isPermissionGranted
          ? _value.isPermissionGranted
          : isPermissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
      grantedPermissions: null == grantedPermissions
          ? _value._grantedPermissions
          : grantedPermissions // ignore: cast_nullable_to_non_nullable
              as Set<PermissionType>,
      deniedPermissions: null == deniedPermissions
          ? _value._deniedPermissions
          : deniedPermissions // ignore: cast_nullable_to_non_nullable
              as Set<PermissionType>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionStateImpl implements _PermissionState {
  const _$PermissionStateImpl(
      {this.isPermissionGranted = false,
      final Set<PermissionType> grantedPermissions = const {},
      final Set<PermissionType> deniedPermissions = const {}})
      : _grantedPermissions = grantedPermissions,
        _deniedPermissions = deniedPermissions;

  factory _$PermissionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isPermissionGranted;
  final Set<PermissionType> _grantedPermissions;
  @override
  @JsonKey()
  Set<PermissionType> get grantedPermissions {
    if (_grantedPermissions is EqualUnmodifiableSetView)
      return _grantedPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_grantedPermissions);
  }

  final Set<PermissionType> _deniedPermissions;
  @override
  @JsonKey()
  Set<PermissionType> get deniedPermissions {
    if (_deniedPermissions is EqualUnmodifiableSetView)
      return _deniedPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_deniedPermissions);
  }

  @override
  String toString() {
    return 'PermissionState(isPermissionGranted: $isPermissionGranted, grantedPermissions: $grantedPermissions, deniedPermissions: $deniedPermissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionStateImpl &&
            (identical(other.isPermissionGranted, isPermissionGranted) ||
                other.isPermissionGranted == isPermissionGranted) &&
            const DeepCollectionEquality()
                .equals(other._grantedPermissions, _grantedPermissions) &&
            const DeepCollectionEquality()
                .equals(other._deniedPermissions, _deniedPermissions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isPermissionGranted,
      const DeepCollectionEquality().hash(_grantedPermissions),
      const DeepCollectionEquality().hash(_deniedPermissions));

  /// Create a copy of PermissionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionStateImplCopyWith<_$PermissionStateImpl> get copyWith =>
      __$$PermissionStateImplCopyWithImpl<_$PermissionStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionStateImplToJson(
      this,
    );
  }
}

abstract class _PermissionState implements PermissionState {
  const factory _PermissionState(
      {final bool isPermissionGranted,
      final Set<PermissionType> grantedPermissions,
      final Set<PermissionType> deniedPermissions}) = _$PermissionStateImpl;

  factory _PermissionState.fromJson(Map<String, dynamic> json) =
      _$PermissionStateImpl.fromJson;

  @override
  bool get isPermissionGranted;
  @override
  Set<PermissionType> get grantedPermissions;
  @override
  Set<PermissionType> get deniedPermissions;

  /// Create a copy of PermissionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionStateImplCopyWith<_$PermissionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
