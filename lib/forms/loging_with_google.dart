
import 'package:google_sign_in/google_sign_in.dart';

class LoginWithGoogle {
  static final _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  static  Future<GoogleSignInAccount?> login() => _googleSignIn.signInSilently();
  static Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> disconnect() => _googleSignIn.disconnect();
  static Future<bool> isLoggedIn() async => await _googleSignIn.isSignedIn();
  static Future<GoogleSignInAccount?> currentUser() async => await _googleSignIn.onCurrentUserChanged.first;
  
  static Future<String?> getToken() async {
  final GoogleSignInAccount? account = await _googleSignIn.signInSilently();
  final GoogleSignInAuthentication? auth = await account?.authentication;
  return auth?.accessToken;
}

}