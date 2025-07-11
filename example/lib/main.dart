import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ars_login/ars_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ARS Login Example', home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ARS Login Package Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => LoginARS(
                          onAuthComplete: (response) {
                            // ARS 인증 완료 후 콜백
                            print('ARS 인증 완료!');
                            print('전화번호: ${response['app_cid']}');
                            print('인증 시간: ${response['now']}');
                            print('추천인 전화번호: ${response['prnts_phone_no']}');

                            // confirm API 응답 데이터 활용
                            final userData = {
                              'appuuid': response['appuuid'],
                              'appsid': response['appsid'],
                              'phoneNumber': response['app_cid'],
                              'authTime': response['now'],
                              'recommenderPhone': response['prnts_phone_no'],
                            };

                            // 사용자 정의 저장 로직
                            saveUserData(userData);

                            // 원하는 화면으로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MainScreen(userData: userData),
                              ),
                            );
                          },
                        ),
                  ),
                );
              },
              child: const Text('ARS 로그인 시작'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginARS()),
                );
              },
              child: const Text('기본 ARS 로그인 (콜백 없음)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            const LoginARS(useOnlyCallPermission: true),
                  ),
                );
              },
              child: const Text('ARS 로그인 (전화 권한만)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 통화 기능 확인 테스트
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text('통화 기능 확인 중...'),
                          ],
                        ),
                      ),
                );

                final phoneCapability =
                    await PhoneChecker.checkPhoneCapability();

                Navigator.of(context).pop(); // 로딩 다이얼로그 닫기

                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(
                          phoneCapability.canMakeCall ? '✅ 통화 가능' : '❌ 통화 불가',
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('상태: ${phoneCapability.reason}'),
                            if (phoneCapability.recommendedAction != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                '해결방법: ${phoneCapability.recommendedAction}',
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ],
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                );
              },
              child: const Text('통화 기능 확인'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 약관 선택 다이얼로그 표시
                showDialog(
                  context: context,
                  builder: (context) => const TermsSelectionDialog(),
                );
              },
              child: const Text('약관 보기'),
            ),
          ],
        ),
      ),
    );
  }

  void saveUserData(Map<String, dynamic> userData) {
    // 사용자 정의 저장 로직
    print('사용자 데이터 저장: $userData');
    // 여기서 SharedPreferences, Hive, 서버 전송 등 원하는 저장 방식 사용
  }
}

class MainScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const MainScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메인 화면')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '환영합니다! 로그인이 완료되었습니다.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('전화번호: ${userData['phoneNumber'] ?? ''}'),
                    const SizedBox(height: 8),
                    Text('인증 시간: ${userData['authTime'] ?? ''}'),
                    const SizedBox(height: 8),
                    Text('App UUID: ${userData['appuuid'] ?? ''}'),
                    const SizedBox(height: 8),
                    Text('App SID: ${userData['appsid'] ?? ''}'),
                    const SizedBox(height: 8),
                    Text('추천인: ${userData['recommenderPhone'] ?? '없음'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: const Text('처음으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
