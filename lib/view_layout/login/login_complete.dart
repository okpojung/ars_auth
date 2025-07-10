import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../res/custom_colors.dart';
import '../../res/custom_theme.dart';
import '../../utils/phone_formatter.dart';

class LoginComplete extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String? recommenderPhoneNumber;

  const LoginComplete({
    super.key,
    required this.phoneNumber,
    this.recommenderPhoneNumber,
  });

  @override
  ConsumerState<LoginComplete> createState() => _LoginCompleteState();
}

class _LoginCompleteState extends ConsumerState<LoginComplete> {
  @override
  void initState() {
    super.initState();

    // 화면 방향을 portrait로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // 화면 방향을 원래 상태로 복원
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: CustomColors.surface,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Container(
        color: CustomColors.surface,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // 체크 애니메이션
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: CustomColors.confirmButton.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: CustomColors.confirmButton,
                ),
              ),
              const SizedBox(height: 30.0),
              // 전화번호 표시
              Text(
                PhoneFormatter.formatFullPhoneNumber(widget.phoneNumber),
                style: CustomTheme.titleText.copyWith(fontSize: 35.0),
              ),
              const SizedBox(height: 20.0),
              // 완료 메시지
              Text(
                'ARS인증이 완료 되었습니다.',
                style: CustomTheme.titleText.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              // 구분선
              const Divider(
                height: 1,
                color: CustomColors.divider,
                indent: 70,
                endIndent: 70,
              ),
              const SizedBox(height: 20.0),
              // 추천인 정보
              Text(
                _getRecommenderMessage(),
                style: CustomTheme.titleText.copyWith(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 200.0),
              // 시작하기 버튼
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 튜토리얼 화면으로 이동하거나 메인 화면으로 이동
                    Navigator.of(context).pushReplacementNamed('/main');
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: CustomColors.confirmButton,
                    foregroundColor: CustomColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    '바로앱 시작하기',
                    style: CustomTheme.titleText.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRecommenderMessage() {
    if (widget.recommenderPhoneNumber != null &&
        widget.recommenderPhoneNumber!.isNotEmpty) {
      return '${PhoneFormatter.formatFullPhoneNumber(widget.recommenderPhoneNumber!)} 님을 추천하였습니다.\n앱설정에서 확인하실 수 있습니다.';
    } else {
      return '앱설정에서 추천인을 등록하실 수 있습니다.';
    }
  }
}
