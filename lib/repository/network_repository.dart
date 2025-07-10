import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:logger/logger.dart';
import 'package:phone_state/phone_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/login_model.dart';
import '../res/constants.dart';
import 'hive_repository.dart';

part 'network_repository.g.dart';

// 네트워크 통신을 담당하는 Repository
@riverpod
class NetworkRepository extends _$NetworkRepository {
  final Logger _logger = Logger();
  late final Dio _dio;

  @override
  Future<void> build() async {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    };
  }

  // ARS 인증 설치 요청
  Future<dynamic> requestArsInstall() async {
    try {
      // 고유 앱 세션 ID 생성
      final now = DateTime.now().microsecondsSinceEpoch;
      final bytes = utf8.encode(now.toString());
      final digest = sha512.convert(bytes);
      final appsid = digest.toString();

      // 디바이스 정보 수집
      final deviceInfo = DeviceInfoPlugin();
      String osVersion = '';

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        osVersion = iosInfo.systemVersion;
      } else {
        final androidInfo = await deviceInfo.androidInfo;
        osVersion = androidInfo.version.release;
      }

      final params = <String, dynamic>{
        'appsid': appsid,
        'app_os_type': Platform.isAndroid ? 'AND' : 'iOS',
        'app_os_version': osVersion,
        'app_cp_carr': '', // 통신사 정보는 정책상 deprecated
        'gcmid': 'deprecated',
        'playerid': 'deprecated',
      };

      _logger.i('[ars] ARS Install Params: $params');

      final url =
          Platform.isIOS
              ? AppConstants.hoServerInstallIOS
              : AppConstants.hoServerInstallAndroid;

      final formData = FormData.fromMap(params);
      final response = await _dio.post(url, data: formData);
      _logger.i('[ars] ARS Install response: ${response.data}');
      _logger.i(
        'ARS Install Response: ${response.data}, ${response.statusCode}, ${response.headers}',
      );
      final responseData = response.data;
      final jsonData = jsonDecode(responseData);

      if (response.statusCode == 200 && jsonData['return'] == true) {
        return jsonData;
      } else {
        throw Exception('ARS 설치 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('ARS Install Error: $e');
      rethrow;
    }
  }

  // ARS 인증 확인 요청
  Future<ArsAuthResponse> requestArsConfirm(dynamic installData) async {
    try {
      final params = {
        'appuuid': installData['appuuid'],
        'appsid': installData['appsid'],
        'applng': '0',
        'applat': '0',
      };

      _logger.i('[ars] ARS Confirm Params: $params');

      final url =
          Platform.isIOS
              ? AppConstants.hoServerConfirmIOS
              : AppConstants.hoServerConfirmAndroid;

      final formData = FormData.fromMap(params);
      _logger.i('ARS Confirm FormData: $formData');
      final response = await _dio.post(url, data: formData);
      _logger.i('[ars] ARS Confirm response: ${response.data}');
      _logger.i(
        'ARS Confirm Response: ${response.data}, ${response.statusCode}, ${response.headers}',
      );

      if (response.statusCode == 200) {
        // API 응답 데이터 안전성 검증 및 기본값 설정
        Map<String, dynamic> responseData;

        // 응답 데이터가 문자열인 경우 JSON 파싱
        if (response.data is String) {
          responseData = jsonDecode(response.data) as Map<String, dynamic>;
        } else {
          responseData = response.data as Map<String, dynamic>;
        }

        // required 필드에 대한 안전장치
        final safeResponseData = {
          'return': responseData['return'] ?? false,
          'call_count': responseData['call_count'] ?? 0,
          'appuuid': responseData['appuuid'] ?? '',
          'appsid': responseData['appsid'] ?? '',
          'appip': responseData['appip'] ?? '',
          'now': responseData['now'] ?? DateTime.now().toString(),
          'app_cid': responseData['app_cid'] ?? '',
          'msg': responseData['msg'] ?? '',
          // optional 필드들
          'prnts_phone_no': responseData['prnts_phone_no'],
          'inst_phone_no': responseData['inst_phone_no'],
          'inst_time': responseData['inst_time'],
          'myapp': responseData['myapp'],
        };

        return ArsAuthResponse.fromJson(safeResponseData);
      } else {
        throw Exception('ARS 인증 확인 실패: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('ARS Confirm Error: $e');
      rethrow;
    }
  }

  // ARS 인증 프로세스 실행 (앱 라이프사이클 기반)
  Future<ArsAuthResponse> executeArsAuthenticationWithLifecycle(
    HiveRepository hiveRepository,
    Function(dynamic installData) onPhoneCallCompleted,
  ) async {
    try {
      // 1. ARS 설치 요청
      final installJson = await requestArsInstall();

      // 2. 전화 걸기
      final phoneNumber = installJson['phonenum'].toString().substring(1);
      final phoneCall = 'tel:+$phoneNumber';


      // final phoneNumber1 = installJson['phonenum']
      //     .replaceFirst('+82', '0')
      //     .replaceAll('-', '');

      _logger.i('phoneCall: $phoneCall');

      await FlutterPhoneDirectCaller.callNumber(phoneCall);

      // 3. 전화 상태 모니터링
      await _monitorPhoneState();

      _logger.i('통화 종료 감지. 앱 라이프사이클 모니터링 시작...');

      // 4. 콜백을 통해 앱 라이프사이클에서 confirm API 호출하도록 함
      onPhoneCallCompleted(installJson);

      // 임시로 빈 응답 반환 (실제 응답은 콜백에서 처리)
      return ArsAuthResponse.fromJson({
        'return': true,
        'call_count': 0,
        'appuuid': installJson['appuuid'] ?? '',
        'appsid': installJson['appsid'] ?? '',
        'appip': installJson['appip'] ?? '',
        'now': installJson['now'] ?? DateTime.now().toString(),
        'app_cid': '',
        'msg': 'waiting_for_app_return',
        'prnts_phone_no': null,
        'inst_phone_no': null,
        'inst_time': null,
        'myapp': null,
      });
    } catch (e) {
      _logger.e('ARS Authentication Error: $e');
      rethrow;
    }
  }

  // Confirm API 호출 (별도 메서드)
  Future<ArsAuthResponse> executeConfirmAuthentication(
    dynamic installData,
    HiveRepository hiveRepository,
  ) async {
    try {
      _logger.i('Confirm API 호출 시작...');

      // 인증 확인
      final confirmData = await requestArsConfirm(installData);

      // 인증 결과 저장
      if (confirmData.callCount == 1) {
        await hiveRepository.saveUserData({
          'appuuid': confirmData.appuuid,
          'appsid': confirmData.appsid,
          'prnts_phone_no': confirmData.prntsPhoneNo,
          'app_cid': confirmData.appCid,
          'isLogged': true,
        });
      } else if (confirmData.callCount == 2) {
        //ars 수동인증 프로세스 실행
      } else if (confirmData.callCount == 0) {
        //ars 재인증 프로세스 실행
      }

      return confirmData;
    } catch (e) {
      _logger.e('Confirm Authentication Error: $e');
      rethrow;
    }
  }

  // 전화 상태 모니터링
  Future<void> _monitorPhoneState() async {
    final completer = Completer<void>();

    late StreamSubscription subscription;
    subscription = PhoneState.stream.listen((event) {
      _logger.i('Phone State: $event');
      if (event.status == PhoneStateStatus.CALL_ENDED) {
        subscription.cancel();
        completer.complete();
      }
    });

    return completer.future;
  }

  // 수동 인증 확인 요청
  Future<ArsAuthResponse> requestManualConfirm(
    String phoneNumber,
    String appuuid,
  ) async {
    try {
      final params = {'appphone': phoneNumber, 'appuuid': appuuid};

      _logger.i('[ars] Manual Confirm Params: $params');

      final url =
          Platform.isIOS
              ? AppConstants.hoServerConfirmRecheckIOS
              : AppConstants.hoServerConfirmRecheckAndroid;

      final formData = FormData.fromMap(params);
      final response = await _dio.post(url, data: formData);
      _logger.i(
        'Manual Confirm Response: ${response.data}, ${response.statusCode}, ${response.headers}',
      );

      if (response.statusCode == 200) {
        // API 응답 데이터 안전성 검증 및 기본값 설정
        Map<String, dynamic> responseData;

        // 응답 데이터가 문자열인 경우 JSON 파싱
        if (response.data is String) {
          responseData = jsonDecode(response.data) as Map<String, dynamic>;
        } else {
          responseData = response.data as Map<String, dynamic>;
        }

        // required 필드에 대한 안전장치
        final safeResponseData = {
          'return': responseData['return'] ?? false,
          'call_count': responseData['call_count'] ?? 0,
          'appuuid': responseData['appuuid'] ?? appuuid,
          'appsid': responseData['appsid'] ?? '',
          'appip': responseData['appip'] ?? '',
          'now': responseData['now'] ?? DateTime.now().toString(),
          'app_cid': responseData['app_cid'] ?? phoneNumber,
          'msg': responseData['msg'] ?? '',
          // optional 필드들
          'prnts_phone_no': responseData['prnts_phone_no'],
          'inst_phone_no': responseData['inst_phone_no'],
          'inst_time': responseData['inst_time'],
          'myapp': responseData['myapp'],
        };

        return ArsAuthResponse.fromJson(safeResponseData);
      } else {
        throw Exception('수동 인증 확인 실패: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Manual Confirm Error: $e');
      rethrow;
    }
  }
}
