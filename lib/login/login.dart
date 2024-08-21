import 'package:basketball_frontend/login/resetpass.dart';
import 'package:basketball_frontend/login/singup.dart';
import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/main/Drawer/homepage.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/firebase.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> login(
      {required String username,
      required String password,
      required firebase}) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uniId': username,
        'password': password,
        'firebase': firebase,
      }),
    );
    if (response.statusCode == 200) {
      var res1 = json.decode(response.body);
      var box = await Hive.openBox('details');
      box.put('personal', {
        'uniId': username,
        'Name': res1['name'],
        'photoUrl': res1['profile_pic'],
        'number': res1['number'],
        'email': res1['email'],
        'token': res1['token'],
        'method': 'custom'
      });
      // checking if player account is created or not 
      if(res1['dob'] != null || res1['gender'] != null || res1['height'] != null || res1['weight'] != null || res1['address'] != null){
        box.put('player', {
        'dob': res1['dob'],
        'gender': res1['gender'],
        'height': res1['height'],
        'weight': res1['weight'],
        'address': res1['address'],
      });
      }
      isButtonSelected = false;
      Navigator.pushReplacement(
          context, CustomPageRoute(child: const HomePage(), direction: AxisDirection.left));
    } else {
      setState(() {
        isButtonSelected = false;
      });
      throw Exception('There is some error');
    }
  }

  final ButtonStyle loginStyle = ElevatedButton.styleFrom(
      primary:const Color(0xFF003366),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  final ButtonStyle loginStyle1 = ElevatedButton.styleFrom(
      primary:const Color(0xFF003366),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.20, 30));

  final ButtonStyle fbStyle = ElevatedButton.styleFrom(
    primary: const Color(0xFF003366),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50)
  );

  final ButtonStyle gmailStyle = ElevatedButton.styleFrom(
    primary: Colors.red,
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50)
  );
  final TextEditingController _user = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isButtonSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8843d),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            backGround(),
            textFields(),
          ],
        ),
      ),
    );
  }

  Widget textFields() {
    String error = Provider.of<SignInProvider>(context).errorMethod1;
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFf8843d),
        margin: const EdgeInsets.only(top: 250),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 100,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text('Login-IN',
                  style: GoogleFonts.acme(
                      fontSize: 40, fontWeight: FontWeight.w500)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Text(error,
                  style:
                      const TextStyle(color: Color(0xFFff0000), fontSize: 15)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                controller: _user,
                decoration: ThemeHelper().textInputDecoration(CupertinoIcons.person,
                    'Please Enter your Username', 'Username',),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 30),
              child: TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: ThemeHelper().textInputDecoration(Icons.key,
                    'Please Enter your Password', 'Password', ),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    child: StatefulBuilder(
                      builder: (context, innerState) {
                        return ElevatedButton(
                          style: loginStyle,
                          onPressed:isButtonSelected? null:() async {
                            if (_pass.text.isNotEmpty && _user.text.isNotEmpty) {
                              var _firebasetoken = await Firetools.gettingtoken();
                              login(
                                  username: _user.text,
                                  password: _pass.text,
                                  firebase: _firebasetoken);
                              innerState(() {
                                isButtonSelected = true;
                              });
                            } else {
                              innerState(() {
                                isButtonSelected = false;
                              });
                              Provider.of<SignInProvider>(context, listen: false)
                                  .errorMethod('Please Fill below Field');
                            }
                          },
                          child:isButtonSelected?const Center(child: CircularProgressIndicator(color: Colors.pink,),): const Text('Login', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          )),
                        );
                      }
                    )),
                // ThemeHelper().outlinedbutton(
                //     context, gmailStyle, 'Gmail', Icons.mail_rounded),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    CustomPageRoute(child:const Register(), direction: AxisDirection.left));
              },
              child: const SizedBox(
                child: Text(
                  'Do not have Account? Signup',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF171717)),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    CustomPageRoute(child:const Reseting(), direction: AxisDirection.left));
              },
              child: const SizedBox(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget backGround() {
    return Container(
      height: 250,
      width: double.infinity,
      color: const Color(0xFF666666),
      child: Image.asset('assets/photo1.jpg', fit: BoxFit.cover),
    );
  }
}
