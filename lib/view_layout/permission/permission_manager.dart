import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/permission_provider.dart';
import '../../res/custom_colors.dart';
import '../../res/custom_theme.dart';
import '../../widgets/permission_item_widget.dart';

class PermissionManager extends ConsumerStatefulWidget {
  const PermissionManager({super.key});

  @override
  ConsumerState<PermissionManager> createState() => _PermissionManagerState();
}

class _PermissionManagerState extends ConsumerState<PermissionManager> {
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
    final permissionState = ref.watch(permissionNotifierProvider);
    final permissionNotifier = ref.read(permissionNotifierProvider.notifier);

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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          color: CustomColors.surface,
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('권한을 허용해주세요.', style: CustomTheme.titleText),
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '원활한 앱 사용을 위해 아래 권한이 필요합니다.',
                  style: CustomTheme.bodyText,
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 1.5, color: CustomColors.divider),
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      PermissionItemWidget(
                        icon: Icons.mic,
                        title: '음성인식에 필요한 권한입니다.',
                      ),
                      PermissionItemWidget(
                        icon: Icons.phone,
                        title: '음성으로 전화연결시 필요한\n권한 입니다.',
                      ),
                      PermissionItemWidget(
                        icon: Icons.contacts,
                        title: '전화연결시 연락처를\n검색합니다.',
                      ),
                      PermissionItemWidget(
                        icon: Icons.camera_alt,
                        title: '큐알카메라를 사용시 필요한\n권한 입니다.',
                      ),
                      PermissionItemWidget(
                        icon: Icons.location_on,
                        title: '나에게 가까운 장소를 검색시에\n필요한 권한 입니다.',
                      ),
                      PermissionItemWidget(
                        icon: Icons.storage,
                        title: '마이키워드 등록할 로컬저장소를\n이용시 필요한 권한입니다.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(permissionNotifierProvider.notifier)
                        .requestAllPermissions();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: CustomColors.confirmButton,
                    foregroundColor: CustomColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text('확 인', style: CustomTheme.buttonText),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
