sealed class AuthState {
  const AuthState();
}

class AuthIdle extends AuthState {
  const AuthIdle();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

class AuthSignUpSuccess extends AuthState {
  const AuthSignUpSuccess();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
