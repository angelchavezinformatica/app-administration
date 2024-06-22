import 'package:bcrypt/bcrypt.dart';

String hashPlainText(String plain) {
  final String hashed = BCrypt.hashpw(plain, BCrypt.gensalt());
  return hashed;
}

bool compareHash(String plain, String hashed) {
  return BCrypt.checkpw(plain, hashed);
}
