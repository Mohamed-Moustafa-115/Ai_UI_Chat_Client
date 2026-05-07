abstract class RegisterStates {
  final String name;
  final String username;
  final String password;
  final String confirmPassword;

  RegisterStates({
    required this.name,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });
}

class RegisterInitialState extends RegisterStates {
  RegisterInitialState()
      : super(
          name: '',
          username: '',
          password: '',
          confirmPassword: '',
        );
}

class RegisterAttemptState extends RegisterStates {
  int attemptCount = 0;
  RegisterAttemptState()
      : super(
          name: '',
          username: '',
          password: '',
          confirmPassword: '',
        );
}

class RegisterLoadingState extends RegisterStates {
  RegisterLoadingState()
      : super(
          name: '',
          username: '',
          password: '',
          confirmPassword: '',
        );
}

class SuccessState extends RegisterStates {
  SuccessState()
      : super(
          name: '',
          username: '',
          password: '',
          confirmPassword: '',
        );
}

class FailureState extends RegisterStates {
  final String errorMessage;

  FailureState({required this.errorMessage})
      : super(
          name: '',
          username: '',
          password: '',
          confirmPassword: '',
        );
}
