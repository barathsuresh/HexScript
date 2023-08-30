import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on Exception catch (e) {
      // TODO
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
          localizedReason: 'SCAN FINGERPRINT TO ACCESS THIS NOTE 🔐',
          options:
              AuthenticationOptions(useErrorDialogs: true, stickyAuth: true));
    } on Exception catch (e) {
      return false;
    }
  }
}
