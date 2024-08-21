import 'package:basketball_frontend/Main/Drawer/homepage.dart';
import 'package:basketball_frontend/login/login.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class MainHomePage extends StatefulWidget {
  final dynamic user;
  final String loginMethod;
  const MainHomePage({Key? key, this.user, required this.loginMethod})
      : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final ButtonStyle _button = OutlinedButton.styleFrom(
    backgroundColor: const Color(0xFFc6e2ff),
  );

  var box;
  Future<dynamic> loginIn({
    required BuildContext context,
    required String displayName,
    required String email,
    photoUrl,
  }) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/checking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );
    box = await Hive.openBox('details');
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      box.put('personal', {
        'uniId': res['userName'],
        'Name': displayName,
        'number': res['number'],
        'photoUrl': res['profile_pic'],
        'email': email,
        'token': res['token'],
        'method': widget.loginMethod
      });
      // checking if player account is created or not 
      if(res['dob'] != null || res['gender'] != null || res['height'] != null || res['weight'] != null || res['address'] != null){
        box.put('player', {
        'dob': res['dob'],
        'gender': res['gender'],
        'height': res['height'],
        'weight': res['weight'],
        'address': res['address'],
      });
      }
      return res;
    } else if (response.statusCode == 204) {
      var response = await checkId(
          context: context,
          displayName: displayName,
          email: email,
          photoUrl: photoUrl);

      if (response == null) {
        Navigator.pushReplacement(
            context,
            CustomPageRoute(
              child:const LoginPage(),
              direction: AxisDirection.left
            ));
      } else {
        return [response];
      }
    } else {
      throw Exception('There is some error.');
    }
  }

  Future<dynamic> checkId({
    context,
    required String displayName,
    required String email,
    photoUrl,
  }) async {
    String errorText = '';
    String errorText1 = '';
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color(0xFFe5e5e5),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, innersetState) {
            return WillPopScope(
              onWillPop: _onWillPop,
              child: AlertDialog(
                backgroundColor: const Color(0xFF4c4c4c),
                alignment: Alignment.center,
                content: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: _id,
                          maxLength: 20,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFF7f7f7f),
                            filled: true,
                            icon: const Icon(CupertinoIcons.person),
                            labelText: 'UserName',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 42, 41, 44),
                            ),
                            errorText: errorText,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: _password,
                          obscureText: true,
                          maxLength: 30,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFF7f7f7f),
                            filled: true,
                            icon: const Icon(CupertinoIcons.lock),
                            labelText: 'Password',
                            errorText: errorText1,
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 42, 41, 44),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  OutlinedButton(
                    style: _button,
                    child: const Text('Approve',
                        style: TextStyle(
                          color: Color(0xFFff0000),
                        )),
                    onPressed: () async {
                      if (_id.text.isNotEmpty && _password.text.isNotEmpty) {
                        var _firebasetoken = await Firetools.gettingtoken();
                        var res = await creatingAccount(
                            uniId: _id.text,
                            displayName: displayName,
                            email: email,
                            password: _password.text,
                            photoUrl: photoUrl,
                            firebase: _firebasetoken);
                        if (res.statusCode == 200) {
                          var res1 = jsonDecode(res.body);
                          box.put('personal', {
                            'uniId': res1['userName'],
                            'Name': displayName,
                            'number': res1['number'],
                            'photoUrl': res1['profile_pic'],
                            'email': email,
                            'token': res1['token'],
                            'method': widget.loginMethod
                          });
                          Navigator.pop(context, res1);
                        } else if (res.statusCode == 205) {
                          innersetState(
                              (() => errorText = 'Unique Id is already Taken'));
                        } else {
                          throw Exception('There is some error');
                        }
                      } else {
                        innersetState(() {
                          errorText1 = 'Please fill the above field';
                          errorText = 'Please fill the above field';
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<dynamic> creatingAccount({
    required String uniId,
    required String displayName,
    required String email,
    required String password,
    photoUrl,
    required firebase,
  }) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/creating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'uniId': uniId,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'password': password,
        'firebase': firebase
      }),
    );
    return response;
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: widget.loginMethod == 'Gmail'
            ? loginIn(
                context: context,
                displayName: widget.user.displayName,
                email: widget.user.email,
                photoUrl: widget.user.photoUrl)
            : loginIn(
                context: context,
                displayName: widget.user['name'],
                email: widget.user['email'],
                photoUrl: widget.user['picture']['data']['url'],
              ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return const HomePage();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
