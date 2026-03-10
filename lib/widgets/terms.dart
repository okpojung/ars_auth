import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import '../res/custom_colors.dart';
import '../res/custom_theme.dart';
import '../model/enum_list.dart';

class TermsScreen extends StatefulWidget {
  final TermsType termsType;

  const TermsScreen({super.key, required this.termsType});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  double progress = 0;
  String? errorMessage;

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
      backgroundColor: CustomColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 헤더 영역
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: const BoxDecoration(
                color: CustomColors.surface,
                border: Border(
                  bottom: BorderSide(color: CustomColors.divider, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset(
                    'packages/ars_login/assets/images/terms.json',
                    repeat: false,
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      // 에러 시 대체 위젯 표시
                      return const Icon(
                        Icons.description,
                        color: CustomColors.confirmButton,
                        size: 80,
                      );
                    },
                  ),
                  Text(
                    widget.termsType.title,
                    style: CustomTheme.titleText.copyWith(fontSize: 20.0),
                  ),
                ],
              ),
            ),

            // 로딩 프로그레스 바
            if (isLoading)
              Container(
                height: 3,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: CustomColors.divider,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    CustomColors.confirmButton,
                  ),
                ),
              ),

            // WebView 영역
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: errorMessage != null
                      ? _buildErrorWidget()
                      : InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: WebUri(widget.termsType.url),
                          ),
                          initialSettings: InAppWebViewSettings(
                            useShouldOverrideUrlLoading: true,
                            mediaPlaybackRequiresUserGesture: false,
                            allowsInlineMediaPlayback: true,
                            verticalScrollBarEnabled: true,
                            horizontalScrollBarEnabled: false,
                            disableHorizontalScroll: true,
                            supportZoom: false,
                            javaScriptEnabled: true,
                            domStorageEnabled: true,
                            transparentBackground: false,
                            backgroundColor: Colors.white,
                            textZoom: 220,
                            // 추가 설정
                            useHybridComposition: true,
                            clearCache: false,
                            cacheEnabled: true,
                            mixedContentMode:
                                MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                          ),
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                            print('✅ WebView 생성됨: ${widget.termsType.url}');
                          },
                          onLoadStart: (controller, url) {
                            print('🔄 로딩 시작: $url');
                            setState(() {
                              isLoading = true;
                              progress = 0;
                              errorMessage = null;
                            });
                          },
                          onProgressChanged: (controller, progress) {
                            print('📊 로딩 진행: $progress%');
                            setState(() {
                              this.progress = progress / 100;
                            });
                          },
                          onLoadStop: (controller, url) async {
                            print('✅ 로딩 완료: $url');
                            setState(() {
                              isLoading = false;
                            });
                            
                            // 페이지가 실제로 로드되었는지 확인
                            final html = await controller.evaluateJavascript(
                              source: 'document.body.innerHTML',
                            );
                            if (html == null || html.toString().isEmpty) {
                              setState(() {
                                errorMessage = '페이지 내용을 불러올 수 없습니다.';
                              });
                            }
                          },
                          onReceivedError: (controller, request, error) {
                            print('❌ WebView 에러: ${error.description}');
                            setState(() {
                              isLoading = false;
                              errorMessage =
                                  '페이지를 불러올 수 없습니다.\n\n에러 코드: ${error.type}\n${error.description}';
                            });
                          },
                          onReceivedHttpError:
                              (controller, request, errorResponse) {
                            print(
                              '❌ HTTP 에러: ${errorResponse.statusCode}',
                            );
                            setState(() {
                              isLoading = false;
                              errorMessage =
                                  'HTTP 에러가 발생했습니다.\n상태 코드: ${errorResponse.statusCode}';
                            });
                          },
                          shouldOverrideUrlLoading: (
                            controller,
                            navigationAction,
                          ) async {
                            // 외부 링크는 현재 WebView에서 로드하지 않음
                            final uri = navigationAction.request.url;
                            if (uri != null &&
                                !uri
                                    .toString()
                                    .contains('mobile.barosvc.com')) {
                              print('⛔ 외부 링크 차단: $uri');
                              return NavigationActionPolicy.CANCEL;
                            }
                            return NavigationActionPolicy.ALLOW;
                          },
                          onConsoleMessage: (controller, consoleMessage) {
                            // 디버깅용 콘솔 로그
                            print(
                              '🖥️ [Console] ${consoleMessage.messageLevel}: ${consoleMessage.message}',
                            );
                          },
                        ),
                ),
              ),
            ),

            // 하단 버튼 영역
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: CustomColors.surface,
                border: Border(
                  top: BorderSide(color: CustomColors.divider, width: 1.0),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: CustomColors.confirmButton,
                    foregroundColor: CustomColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    '확인',
                    style: CustomTheme.titleText.copyWith(
                      fontSize: 16,
                      color: CustomColors.surface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 에러 표시 위젯
  Widget _buildErrorWidget() {
    return Container(
      color: CustomColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: CustomColors.negative,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage ?? '알 수 없는 오류가 발생했습니다.',
                style: CustomTheme.bodyText.copyWith(
                  color: CustomColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                    isLoading = true;
                  });
                  webViewController?.reload();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.confirmButton,
                  foregroundColor: CustomColors.surface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 약관 선택 다이얼로그 (필요시 사용)
class TermsSelectionDialog extends StatelessWidget {
  const TermsSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('약관 선택', style: CustomTheme.titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              Icons.description,
              color: CustomColors.confirmButton,
            ),
            title: Text(TermsType.service.title, style: CustomTheme.bodyText),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          const TermsScreen(termsType: TermsType.service),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip,
              color: CustomColors.confirmButton,
            ),
            title: Text(TermsType.privacy.title, style: CustomTheme.bodyText),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          const TermsScreen(termsType: TermsType.privacy),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '취소',
            style: CustomTheme.bodyText.copyWith(
              color: CustomColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
