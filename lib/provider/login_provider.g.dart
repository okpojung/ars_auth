// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isLoggedInHash() => r'ac0f33cf4e612ee03be8616ca643be93f83e8fed';

/// See also [isLoggedIn].
@ProviderFor(isLoggedIn)
final isLoggedInProvider = AutoDisposeFutureProvider<bool>.internal(
  isLoggedIn,
  name: r'isLoggedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLoggedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsLoggedInRef = AutoDisposeFutureProviderRef<bool>;
String _$userInfoHash() => r'6f27a9c647c36f52d186d0609df5542c52753c30';

/// See also [userInfo].
@ProviderFor(userInfo)
final userInfoProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  userInfo,
  name: r'userInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserInfoRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$loginNotifierHash() => r'bb429c0e0970fa5c425792891b7e9c22250077e3';

/// See also [LoginNotifier].
@ProviderFor(LoginNotifier)
final loginNotifierProvider =
    AutoDisposeNotifierProvider<LoginNotifier, LoginState>.internal(
  LoginNotifier.new,
  name: r'loginNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loginNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoginNotifier = AutoDisposeNotifier<LoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
