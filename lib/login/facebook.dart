import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Facebook {
  
  static Future<dynamic> login() async {
    final LoginResult result = await FacebookAuth.i.login(
      permissions: ['email','user_birthday', 'user_gender']
    ); 
    if (result.status == LoginStatus.success) {
      // you are logged
      // final AccessToken accessToken = result.accessToken!;
      final Map<String, dynamic> userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200),birthday,gender",
        );
        return userData;
    } else {
      throw Exception('something went wrong');
    }
  }
}
