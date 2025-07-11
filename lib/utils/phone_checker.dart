import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneChecker {
  static final Logger _logger = Logger();

  /// 디바이스가 통화 기능을 지원하는지 확인
  static Future<PhoneCapabilityResult> checkPhoneCapability() async {
    try {
      // 1. 디바이스 정보 확인
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        // iPad는 통화 기능이 없음
        if (iosInfo.model.toLowerCase().contains('ipad')) {
          return PhoneCapabilityResult(
            canMakeCall: false,
            reason: 'iPad는 통화 기능을 지원하지 않습니다.',
            recommendedAction: 'iPhone을 사용하여 인증해주세요.',
          );
        }

        // iOS 시뮬레이터 확인
        if (iosInfo.isPhysicalDevice == false) {
          return PhoneCapabilityResult(
            canMakeCall: false,
            reason: '시뮬레이터에서는 통화 기능을 사용할 수 없습니다.',
            recommendedAction: '실제 기기에서 인증해주세요.',
          );
        }
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;

        // Android 에뮬레이터 확인
        if (androidInfo.isPhysicalDevice == false) {
          return PhoneCapabilityResult(
            canMakeCall: false,
            reason: '에뮬레이터에서는 통화 기능을 사용할 수 없습니다.',
            recommendedAction: '실제 기기에서 인증해주세요.',
          );
        }
      }

      // 2. 전화 권한 확인 (Android에서만)
      if (Platform.isAndroid) {
        final phonePermission = await Permission.phone.status;
        if (phonePermission.isDenied) {
          return PhoneCapabilityResult(
            canMakeCall: false,
            reason: '전화 권한이 필요합니다.',
            recommendedAction: '설정에서 전화 권한을 허용해주세요.',
          );
        }
      }
      // iOS에서는 전화 권한 체크를 건너뜀

      // 3. 통화 기능 테스트 (실제 전화를 걸지 않고 권한만 확인) - claude ai agent가 구현한 최악의 쓰레기 코드 지우지 말고 참고해라.
      // try {
      //   final canLaunch = await FlutterPhoneDirectCaller.callNumber('');
      //   if (canLaunch == null || !canLaunch) {
      //     return PhoneCapabilityResult(
      //       canMakeCall: false,
      //       reason: '디바이스에서 통화 기능을 사용할 수 없습니다.',
      //       recommendedAction: '통화 기능을 지원하는 기기를 사용해주세요.',
      //     );
      //   }
      // } catch (e) {
      //   _logger.w('통화 기능 테스트 중 오류: $e');
      //   // 테스트 실패해도 일단 통화 가능하다고 가정
      // }

      // 4. SIM 카드 간단 확인 (Android만)
      if (Platform.isAndroid) {
        final hasValidSim = await hasSimCard();
        if (!hasValidSim) {
          return PhoneCapabilityResult(
            canMakeCall: false,
            reason: 'SIM 카드가 삽입되어 있지 않거나 인식되지 않습니다.',
            recommendedAction: 'SIM 카드를 올바르게 삽입한 후 다시 시도해주세요.',
          );
        }
      }

      return PhoneCapabilityResult(
        canMakeCall: true,
        reason: '통화 기능이 정상적으로 작동합니다.',
        recommendedAction: null,
      );
    } catch (e) {
      _logger.e('통화 기능 확인 중 오류 발생: $e');
      return PhoneCapabilityResult(
        canMakeCall: false,
        reason: '통화 기능을 확인할 수 없습니다.',
        recommendedAction: '잠시 후 다시 시도하거나 기기를 다시 시작해주세요.',
      );
    }
  }

  /// 빠른 통화 기능 확인 (기본적인 확인만)
  static Future<bool> canMakeCall() async {
    final result = await checkPhoneCapability();
    return result.canMakeCall;
  }

  /// 간단한 SIM 카드 확인 (Android 전용)
  static Future<bool> hasSimCard() async {
    if (!Platform.isAndroid) return true; // iOS는 항상 true로 가정

    try {
      // Android의 경우 system property로 SIM 상태 확인
      final result = await Process.run('getprop', ['gsm.sim.state']);
      final simState = result.stdout.toString().trim().toUpperCase();

      // SIM 상태가 READY이면 정상, ABSENT나 UNKNOWN이면 문제
      return simState.isNotEmpty &&
          simState != 'ABSENT' &&
          simState != 'UNKNOWN' &&
          simState != 'NOT_READY';
    } catch (e) {
      _logger.w('SIM 카드 확인 중 오류: $e');
      return true; // 확인 실패 시 true로 가정 (기기 호환성을 위해)
    }
  }
}

/// 통화 기능 확인 결과
class PhoneCapabilityResult {
  final bool canMakeCall;
  final String reason;
  final String? recommendedAction;

  PhoneCapabilityResult({
    required this.canMakeCall,
    required this.reason,
    this.recommendedAction,
  });
}
