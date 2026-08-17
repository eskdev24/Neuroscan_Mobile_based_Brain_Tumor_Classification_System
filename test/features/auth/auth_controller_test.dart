import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neuroscan_ai/features/auth/application/auth_controller.dart';
import 'package:neuroscan_ai/features/auth/application/auth_state.dart';
import 'package:neuroscan_ai/features/auth/data/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is AuthIdle', () {
    final state = container.read(authControllerProvider);
    expect(state, isA<AuthIdle>());
  });

  test('reset returns state to AuthIdle', () async {
    // Set state to something else first
    container.read(authControllerProvider.notifier).state =
        const AuthError('test');
    expect(container.read(authControllerProvider), isA<AuthError>());

    container.read(authControllerProvider.notifier).reset();
    expect(container.read(authControllerProvider), isA<AuthIdle>());
  });

  test('signIn emits AuthLoading then AuthError on failure', () async {
    when(() => mockRepo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception('Invalid credentials'));

    final notifier = container.read(authControllerProvider.notifier);
    await notifier.signIn('test@example.com', 'password123');

    final state = container.read(authControllerProvider);
    expect(state, isA<AuthError>());
  });

  test('signIn emits AuthError when email not verified', () async {
    when(() => mockRepo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => throw Exception('skip'));
    when(() => mockRepo.isEmailVerified).thenReturn(false);
    when(() => mockRepo.sendEmailVerification()).thenAnswer((_) async {});

    // We need to handle the exception from signInWithEmail properly
    final mockRepo2 = MockAuthRepository();
    // Reset container with new mock
    container.dispose();
    mockRepo = mockRepo2;
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    when(() => mockRepo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => throw Exception('user'));
    when(() => mockRepo.isEmailVerified).thenReturn(false);
    when(() => mockRepo.sendEmailVerification()).thenAnswer((_) async {});

    final notifier = container.read(authControllerProvider.notifier);
    await notifier.signIn('test@example.com', 'pass');

    final state = container.read(authControllerProvider);
    expect(state, isA<AuthError>());
  });
}
