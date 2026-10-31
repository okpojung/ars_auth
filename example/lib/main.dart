import 'package:ars_login/ars_login.dart';
import 'package:flutter/material.dart';

/// 예제: 빌드할 때 키를 넣으세요.
/// flutter run --dart-define=ARS2FA_API_KEY=... --dart-define=ARS2FA_APP_NAME=... --dart-define=ARS2FA_PACKAGE=...
const _config = Ars2faConfig(
  apiKey: String.fromEnvironment('ARS2FA_API_KEY'),
  mobileAppName: String.fromEnvironment('ARS2FA_APP_NAME', defaultValue: 'Example'),
  packageName: String.fromEnvironment('ARS2FA_PACKAGE', defaultValue: 'com.example.example'),
  bundleId: String.fromEnvironment('ARS2FA_BUNDLE', defaultValue: 'com.example.example'),
  purpose: '로그인',
);

void main() => runApp(const MaterialApp(home: Home()));

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text = '아직 인증하지 않았습니다.';

  Future<void> _auth() async {
    final r = await Ars2fa.authenticate(context, _config);
    if (!mounted) return;
    setState(() {
      _text = r == null
          ? '닫았습니다.'
          : r.success
              ? '인증 성공: ${r.phoneMasked}'
              : '인증 실패: ${r.message}';
    });
    // r.phone (성공 시 전체 번호)은 서버로 보내 회원 확인에 쓰고 로그에는 남기지 마세요.
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('ars2fa SDK 예제')),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_text),
            const SizedBox(height: 24),
            FilledButton(onPressed: _auth, child: const Text('휴대폰 인증')),
          ]),
        ),
      );
}
