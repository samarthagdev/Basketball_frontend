import 'dart:convert';
import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/main/Drawer/homepage.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/firebase.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';

class Otp1 extends StatefulWidget {
  final String number;
  const Otp1({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  State<Otp1> createState() => _Otp1State();
}

class _Otp1State extends State<Otp1> {
  Future<void> accountCreating3({
    required String number,
    required String password,
    required firebase,
    required int otp,
  }) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/settingpass'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'number': number,
        'otp': otp,
        'pass': password,
        'firebase': firebase,
      }),
    );
    if (response.statusCode == 200) {
      var res1 = json.decode(response.body);
      var box = await Hive.openBox('details');
      box.put('personal', {
        'uniId': res1['userName'],
        'Name': res1['name'],
        'photoUrl': res1['profile_pic'],
        'number': res1['number'],
        'email': res1['email'],
        'token': res1['token'],
        'method': 'custom'
      });
      // checking if player account is created or not
      if (res1['dob'] != null ||
          res1['gender'] != null ||
          res1['height'] != null ||
          res1['weight'] != null ||
          res1['address'] != null) {
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
          context,
          CustomPageRoute(
              child: const HomePage(), direction: AxisDirection.left));
    } else {
      setState(() {
        isButtonSelected = false;
        errorText = "Ethier otp is not correct or there is some other error, please try again";
      });
      throw Exception('There is some error');
    }
  }

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final ButtonStyle loginStyle = ElevatedButton.styleFrom(
      primary: const Color(0xFF003366),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.4, 40));
  String err = "";
  void _setPass() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height *.5,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Text(err),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: TextFormField(
                      obscureText: true,
                      controller: _pass,
                      decoration: ThemeHelper().textInputDecoration1(
                          Icons.password,
                          'Please Enter your Password',
                          'Password'),
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
                      decoration: ThemeHelper().textInputDecoration1(
                          Icons.password,
                          'Please Enter your Password again',
                          'Confirm Password'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                    style: loginStyle,
                    onPressed: isButtonSelected
                        ? null
                        : () async {
                          setState(() {
                            isButtonSelected = true;  
                          });                          
                          if(_pass.text.isNotEmpty && _otp.text.isNotEmpty){
                          if(_pass.text == _pass1.text){
                            var _firebasetoken = await Firetools.gettingtoken();
                            try{
                              accountCreating3(
                                number: widget.number,
                                password: _pass.text,
                                firebase: _firebasetoken,
                                otp: int.parse(_otp.text));
                            } catch(exception){
                              setState(() {
                              err = "Please enter correct otp";
                              isButtonSelected = false;
                            });  
                            } 
                          }else{
                            setState(() {
                              err = "Password are not matching";
                              isButtonSelected = false;
                            });
                          }} else{
                            setState(() {
                              err = "Please fill all the fields";
                              isButtonSelected = false;
                            });
                          }
                            
                          },
                    child: isButtonSelected
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.pink,
                          ))
                        : const Text(
                            'Set',
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF000000)),
                          ))
            ],
          );
        });
  }

  final TextEditingController _otp = TextEditingController();
  bool isButtonSelected = false;
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFf8843d),
          elevation: 0.0,
        ),
        backgroundColor: const Color(0xFFf8843d),
        body: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                cursorColor: Colors.white,
                controller: _otp,
                maxLength: 30,
                decoration: InputDecoration(
                  fillColor: const Color(0xFF7f7f7f),
                  filled: true,
                  icon: const Icon(Icons.key_off_rounded),
                  labelText: 'OTP',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 42, 41, 44),
                  ),
                  errorText: errorText,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              OutlinedButton(
                  onPressed: () {
                    _setPass();
                  },
                  child: const Text(
                    'SEND',
                    style: TextStyle(fontSize: 20, color: Color(0xFF000000)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
