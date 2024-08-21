import 'dart:async';
import 'package:basketball_frontend/login/login.dart';
import 'package:basketball_frontend/main/Drawer/homepage.dart';
import 'package:basketball_frontend/them/firebase.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  Future<dynamic> loggedInorNot({String? username, String? token, String? firebase}) async{
    if(username != null || token != null){
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/credential'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uniId': username!,
        'token': token!,
        'firebase': firebase!,
      }),
    );
    if(response.statusCode == 200){
      return response.statusCode;
    }
    else if(response.statusCode == 204){
      return response.statusCode;
    }
    else{
      throw Exception('There is some error');
    }
    }
    else{
      return 204;
    }
  }
  
late Future<dynamic> _credentialCheck;

  @override
  void initState() {
    super.initState();
    _credentialCheck =gettingHive();
  }
  

  Future<dynamic>gettingHive()async{
    var box = await Hive.openBox('details');
    if(box.get('personal', defaultValue: <String, dynamic>{}).isNotEmpty){
      String username = box.get('personal')['uniId'];
      String token = box.get('personal')['token'];
      var _firebaseToken = await Firetools.gettingtoken();
      return loggedInorNot(username: username, token: token, firebase: _firebaseToken);
    }else{
      return loggedInorNot(username: null, token: null);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future:_credentialCheck,
      builder: (context, snapshot) {
        if(snapshot.data == 200){
          return const HomePage();
        }
        else if(snapshot.data == 204){
          return const LoginPage();
        }
        return const Scaffold(
          body: SizedBox(
            child: Center(
              child: Text("hi"),
            ),
          ),
        );
      }
    );
  }
}
