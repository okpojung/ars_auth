import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';
import '../model/login_model.dart';
import '../model/enum_list.dart';

part 'permission_provider.g.dart';

// 권한 관리 Provider
@riverpod
class PermissionNotifier extends _$PermissionNotifier {
  @override
  PermissionState build() {
    return const PermissionState();
  }

  // 모든 권한 요청
  Future<void> requestAllPermissions() async {
    try {
      final permissions = [
        Permission.microphone,
        if (Platform.isAndroid) Permission.phone, // Android에서만 phone 권한 요청
        Permission.contacts,
        Permission.camera,
        Permission.locationWhenInUse,
        Permission.storage,
      ];

      final statuses = await permissions.request();

      final granted = <PermissionType>{};
      final denied = <PermissionType>{};

      // 권한 상태 분석
      if (statuses[Permission.microphone]?.isGranted ?? false) {
        granted.add(PermissionType.microphone);
      } else {
        denied.add(PermissionType.microphone);
      }

      // Android에서만 phone 권한 확인
      if (Platform.isAndroid) {
        if (statuses[Permission.phone]?.isGranted ?? false) {
          granted.add(PermissionType.phone);
        } else {
          denied.add(PermissionType.phone);
        }
      } else {
        // iOS에서는 phone 권한이 자동으로 승인된 것으로 처리
        granted.add(PermissionType.phone);
      }

      if (statuses[Permission.contacts]?.isGranted ?? false) {
        granted.add(PermissionType.contacts);
      } else {
        denied.add(PermissionType.contacts);
      }

      if (statuses[Permission.camera]?.isGranted ?? false) {
        granted.add(PermissionType.camera);
      } else {
        denied.add(PermissionType.camera);
      }

      if (statuses[Permission.locationWhenInUse]?.isGranted ?? false) {
        granted.add(PermissionType.location);
      } else {
        denied.add(PermissionType.location);
      }

      if (statuses[Permission.storage]?.isGranted ?? false) {
        granted.add(PermissionType.storage);
      } else {
        denied.add(PermissionType.storage);
      }

      // 필수 권한들이 모두 승인되었는지 확인
      final essentialPermissions = {
        PermissionType.microphone,
        PermissionType.phone,
      };

      final allEssentialGranted = essentialPermissions.every(granted.contains);

      state = state.copyWith(
        isPermissionGranted: allEssentialGranted,
        grantedPermissions: granted,
        deniedPermissions: denied,
      );
    } catch (e) {
      // 권한 요청 실패 시 처리
      state = state.copyWith(
        isPermissionGranted: false,
        grantedPermissions: {},
        deniedPermissions: PermissionType.values.toSet(),
      );
    }
  }

  // 전화 권한만 요청 (Only Call Permission)
  Future<void> requestOnlyCallPermission() async {
    try {
      final granted = <PermissionType>{};
      final denied = <PermissionType>{};

      if (Platform.isIOS) {
        // iOS에서는 전화 권한이 필요하지 않으므로 바로 승인 처리
        granted.add(PermissionType.phone);

        state = state.copyWith(
          isPermissionGranted: true,
          grantedPermissions: granted,
          deniedPermissions: denied,
        );
        return;
      }

      // Android에서만 전화 권한 요청
      final phonePermissionStatus = await Permission.phone.request();

      if (phonePermissionStatus.isGranted) {
        granted.add(PermissionType.phone);
      } else {
        denied.add(PermissionType.phone);
      }

      state = state.copyWith(
        isPermissionGranted: phonePermissionStatus.isGranted,
        grantedPermissions: granted,
        deniedPermissions: denied,
      );
    } catch (e) {
      // 권한 요청 실패 시 처리
      state = state.copyWith(
        isPermissionGranted: false,
        grantedPermissions: {},
        deniedPermissions: {PermissionType.phone},
      );
    }
  }

  // 개별 권한 상태 확인
  Future<bool> checkPermission(PermissionType permissionType) async {
    // iOS에서 phone 권한은 항상 true 반환
    if (Platform.isIOS && permissionType == PermissionType.phone) {
      return true;
    }

    Permission permission;

    switch (permissionType) {
      case PermissionType.microphone:
        permission = Permission.microphone;
        break;
      case PermissionType.phone:
        permission = Permission.phone;
        break;
      case PermissionType.contacts:
        permission = Permission.contacts;
        break;
      case PermissionType.camera:
        permission = Permission.camera;
        break;
      case PermissionType.location:
        permission = Permission.locationWhenInUse;
        break;
      case PermissionType.storage:
        permission = Permission.storage;
        break;
    }

    return await permission.isGranted;
  }

  // 권한 상태 새로고침
  Future<void> refreshPermissionStatus() async {
    final granted = <PermissionType>{};
    final denied = <PermissionType>{};

    for (final permissionType in PermissionType.values) {
      final isGranted = await checkPermission(permissionType);
      if (isGranted) {
        granted.add(permissionType);
      } else {
        denied.add(permissionType);
      }
    }

    // 필수 권한들이 모두 승인되었는지 확인
    final essentialPermissions = {
      PermissionType.microphone,
      PermissionType.phone,
    };

    final allEssentialGranted = essentialPermissions.every(granted.contains);

    state = state.copyWith(
      isPermissionGranted: allEssentialGranted,
      grantedPermissions: granted,
      deniedPermissions: denied,
    );
  }

  // 권한 설정 화면으로 이동
  Future<void> openSettings() async {
    await openAppSettings();
  }

  // 상태 초기화
  void reset() {
    state = const PermissionState();
  }
}

// 실시간 권한 상태 확인 Provider
@riverpod
Future<bool> isPermissionGranted(Ref ref) async {
  // 필수 권한들을 실시간으로 확인
  final microphoneGranted = await Permission.microphone.isGranted;

  // iOS에서는 phone 권한이 필요하지 않으므로 true로 처리
  final phoneGranted = Platform.isIOS ? true : await Permission.phone.isGranted;

  return microphoneGranted && phoneGranted;
}
