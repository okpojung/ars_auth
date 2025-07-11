import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/enum_list.dart';
import '../../provider/login_provider.dart';
import '../../res/custom_colors.dart';
import '../../res/custom_theme.dart';
import '../../utils/phone_formatter.dart';
import 'login_complete.dart';

class ManualPhoneInput extends ConsumerStatefulWidget {
  const ManualPhoneInput({super.key});

  @override
  ConsumerState<ManualPhoneInput> createState() => _ManualPhoneInputState();
}

class _ManualPhoneInputState extends ConsumerState<ManualPhoneInput> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _phoneErrorMessage; // 전화번호 실시간 검증 오류 메시지
  String? _submitErrorMessage; // 버튼 클릭 시 검증 오류 메시지

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

    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('전화번호 수동 입력', style: CustomTheme.titleText),
        backgroundColor: CustomColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 상태 초기화 후 이전 화면으로
            ref.read(loginNotifierProvider.notifier).reset();
            Navigator.of(context).pop();
          },
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),

                  // 안내 메시지
                  const Text(
                    'ARS 자동인증이 실패했습니다.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.negative,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  const Text(
                    '전화번호를 직접 입력하여 인증을 진행해주세요.',
                    style: CustomTheme.bodyText,
                  ),
                  const SizedBox(height: 40.0),

                  // 전화번호 입력 필드
                  const Text('전화번호', style: CustomTheme.titleText),
                  const SizedBox(height: 12.0),

                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneNumberFormatter(),
                    ],
                    onChanged: (value) {
                      // 실시간 기본 검증 (010 시작, 숫자만)
                      setState(() {
                        _phoneErrorMessage =
                            PhoneFormatter.getPhoneNumberErrorMessage(value);
                        _submitErrorMessage = null; // 입력 시 제출 에러 메시지 초기화
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '010-1234-5678',
                      hintStyle: CustomTheme.bodyText.copyWith(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color:
                              (_phoneErrorMessage != null ||
                                      _submitErrorMessage != null)
                                  ? CustomColors.negative
                                  : CustomColors.divider,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color:
                              (_phoneErrorMessage != null ||
                                      _submitErrorMessage != null)
                                  ? CustomColors.negative
                                  : CustomColors.divider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color:
                              (_phoneErrorMessage != null ||
                                      _submitErrorMessage != null)
                                  ? CustomColors.negative
                                  : CustomColors.confirmButton,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                    ),
                    style: CustomTheme.bodyText,
                  ),

                  // 전화번호 검증 오류 메시지 (실시간 + 제출 시)
                  if (_phoneErrorMessage != null ||
                      _submitErrorMessage != null) ...[
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        _submitErrorMessage ?? _phoneErrorMessage!,
                        style: TextStyle(
                          color: CustomColors.negative,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40.0),

                  // 인증 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          (_isLoading || _phoneController.text.isEmpty)
                              ? null
                              : () => _handleManualAuthentication(),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: CustomColors.confirmButton,
                        foregroundColor: CustomColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: CustomColors.surface,
                                  strokeWidth: 2.0,
                                ),
                              )
                              : const Text(
                                '수동 인증 시작',
                                style: CustomTheme.buttonText,
                              ),
                    ),
                  ),

                  // 에러 메시지 표시
                  if (loginState.errorMessage != null &&
                      loginState.status == AuthStatus.failure) ...[
                    const SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: CustomColors.negative.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: CustomColors.negative.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        loginState.errorMessage!,
                        style: CustomTheme.bodyText.copyWith(
                          color: CustomColors.negative,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 로딩 오버레이
          if (_isLoading)
            Positioned.fill(
              child: AbsorbPointer(child: Container(color: Colors.transparent)),
            ),
        ],
      ),
    );
  }

  Future<void> _handleManualAuthentication() async {
    if (_phoneController.text.isEmpty) {
      return;
    }

    // 버튼 클릭 시 완전 검증 수행
    final completeValidationError =
        PhoneFormatter.getCompletePhoneNumberErrorMessage(
          _phoneController.text,
        );

    if (completeValidationError != null) {
      setState(() {
        _submitErrorMessage = completeValidationError;
      });
      return;
    }

    // 에러 메시지 초기화
    setState(() {
      _submitErrorMessage = null;
      _isLoading = true;
    });

    final loginNotifier = ref.read(loginNotifierProvider.notifier);

    // 전화번호에서 하이픈 제거
    final phoneNumber = _phoneController.text.replaceAll('-', '');

    await loginNotifier.startManualAuthentication(phoneNumber);

    final loginState = ref.read(loginNotifierProvider);

    setState(() {
      _isLoading = false;
    });

    if (loginState.status == AuthStatus.success && mounted) {
      // 성공 시 완료 화면으로 이동
      // 패키지에서는 데이터를 저장하지 않으므로 입력된 전화번호 사용
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => LoginComplete(
                phoneNumber: phoneNumber,
                recommenderPhoneNumber: null,
              ),
        ),
      );
    }
  }
}
