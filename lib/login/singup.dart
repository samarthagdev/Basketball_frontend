import 'package:basketball_frontend/login/otp.dart';
import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Future<void> accountCreating2({
    required BuildContext context,
    required String name,
    required String username,
    required String number,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/gettingotp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uniId': username,
        'displayName': name,
        'number': number,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      isButtonSelected = false;
      Navigator.push(
          context,
          CustomPageRoute(
              child: Otp(
                name: name,
                number: number,
                username: username,
                password: password,
              ),
              direction: AxisDirection.left));
    } else if (response.statusCode == 205) {
      setState(() {
        isButtonSelected = false;
      });
      Provider.of<SignUpProvider>(context, listen: false)
          .errorMethod('Unique Id is already Taken');
    } else if (response.statusCode == 226) {
      setState(() {
        isButtonSelected = false;
      });
      Provider.of<SignUpProvider>(context, listen: false)
          .errorMethod('Number is already Exists');
    } else {
      setState(() {
        isButtonSelected = false;
      });
      Provider.of<SignUpProvider>(context, listen: false)
          .errorMethod('There is some error. Please try again');
    }
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final ButtonStyle loginStyle = ElevatedButton.styleFrom(
      primary: const Color(0xFF0e2f44),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  bool isButtonSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            backGround(),
            textfieldcol(),
          ],
        ),
      ),
    );
  }

  Widget textfieldcol() {
    String error = Provider.of<SignUpProvider>(context).errorMethod1;
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFf8843d),
        margin: const EdgeInsets.only(top: 250),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 8, left: 12),
              width: double.infinity,
              height: 50,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Provider.of<SignUpProvider>(context, listen: false)
                            .errorMethod('');
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Sign-UP',
                      style: GoogleFonts.acme(
                          fontSize: 40, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Text(error,
                  style:
                      const TextStyle(color: Color(0xFFff0000), fontSize: 15)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: TextFormField(
                controller: _name,
                decoration: ThemeHelper().textInputDecoration1(
                    Icons.person, 'Please Enter your Name', 'Name'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextFormField(
                controller: _user,
                maxLength: 20,
                decoration: ThemeHelper().textInputDecoration1(
                    Icons.key, 'Please Enter your Username', 'Username'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextFormField(
                controller: _number,
                decoration: ThemeHelper().textInputDecoration1(
                    Icons.numbers, 'Please Enter your Number', 'Number'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextFormField(
                obscureText: true,
                controller: _pass,
                decoration: ThemeHelper().textInputDecoration1(
                    Icons.password, 'Please Enter your Password', 'Password'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 15,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                obscureText: true,
                controller: _pass1,
                decoration: ThemeHelper().textInputDecoration1(Icons.password,
                    'Please Enter your Password again', 'Confirm Password'),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                width: 200,
                alignment: Alignment.center,
                child: StatefulBuilder(
                  builder: (context, innerState) {
                    return ElevatedButton(
                      onPressed:isButtonSelected?null: () {
                        if (_name.text.isNotEmpty &&
                            _user.text.isNotEmpty &&
                            _number.text.isNotEmpty &&
                            _pass.text.isNotEmpty &&
                            _pass1.text.isNotEmpty &&
                            _pass.text == _pass1.text) {
                          if (_user.text.contains(" ")) {
                            Provider.of<SignUpProvider>(context, listen: false)
                              .errorMethod(
                                  'Avoid Space in Username');
                          } else if (_number.text.length != 10) {
                            Provider.of<SignUpProvider>(context, listen: false)
                              .errorMethod(
                                  'Number should be of 10 digit');
                          } else {
                            innerState(() {
                              isButtonSelected = true;
                            });
                            accountCreating2(
                              context: context,
                              name: _name.text,
                              username: _user.text,
                              number: _number.text,
                              password: _pass.text,
                            );
                          }
                        } else {
                          Provider.of<SignUpProvider>(context, listen: false)
                              .errorMethod(
                                  'There is something wrong ethier password are not matching or you have left some field');
                        }
                      },
                      style: loginStyle,
                      child:isButtonSelected?const Center(child: CircularProgressIndicator(color: Colors.pink,),):const Text('Sign-UP'),
                    );
                  }
                )),
            const SizedBox(
              height: 15,
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
      child: Image.asset('assets/basketring.png', fit: BoxFit.cover),
    );
  }
}
