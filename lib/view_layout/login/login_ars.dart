import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../model/enum_list.dart';
import '../../model/login_model.dart';
import '../../provider/login_provider.dart';
import '../../provider/permission_provider.dart';
import '../../res/custom_colors.dart';
import '../../res/custom_theme.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/terms_link_widget.dart';
import '../permission/permission_manager.dart';
import 'login_complete.dart';
import 'manual_phone_input.dart';
import '../../res/constants.dart';

class LoginARS extends ConsumerStatefulWidget {
  final ArsAuthStartCallback? onAuthStart;
  final ArsAuthCompleteCallback? onAuthComplete;
  final ArsAuthFailureCallback? onAuthFailure;
  final ArsManualInputCallback? onManualInputRequired;
  final bool useOnlyCallPermission;

  const LoginARS({
    super.key,
    this.onAuthStart,
    this.onAuthComplete,
    this.onAuthFailure,
    this.onManualInputRequired,
    this.useOnlyCallPermission = false,
  });

  @override
  ConsumerState<LoginARS> createState() => _LoginARSState();
}

class _LoginARSState extends ConsumerState<LoginARS>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // 화면 방향을 portrait로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 앱 라이프사이클 감지 시작
    WidgetsBinding.instance.addObserver(this);

    // 콜백 설정만 추가
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(loginNotifierProvider.notifier)
          .setCallbacks(
            onAuthStart: widget.onAuthStart,
            onAuthComplete: widget.onAuthComplete,
            onAuthFailure: widget.onAuthFailure,
            onManualInputRequired: widget.onManualInputRequired,
          );
    });
  }

  @override
  void dispose() {
    // 화면 방향을 원래 상태로 복원
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    // 앱 라이프사이클 감지 중단
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 앱이 포그라운드로 돌아올 때 LoginProvider에 알림
    if (state == AppLifecycleState.resumed) {
      ref.read(loginNotifierProvider.notifier).onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    final loginNotifier = ref.read(loginNotifierProvider.notifier);

    // 인증 성공 시 콜백이 없는 경우에만 기본 LoginComplete 화면으로 이동
    // 하지만 패키지에서는 데이터를 저장하지 않으므로 콜백 없이는 사용할 수 없음
    if (loginState.status == AuthStatus.success &&
        widget.onAuthComplete == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => const LoginComplete(
                  phoneNumber: '',
                  recommenderPhoneNumber: null,
                ),
          ),
        );
      });
    }

    // 수동 인증이 필요한 상태로 변경되면 자동으로 수동 입력 화면으로 이동
    if (loginState.status == AuthStatus.manualInputRequired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ManualPhoneInput()),
        );
      });
    }

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
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              color: CustomColors.surface,
              child: Column(
                children: [
                  const SizedBox(height: 40.0),
                  // 약관 동의 섹션
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('약관동의', style: CustomTheme.titleText),
                  ),
                  const SizedBox(height: 20.0),

                  // 약관 동의 컨테이너
                  Container(
                    height: 276.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: 1.5,
                        color: CustomColors.divider,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 6.0),
                        // 전체 동의
                        CustomCheckbox(
                          isChecked: loginState.allTermsAccepted,
                          onChanged: (value) {
                            loginNotifier.updateAllTermsAccepted(
                              value ?? false,
                            );
                          },
                          title: '전체동의',
                          titleStyle: CustomTheme.bodyText,
                          showRequiredText: false,
                        ),

                        const Divider(
                          indent: 16,
                          endIndent: 16,
                          thickness: 0.5,
                          color: CustomColors.divider,
                        ),

                        // 개별 약관들
                        CustomCheckbox(
                          isChecked: loginState.ageConfirmed,
                          onChanged: (value) {
                            loginNotifier.updateAgeConfirmed(value ?? false);
                          },
                          title: '만 14세 이상입니다.',
                          titleStyle: CustomTheme.bodyText,
                          isRequired: true,
                        ),

                        TermsLinkWidget(
                          isChecked: loginState.serviceTermsAccepted,
                          onChanged: (value) {
                            loginNotifier.updateServiceTermsAccepted(
                              value ?? false,
                            );
                          },
                          title: '이용약관',
                          url: AppConstants.termsOfServiceUrl,
                          isRequired: true,
                        ),

                        TermsLinkWidget(
                          isChecked: loginState.privacyTermsAccepted,
                          onChanged: (value) {
                            loginNotifier.updatePrivacyTermsAccepted(
                              value ?? false,
                            );
                          },
                          title: '개인정보 처리방침',
                          url: AppConstants.privacyPolicyUrl,
                          isRequired: true,
                        ),

                        CustomCheckbox(
                          isChecked: loginState.pushNotificationAccepted,
                          onChanged: (value) {
                            loginNotifier.updatePushNotificationAccepted(
                              value ?? false,
                            );
                          },
                          title: '이벤트,프로모션 알림 메일 SMS 수신',
                          titleStyle: CustomTheme.bodyText.copyWith(
                            fontSize: 13,
                          ),
                          isRequired: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30.0),

                  // ARS 인증 섹션
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ARS 인증', style: CustomTheme.titleText),
                  ),
                  const SizedBox(height: 20.0),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '투채널 폰인증 ARS 시스템 (특허출원)으로 \n전화연결을 통해 안전하게 자동인증 됩니다.\n\n전화인증을 위해 권한을 허용 해주세요.',
                      style: CustomTheme.bodyText,
                    ),
                  ),

                  const SizedBox(height: 30.0),

                  // 인증 시작 버튼
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          loginState.isLoading
                              ? null
                              : () async {
                                await _handleAuthenticationStart(context, ref);
                              },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: CustomColors.confirmButton,
                        foregroundColor: CustomColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child:
                          loginState.isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: CustomColors.surface,
                                ),
                              )
                              : const Text(
                                'ARS 인증 시작',
                                style: CustomTheme.buttonText,
                              ),
                    ),
                  ),

                  // 상태 메시지 표시
                  if (loginState.errorMessage != null) ...[
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          loginState.errorMessage!,
                          style: CustomTheme.bodyText.copyWith(
                            color:
                                loginState.status ==
                                        AuthStatus.waitingForAppReturn
                                    ? CustomColors.confirmButton
                                    : CustomColors.negative,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 로딩 오버레이 (터치 방지) - 단순 투명 화면
          if (loginState.isLoading)
            Positioned.fill(
              child: AbsorbPointer(child: Container(color: Colors.transparent)),
            ),
        ],
      ),
    );
  }

  Future<void> _handleAuthenticationStart(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final loginNotifier = ref.read(loginNotifierProvider.notifier);
    final loginState = ref.read(loginNotifierProvider);

    // 1. 체크박스 상태 확인 (필수 약관 동의 확인)
    if (!loginState.allTermsAccepted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('필수 약관에 동의해주세요.'),
            backgroundColor: const Color.fromARGB(255, 237, 104, 94),
            duration: const Duration(milliseconds: 1000),
          ),
        );
      }
      return;
    }

    // 2. 권한 확인 및 요청
    if (widget.useOnlyCallPermission) {
      // 전화 권한만 요청하는 경우 (플랫폼별 처리)
      if (Platform.isIOS) {
        // iOS에서는 전화 권한이 필요 없음 (tel: URL scheme 사용)
        debugPrint('iOS: 전화 권한 불필요, ARS 인증을 바로 진행합니다.');
        // iOS에서는 권한 체크를 건너뛰고 바로 ARS 인증 시작
      } else {
        // Android에서만 phone 권한 요청
        final phoneStatus = await Permission.phone.status;

        if (phoneStatus.isDenied) {
          final result = await Permission.phone.request();
          if (result.isDenied) {
            if (context.mounted) {
              loginNotifier.state = loginNotifier.state.copyWith(
                status: AuthStatus.failure,
                errorMessage: '전화 권한이 필요합니다. 설정에서 전화권한을 허용해주세요',
              );
            }
            return;
          }
        } else if (phoneStatus.isPermanentlyDenied) {
          if (context.mounted) {
            loginNotifier.state = loginNotifier.state.copyWith(
              status: AuthStatus.failure,
              errorMessage: '전화 권한이 필요합니다. 설정에서 전화권한을 허용해주세요',
            );
          }
          return;
        }
      }
    } else {
      // 기존 전체 권한 요청 로직
      if (!await ref.read(isPermissionGrantedProvider.future)) {
        if (!context.mounted) return;

        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PermissionManager()),
        );
        if (result != true) return;
      }
    }

    // 3. ARS 인증 시작
    await loginNotifier.startArsAuthentication();
  }
}
