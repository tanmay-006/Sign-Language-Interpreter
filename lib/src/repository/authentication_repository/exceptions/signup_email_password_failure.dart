class SignUpWithEmailAndPasswordFailure {
  final String message;

  SignUpWithEmailAndPasswordFailure([this.message = "An Unknown error occurred."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure('Please use a stronger password');
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure('Email is not valid');
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure('Account already exists');
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure('Email/password authentication not enabled');
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure('This account has been disabled');
      default:
        return SignUpWithEmailAndPasswordFailure();
    }
  }
}