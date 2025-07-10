import 'package:flutter/material.dart';

/// 아래에서 위로 슬라이드 업 애니메이션 (모달 스타일)
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  SlideUpPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // 슬라이드 업 애니메이션
           final slideAnimation = Tween<Offset>(
             begin: const Offset(0.0, 1.0), // 아래에서 시작
             end: Offset.zero, // 원래 위치로
           ).animate(
             CurvedAnimation(
               parent: animation,
               curve: Curves.easeOutCubic, // 부드러운 커브
             ),
           );

           // 페이드 애니메이션 추가
           final fadeAnimation = Tween<double>(
             begin: 0.0,
             end: 1.0,
           ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

           return SlideTransition(
             position: slideAnimation,
             child: FadeTransition(opacity: fadeAnimation, child: child),
           );
         },
       );
}

/// iOS 스타일 좌우 슬라이드 애니메이션
class CupertinoSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  CupertinoSlidePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // 좌우 슬라이드 애니메이션
           final slideAnimation = Tween<Offset>(
             begin: const Offset(1.0, 0.0), // 오른쪽에서 시작
             end: Offset.zero, // 원래 위치로
           ).animate(
             CurvedAnimation(
               parent: animation,
               curve: Curves.fastOutSlowIn, // iOS 스타일 커브
             ),
           );

           // 이전 화면을 살짝 뒤로 밀어내는 효과
           final previousSlideAnimation = Tween<Offset>(
             begin: Offset.zero,
             end: const Offset(-0.3, 0.0), // 살짝 왼쪽으로
           ).animate(
             CurvedAnimation(
               parent: secondaryAnimation,
               curve: Curves.fastOutSlowIn,
             ),
           );

           return Stack(
             children: [
               // 이전 화면
               SlideTransition(
                 position: previousSlideAnimation,
                 child: Container(), // 실제로는 이전 화면이 여기에 들어감
               ),
               // 새 화면
               SlideTransition(position: slideAnimation, child: child),
             ],
           );
         },
       );
}

/// 페이드 인/아웃 애니메이션 (부드러운 전환)
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  FadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
             CurvedAnimation(parent: animation, curve: Curves.easeInOut),
           );

           // 약간의 스케일 효과 추가 (더 부드럽게)
           final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
             CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
           );

           return FadeTransition(
             opacity: fadeAnimation,
             child: ScaleTransition(scale: scaleAnimation, child: child),
           );
         },
       );
}

/// 스케일 + 페이드 애니메이션 (다이얼로그 스타일)
class ScaleFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  ScaleFadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
             CurvedAnimation(parent: animation, curve: Curves.elasticOut),
           );

           final fadeAnimation = Tween<double>(
             begin: 0.0,
             end: 1.0,
           ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

           return FadeTransition(
             opacity: fadeAnimation,
             child: ScaleTransition(scale: scaleAnimation, child: child),
           );
         },
       );
}
