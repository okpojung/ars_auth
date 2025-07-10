// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isPermissionGrantedHash() =>
    r'fe6a3f78735a8939f7b8de3020b5c2b99c1349e7';

/// See also [isPermissionGranted].
@ProviderFor(isPermissionGranted)
final isPermissionGrantedProvider = AutoDisposeFutureProvider<bool>.internal(
  isPermissionGranted,
  name: r'isPermissionGrantedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPermissionGrantedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsPermissionGrantedRef = AutoDisposeFutureProviderRef<bool>;
String _$permissionNotifierHash() =>
    r'74968e93e123991469a19e399d86508c3c0c03ef';

/// See also [PermissionNotifier].
@ProviderFor(PermissionNotifier)
final permissionNotifierProvider =
    AutoDisposeNotifierProvider<PermissionNotifier, PermissionState>.internal(
  PermissionNotifier.new,
  name: r'permissionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$permissionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PermissionNotifier = AutoDisposeNotifier<PermissionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
