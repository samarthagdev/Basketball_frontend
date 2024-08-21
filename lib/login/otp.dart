import 'dart:convert';
import 'package:basketball_frontend/main/Drawer/homepage.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/firebase.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';

class Otp extends StatefulWidget {
  final String name;
  final String username;
  final String number;
  final  String password;
  
  const Otp(
      {Key? key,
      required this.name,
      required this.username,
      required this.number,
      required this.password})
      : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  Future<void> accountCreating3(
      {
      required String name,
      required String username,
      required String number,
      required String password,
      required int otp,
      required firebase,}) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/creating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'uniId': username,
        'displayName': name,
        'number': number,
        'password': password,
        'otp':otp,
        'firebase':firebase,
      }),
    );
    if(response.statusCode == 200){
      var res1 = jsonDecode(response.body);
      var box = await Hive.openBox('details');
      box.put('personal', {'uniId': username,
                          'Name': name,
                          'photoUrl': res1['profile_pic'],
                          'number': res1['number'],
                          'token': res1['token'],
                          'method': 'custom'});
      isButtonSelected = false;
      Navigator.pushReplacement(
          context,
          CustomPageRoute(
            child: const HomePage(),
            direction: AxisDirection.left
          ));
    }
    else{
      setState(() {
        isButtonSelected = false;
      });
      throw Exception('There is something Wrong');
    }

  }

  final TextEditingController _otp = TextEditingController();
  bool isButtonSelected = false;
  @override
  Widget build(BuildContext context) {
    String errorText = '';
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
              StatefulBuilder(
                builder: (context, innerState) {
                  return OutlinedButton(
                      onPressed:isButtonSelected?null: () async {
                        if(_otp.text.isNotEmpty){
                          innerState((){
                            isButtonSelected = true;
                          });
                          var _firebasetoken = await Firetools.gettingtoken();
                          try{
                            int otp = int.parse(_otp.text);
                            accountCreating3(otp: otp, name: widget.name, username: widget.username, number: widget.number, password: widget.password, firebase:_firebasetoken);
                          } catch(exception){
                            innerState(() {
                              isButtonSelected = false;
                            });
                          }
                      
                        }
                        },
                      child:isButtonSelected?const Center(child:CircularProgressIndicator(color: Colors.pink,)):const Text(
                        'SEND',
                        style: TextStyle(fontSize: 20, color: Color(0xFF000000)),
                      ));
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
