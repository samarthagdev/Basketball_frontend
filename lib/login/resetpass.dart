import 'dart:convert';
import 'package:basketball_frontend/login/otp1.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';

class Reseting extends StatefulWidget {
  const Reseting({
    Key? key,
  }) : super(key: key);

  @override
  State<Reseting> createState() => _ResetingState();
}

class _ResetingState extends State<Reseting> {
  Future<void> accountCreating3() async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/getnum'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'number': _number.text,
      }),
    );
    if (response.statusCode == 200) {
      isButtonSelected = false;
      Navigator.pushReplacement(
          context,
          CustomPageRoute(
              child: Otp1(number: _number.text), direction: AxisDirection.left));
    } else {
      setState(() {
        isButtonSelected = false;
        errorText = "Either your number is not registerd or there is some error";
      });
      throw Exception('There is something Wrong');
    }
  }

  final TextEditingController _number = TextEditingController();
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
                controller: _number,
                maxLength: 10,
                decoration: InputDecoration(
                  fillColor: const Color(0xFF7f7f7f),
                  filled: true,
                  icon: const Icon(Icons.key_off_rounded),
                  labelText: 'Number',
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
              StatefulBuilder(builder: (context, innerState) {
                return OutlinedButton(
                    onPressed: isButtonSelected
                        ? null
                        : () async {
                            if (_number.text.isNotEmpty) {
                              innerState(() {
                                isButtonSelected = true;
                              });
                              try{
                                int.parse(_number.text);
                                if(_number.text.length == 10){
                                accountCreating3();
                              } else{
                                setState(() {
                                isButtonSelected = false;
                                errorText = "Please enter 10 digit";  
                                });
                              }
                              } catch (exception){
                                setState(() {
                                  isButtonSelected = false;
                                  errorText = "Please enter only numbers";
                                });
                              }
                              
                            } else{
                              setState(() {
                                errorText = "Please add number";
                              });
                            }
                          },
                    child: isButtonSelected
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.pink,
                          ))
                        : const Text(
                            'SEND',
                            style: TextStyle(
                                fontSize: 20, color: Color(0xFF000000)),
                          ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
