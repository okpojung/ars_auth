// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isPermissionGrantedHash() =>
    r'a2ed486d9724d799e99f3528dd26cd16501d42b3';

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
    r'22647db7c3657e340291c5626381264e795ef461';

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
