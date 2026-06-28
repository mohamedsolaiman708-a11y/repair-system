import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final supabaseClientProvider = Provider<supabase.SupabaseClient>((ref) {
  return supabase.Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChanged;
});

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  late final AuthRepository _repository;

  @override
  FutureOr<UserEntity?> build() async {
    _repository = ref.watch(authRepositoryProvider);
    
    // Listen to Supabase session state changes
    ref.listen(authStateChangesProvider, (previous, next) {
      if (next.hasValue) {
        state = AsyncValue.data(next.value);
      }
    });

    final userResult = await _repository.getCurrentUser();
    return userResult.fold(
      (user) => user,
      (failure) => null,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (user) {
        state = AsyncValue.data(user);
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final result = await _repository.logout();
    result.fold(
      (_) {
        state = const AsyncValue.data(null);
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(() {
  return AuthNotifier();
});
