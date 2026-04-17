abstract class LoginStates {
  final String username;
  final String password;
  LoginStates({required this.username, required this.password});
}

class LoginInitialState extends LoginStates {
  // Initialize any properties required for the initial state here.
  LoginInitialState() : super(username: '', password: '');
}


class LoginAttemptState extends LoginStates {
  // Implement methods for handling login attempts, such as validating input.
  int attemptCount = 0;
  LoginAttemptState() : super(username: '', password: '');
}

class LoginLoadingState extends LoginStates {
  // Implement loading methods such as initializing API calls, etc.
  LoginLoadingState() : super(username: '', password: '');
}

class SuccessState extends LoginStates {
  // Handle success scenarios, e.g., setting a token or navigating to another screen.
  SuccessState() : super(username: '', password: '');
}

class FailureState extends LoginStates {
  // Handle failure scenarios, e.g., logging errors and providing feedback to user.
  FailureState({required this.errorMessage}) : super(username: '', password: '');
  final String errorMessage;
}

