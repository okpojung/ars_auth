import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
        Permission.phone,
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

      if (statuses[Permission.phone]?.isGranted ?? false) {
        granted.add(PermissionType.phone);
      } else {
        denied.add(PermissionType.phone);
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

  // 개별 권한 상태 확인
  Future<bool> checkPermission(PermissionType permissionType) async {
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
  final phoneGranted = await Permission.phone.isGranted;

  return microphoneGranted && phoneGranted;
}
