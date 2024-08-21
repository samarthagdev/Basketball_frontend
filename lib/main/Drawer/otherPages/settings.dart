import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> accountCreating2(
      {required String dob, required String gender}) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/account/otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'number': _num.text,
      }),
    );
    if (response.statusCode == 200) {
      isButtonSelected = false;
      _info['num'] = _num.text;
      otpBox(dob: dob, gender: gender);
    } else {
      throw Exception('There is some error');
    }
  }

  Future<void> playerCreating(
      {required String dob,
      required String gender,
      String otp = '0',
      required String path}) async {
    final fields = <String, String>{
      'number': _num.text,
      'otp': otp,
      'userName': _id.text,
      'dob': dob,
      'gender': gender,
      'height': _hei.text,
      'weight': _wei.text,
      'address': _city.text
    };
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.hoopster.in/mainapp/players'))
      ..headers.addAll(header)
      ..fields.addAll(fields);
    if (!imagePath!.startsWith('https://www.hoopster.in/')) {
      request.files.add(await http.MultipartFile.fromPath('pic', path,
          filename: _id.text, contentType: MediaType('image', 'png')));
    }
    http.Response response =
        await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var box = Hive.box('details');
      box.get('personal')['number'] = _num.text;
      box.get('personal')['photoUrl'] = res['pic'];
      box.put('player', <String, dynamic>{
        'dob': dob,
        'gender': gender,
        'height': _hei.text,
        'weight': _wei.text,
        'address': _city.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Player Created / Player Updated")));
      isButtonSelected = false;
      Navigator.pop(context);
    } else {
      setState(() {
        isButtonSelected = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("There is some error")));
    }
  }

  otpBox({required String dob, required String gender}) {
    String errorText = '';
    final ButtonStyle _button = OutlinedButton.styleFrom(
      backgroundColor: const Color(0xFFc6e2ff),
    );
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color(0xFFe5e5e5),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, innersetState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF4c4c4c),
              alignment: Alignment.center,
              content: SizedBox(
                height: MediaQuery.of(context).size.height * .2,
                child: TextFormField(
                  cursorColor: Colors.white,
                  controller: _otp,
                  maxLength: 30,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF7f7f7f),
                    filled: true,
                    icon: const Icon(CupertinoIcons.person),
                    labelText: 'OTP',
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
              ),
              actions: [
                OutlinedButton(
                  style: _button,
                  child: const Text('Approve',
                      style: TextStyle(
                        color: Color(0xFFff0000),
                      )),
                  onPressed: () async {
                    if (_otp.text.isNotEmpty && imagePath != null) {
                      playerCreating(
                          dob: dob,
                          gender: gender,
                          otp: _otp.text,
                          path: imagePath!);
                    } else {
                      innersetState(() {
                        errorText = 'Please fill the above field';
                      });
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  TextEditingController _id = TextEditingController();
  TextEditingController _num = TextEditingController();
  TextEditingController _city = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  TextEditingController _hei = TextEditingController();
  TextEditingController _wei = TextEditingController();
  DateTime date = DateTime(2022, 1, 1);
  late final Map<String, dynamic> _info;
  XFile? image;
  String? imagePath;
  bool isButtonSelected = false;
  final ButtonStyle _style = ElevatedButton.styleFrom(
      primary: const Color(0xFF003366),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  @override
  void initState() {
    super.initState();
    _gettingHive();
  }

  void _gettingHive() {
    _info = DataProvider.gettingdatafromHive;
    
    _id = TextEditingController(text: _info['id']);
    if(_info['num'] != null){
      _num = TextEditingController(text: _info['num']);
    }
    if(_info['hei'] != null){
     _hei = TextEditingController(text: _info['hei']);
    _wei = TextEditingController(text: _info['wei']);
    _city = TextEditingController(text: _info['city']);
    imagePath = _info['pic'] == ''?null:_info['pic'];
    }
    if (_city.text.isEmpty) _gettingLocation();
  }

  Future _gettingLocation() async {
    String _cityDetails = await ThemeHelper().location_();
    _city.text = _cityDetails;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _dob =
        TextEditingController(text: Provider.of<WholeApp>(context).gettingDate);
    String dropdownValue = Provider.of<WholeApp>(context).getvalue;
    String err1 = Provider.of<WholeApp>(context).gettingsettingerr;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: const Color(0xFFf8843d),
          elevation: 1,
          centerTitle: true,
          title: const Text('Player Account',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                _playerPic(),
                const SizedBox(
                  height: 10,
                ),
                Text(err1, style: const TextStyle(fontSize: 20)),
                _fields(name: 'Username', variable: _id, isEnabled: false),
                _fields(name: 'Number', variable: _num, isEnabled: true),
                _field1(
                    name: 'Date of Birth', variable: _dob, context: context),
                _gender(context, dropdownValue),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: _height(name: 'Height', variable: _hei)),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                        flex: 1,
                        child: _weight(name: 'Weight', variable: _wei)),
                  ],
                ),
                _location(),
                const SizedBox(
                  height: 35,
                ),
                StatefulBuilder(builder: (context, innerState) {
                  return ElevatedButton(
                      style: _style,
                      onPressed: isButtonSelected
                          ? null
                          : () {
                              if (imagePath == null) {
                                Provider.of<WholeApp>(context, listen: false)
                                    .settingerror('Please Select Image');
                              } else if (_num.text.isNotEmpty &&
                                  (_info['num'] == null ||
                                      _info['num'] != _num.text)) {
                                innerState(() {
                                  isButtonSelected = true;
                                });
                                accountCreating2(
                                    dob: _dob.text, gender: dropdownValue);
                              } else if (_id.text.isNotEmpty &&
                                  _num.text.isNotEmpty &&
                                  _city.text.isNotEmpty &&
                                  _dob.text.isNotEmpty &&
                                  _hei.text.isNotEmpty &&
                                  _wei.text.isNotEmpty &&
                                  imagePath != null) {
                                innerState(() {
                                  isButtonSelected = true;
                                });
                                playerCreating(
                                    dob: _dob.text,
                                    gender: dropdownValue,
                                    path: imagePath!);
                              } else {
                                Provider.of<WholeApp>(context, listen: false)
                                    .settingerror('Please fill all Fields');
                              }
                            },
                      child: isButtonSelected
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.pink,
                              ),
                            )
                          : const Text('Make Player/ Save Changes'));
                }),
                const SizedBox(height: 60,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fields(
      {required String name, required TextEditingController variable, required bool isEnabled }) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: variable,
      maxLength: 30,
      enabled: isEnabled,
      decoration: InputDecoration(
        fillColor: const Color(0xFF7f7f7f),
        filled: true,
        icon: const Icon(CupertinoIcons.person),
        labelText: name,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 42, 41, 44),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    );
  }

  Widget _field1(
      {required String name,
      required TextEditingController variable,
      required BuildContext context}) {
    return InkWell(
      onTap: () async {
        DateTime? result = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(1950),
            lastDate: DateTime(DateTime.now().year));
        if (result != null) {
          final DateFormat formatter = DateFormat('dd-MM-yyyy');
          Provider.of<WholeApp>(context, listen: false)
              .settingDate(formatter.format(result));
        }
      },
      child: TextFormField(
        enabled: false,
        cursorColor: Colors.white,
        controller: variable,
        maxLength: 30,
        decoration: InputDecoration(
          fillColor: const Color(0xFF7f7f7f),
          filled: true,
          icon: const Icon(CupertinoIcons.person),
          labelText: name,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 42, 41, 44),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }

  Widget _gender(BuildContext context, dropdownValue) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem(
          value: 'Male',
          child: Text('MALE'),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Text('FEMALE'),
        ),
      ],
      onChanged: (value) {
        Provider.of<WholeApp>(context, listen: false).changeValue(value!);
      },
    );
  }

  Widget _height(
      {required String name, required TextEditingController variable}) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: variable,
      maxLength: 4,
      decoration: InputDecoration(
        suffix: const Text('In Inch'),
        fillColor: const Color(0xFF7f7f7f),
        filled: true,
        icon: const Icon(CupertinoIcons.person),
        labelText: name,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 42, 41, 44),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    );
  }

  Widget _weight(
      {required String name, required TextEditingController variable}) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: variable,
      maxLength: 3,
      decoration: InputDecoration(
        suffix: const Text('In kg'),
        fillColor: const Color(0xFF7f7f7f),
        filled: true,
        icon: const Icon(CupertinoIcons.person),
        labelText: name,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 42, 41, 44),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    );
  }

  Widget _location() {
    return Stack(alignment: AlignmentDirectional.centerEnd, children: [
      TextFormField(
          enabled: false,
          controller: _city,
          decoration: const InputDecoration(
            fillColor: Color(0xFF7f7f7f),
            filled: true,
            icon: Icon(Icons.location_city),
            labelText: 'City Name',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 42, 41, 44),
            ),
            // errorText: errorText,
            hintText: 'City Name',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          )),
      CircleAvatar(
        backgroundColor: const Color(0xFFc6e2ff),
        child: IconButton(
          color: const Color(0xFFff0000),
          alignment: Alignment.centerRight,
          icon: const Icon(Icons.location_on),
          onPressed: () async {
            _gettingLocation();
          },
        ),
      ),
    ]);
  }

  Widget _playerPic() {
    return InkWell(
      onTap: () async {
        try {
          image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );
          if (image == null) return;
          imagePath = image!.path;
          setState(() => imagePath);
        } on PlatformException catch (e) {
          throw Exception(e);
        }
      },
      child: imagePath == null
          ? const CircleAvatar(
              backgroundColor: Color(0xFFfaca39),
              radius: 65,
              child: Text(
                'Please Select the Image',
                textAlign: TextAlign.center,
              ))
          : CircleAvatar(
              radius: 70,
              backgroundImage: imagePath!.startsWith('https://www.hoopster.in/')
                  ? NetworkImage(imagePath!, scale: 1)
                  : FileImage(
                      File(imagePath!),
                    ) as ImageProvider,
            ),
    );
  }
}
