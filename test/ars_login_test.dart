import 'package:flutter_test/flutter_test.dart';
import 'package:ars_login/ars_login.dart';

void main() {
  test('ARS Login package basic import test', () {
    // 기본적인 import가 정상적으로 작동하는지 확인
    expect(AuthStatus.initial, AuthStatus.initial);
    expect(AuthStatus.loading, AuthStatus.loading);
    expect(AuthStatus.success, AuthStatus.success);
    expect(AuthStatus.failure, AuthStatus.failure);
  });
}
