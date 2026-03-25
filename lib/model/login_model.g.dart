// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginStateImpl _$$LoginStateImplFromJson(Map<String, dynamic> json) =>
    _$LoginStateImpl(
      status: $enumDecodeNullable(_$AuthStatusEnumMap, json['status']) ??
          AuthStatus.initial,
      isLoading: json['isLoading'] as bool? ?? false,
      allTermsAccepted: json['allTermsAccepted'] as bool? ?? false,
      ageConfirmed: json['ageConfirmed'] as bool? ?? false,
      serviceTermsAccepted: json['serviceTermsAccepted'] as bool? ?? false,
      privacyTermsAccepted: json['privacyTermsAccepted'] as bool? ?? false,
      pushNotificationAccepted:
          json['pushNotificationAccepted'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$LoginStateImplToJson(_$LoginStateImpl instance) =>
    <String, dynamic>{
      'status': _$AuthStatusEnumMap[instance.status]!,
      'isLoading': instance.isLoading,
      'allTermsAccepted': instance.allTermsAccepted,
      'ageConfirmed': instance.ageConfirmed,
      'serviceTermsAccepted': instance.serviceTermsAccepted,
      'privacyTermsAccepted': instance.privacyTermsAccepted,
      'pushNotificationAccepted': instance.pushNotificationAccepted,
      'errorMessage': instance.errorMessage,
    };

const _$AuthStatusEnumMap = {
  AuthStatus.initial: 'initial',
  AuthStatus.loading: 'loading',
  AuthStatus.waitingForAppReturn: 'waitingForAppReturn',
  AuthStatus.confirming: 'confirming',
  AuthStatus.manualInputRequired: 'manualInputRequired',
  AuthStatus.success: 'success',
  AuthStatus.failure: 'failure',
};

_$ArsAuthResponseImpl _$$ArsAuthResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ArsAuthResponseImpl(
      appsid: json['appsid'] as String,
      appuuid: json['appuuid'] as String,
      appip: json['appip'] as String,
      returnValue: json['return'] as bool,
      now: json['now'] as String,
      callCount: (json['call_count'] as num?)?.toInt() ?? 0,
      appCid: json['app_cid'] as String,
      msg: json['msg'] as String,
      instPhoneNo: json['inst_phone_no'] as String?,
      instTime: json['inst_time'] as String?,
      prntsPhoneNo: json['prnts_phone_no'] as String?,
      myapp: json['myapp'] as String?,
    );

Map<String, dynamic> _$$ArsAuthResponseImplToJson(
        _$ArsAuthResponseImpl instance) =>
    <String, dynamic>{
      'appsid': instance.appsid,
      'appuuid': instance.appuuid,
      'appip': instance.appip,
      'return': instance.returnValue,
      'now': instance.now,
      'call_count': instance.callCount,
      'app_cid': instance.appCid,
      'msg': instance.msg,
      'inst_phone_no': instance.instPhoneNo,
      'inst_time': instance.instTime,
      'prnts_phone_no': instance.prntsPhoneNo,
      'myapp': instance.myapp,
    };

_$PermissionStateImpl _$$PermissionStateImplFromJson(
        Map<String, dynamic> json) =>
    _$PermissionStateImpl(
      isPermissionGranted: json['isPermissionGranted'] as bool? ?? false,
      grantedPermissions: (json['grantedPermissions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$PermissionTypeEnumMap, e))
              .toSet() ??
          const <PermissionType>{},
      deniedPermissions: (json['deniedPermissions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$PermissionTypeEnumMap, e))
              .toSet() ??
          const <PermissionType>{},
    );

Map<String, dynamic> _$$PermissionStateImplToJson(
        _$PermissionStateImpl instance) =>
    <String, dynamic>{
      'isPermissionGranted': instance.isPermissionGranted,
      'grantedPermissions': instance.grantedPermissions
          .map((e) => _$PermissionTypeEnumMap[e]!)
          .toList(),
      'deniedPermissions': instance.deniedPermissions
          .map((e) => _$PermissionTypeEnumMap[e]!)
          .toList(),
    };

const _$PermissionTypeEnumMap = {
  PermissionType.microphone: 'microphone',
  PermissionType.phone: 'phone',
  PermissionType.contacts: 'contacts',
  PermissionType.camera: 'camera',
  PermissionType.location: 'location',
  PermissionType.storage: 'storage',
};
