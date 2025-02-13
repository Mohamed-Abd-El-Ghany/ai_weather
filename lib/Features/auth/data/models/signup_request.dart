class SignupRequest {
  final String name;
  final String phone;
  final String email;
  final String password;

  const SignupRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });
}
