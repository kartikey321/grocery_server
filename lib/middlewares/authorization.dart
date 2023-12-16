import 'package:dart_frog/dart_frog.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import '../config/config.dart';

Middleware authorize() {
  // 1.
  return provider<bool>((context) {
    final request = context.request;

    // 2.
    final headers = request.headers;
    final authData = headers['Authorization'];
    try {
      final token = authData!.trim();

      // 3.
      verifyJwtHS256Signature(
        token,
        Config.jwtSecret,
      );
      return true;
    } catch (e) {
      return false;
    }
  });
}

// 4.
String issueToken(String userId) {
  final claimSet = JwtClaim(
    subject: userId,
    issuer: 'karokojnr',
    otherClaims: <String, dynamic>{
      'type': 'authenticationresponse',
    },
    maxAge: const Duration(hours: 24),
  );
  final token = issueJwtHS256(claimSet, Config.jwtSecret);
  return token;
}
