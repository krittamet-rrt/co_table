import 'package:co_table/models/models.dart';

abstract class UserRepo {
  Future<String> createUser({
    required String username,
    required String email,
    required String roles,
    required String faculty,
    required String password,
  });

  Future<String> loginUser({
    required String username,
    required String password,
  });

  Future<UserModel> getUser();

  Future<String> forgotPassword({
    required String email,
    required String newPassword,
  });

  Future<void> logoutUser();
}
