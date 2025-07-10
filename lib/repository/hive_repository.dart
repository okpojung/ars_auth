import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_repository.g.dart';

// Hive 로컬 데이터베이스 Repository
@riverpod
class HiveRepository extends _$HiveRepository {
  static const String _userBoxName = 'user_data';

  late Box<dynamic> _userBox;

  @override
  Future<void> build() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox(_userBoxName);
  }

  // 사용자 데이터 저장
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _userBox.putAll(userData);
  }

  // 사용자 데이터 조회
  Map<String, dynamic> getUserData() {
    return Map<String, dynamic>.from(_userBox.toMap());
  }

  // 로그인 상태 확인
  bool isLoggedIn() {
    return _userBox.get('isLogged', defaultValue: false);
  }

  // 앱 UUID 조회
  String? getAppUuid() {
    return _userBox.get('appuuid');
  }

  // 앱 세션 ID 조회
  String? getAppSid() {
    return _userBox.get('appsid');
  }

  // 사용자 전화번호 조회
  String? getUserPhoneNumber() {
    return _userBox.get('app_cid');
  }

  // 추천인 전화번호 조회
  String? getRecommenderPhoneNumber() {
    return _userBox.get('prnts_phone_no');
  }

  // 모든 데이터 삭제
  Future<void> clearAllData() async {
    await _userBox.clear();
  }

  // 사용자 데이터만 삭제
  Future<void> clearUserData() async {
    await _userBox.clear();
  }
}
