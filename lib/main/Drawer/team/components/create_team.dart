import 'dart:convert';
import 'dart:io';
import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({Key? key}) : super(key: key);

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  Future<void> teamCreating(
      {required String name,
      required String level,
      required String owner,
      required String player,
      required String city,
      required String path}) async {
    final fields = <String, String>{
      'teamName': name,
      'level': level,
      'ownerName': owner,
      'players': player,
      'address': city
    };
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.hoopster.in/mainapp/teamcreating'))
      ..headers.addAll(header)
      ..fields.addAll(fields);
    if (!imagePath!.startsWith('https://www.hoopster.in/')) {
      request.files.add(await http.MultipartFile.fromPath('pic', path,
          filename: _name.text, contentType: MediaType('image', 'png')));
    }
    http.Response response =
        await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      // var res = json.decode(response.body);
      isButtonSelected = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Team Created")));
      Navigator.pop(context);
    } else {
      setState(() {
        isButtonSelected = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("There is some error")));
    }
  }

  final TextEditingController _name = TextEditingController();
  TextEditingController _owner = TextEditingController();
  TextEditingController _city = TextEditingController();
  late final Map<String, dynamic> _info;
  late String dropdownValue;
  late String dropdownValue1;
  XFile? image;
  String? imagePath;
  String whichBody = 'Body1';
  String searchtext = '';
  late List<dynamic> selectedPlayer;
  List<String> playerName= [];
  late String err;
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  bool isButtonSelected = false;
  @override
  void initState() {
    super.initState();
    _gettingHive();
  }

  void _gettingHive() {
    _info = DataProvider.gettingdatafromHive;
    _owner = TextEditingController(text: _info['id']);
    _city = TextEditingController(text: _info['city']);

    if (_city.text.isEmpty) _gettingLocation();
  }

  Future _gettingLocation() async {
    String _cityDetails = await ThemeHelper().location_();
    _city.text = _cityDetails;
  }

  @override
  Widget build(BuildContext context) {
    err = Provider.of<CreateTeamProvider>(context).gettingErr;
    selectedPlayer = Provider.of<CreateTeamProvider>(context).gettingplayer;
    dropdownValue = Provider.of<CreateTeamProvider>(context).dropdownValue;
    dropdownValue1 = Provider.of<CreateTeamProvider>(context).dropdownValue1;
    if(selectedPlayer.isNotEmpty){
      playerName.clear();
      for(var x in selectedPlayer){
        playerName.add(x['userName']);
      }
    }
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
            title: const Text('Creating Team',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          body: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        style: whichBody == 'Body1' ? _style1 : _style2,
                        onPressed: () {
                          setState(() {
                            whichBody = 'Body1';
                          });
                        },
                        child: const Text('Other Information')),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: whichBody == 'Body1' ? _style2 : _style1,
                        onPressed: () {
                          setState(() {
                            whichBody = 'Body2';
                          });
                        },
                        child: const Text('Select Players')),
                  ],
                ),
              ),
              Expanded(child: whichBody == 'Body1' ? body1() : body2())
            ],
          )),
    );
  }

  Widget body1() {
    var _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                err,
                textAlign: TextAlign.center,
              ),
            ),
            _teamPic(),
            const SizedBox(height: 10),
            _fields(name: 'Team Name', variable: _name, e: true),
            _fields(name: 'Owner', variable: _owner, e: false),
            _choosingCategory(dropdownValue),
            _location(),
            const SizedBox(height: 10),
            StatefulBuilder(builder: (context, innerState) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF003366),
                      minimumSize: Size(_width * 0.35, 50)),
                  onPressed: isButtonSelected
                      ? null
                      : () {
                          int minimumrequire = dropdownValue == '5X5' ? 7 : 3;
                          int maximumrequire = dropdownValue == '5X5' ? 11 : 5;
                          if (minimumrequire <= selectedPlayer.length &&
                              maximumrequire >= selectedPlayer.length) {
                            if (_city.text.isNotEmpty &&
                                _name.text.isNotEmpty &&
                                imagePath != null) {
                              List<dynamic> selectedPlayer1 = [];
                              for (var x in selectedPlayer) {
                                selectedPlayer1.add(json.encode(x));
                              }
                              innerState(() {
                                isButtonSelected = true;
                              });
                              teamCreating(
                                  city: _city.text,
                                  owner: _owner.text,
                                  level: dropdownValue,
                                  name: _name.text,
                                  path: imagePath!,
                                  player: selectedPlayer1.toString());
                            } else {
                              Provider.of<CreateTeamProvider>(context,
                                      listen: false)
                                  .settingerr('Fill all the fields');
                            }
                          } else {
                            if (dropdownValue == '5X5') {
                              Provider.of<CreateTeamProvider>(context,
                                      listen: false)
                                  .settingerr(
                                      'Minimum 7 player and Maximum 11 player should be selected');
                            } else {
                              Provider.of<CreateTeamProvider>(context,
                                      listen: false)
                                  .settingerr(
                                      'Minimum 3 player and Maximum 5 player should be selected');
                            }
                          }
                        },
                  child: isButtonSelected
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                          ),
                        )
                      : const Text(
                          'Create',
                          style: TextStyle(fontSize: 15),
                        ));
            })
          ],
        ),
      ),
    );
  }

  Widget body2() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          _search(),
          _select(dropdownValue1),
          Expanded(
              child:
                  dropdownValue1 == 'select' ? _searchBody() : _selectedBody())
        ],
      ),
    );
  }

  Widget _teamPic() {
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
        child: imagePath != null
            ? Container(
                height: 100,
                width: 170,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(imagePath!)), fit: BoxFit.fill),
                    border: Border.all(
                        width: 1.0,
                        color: Colors.black,
                        style: BorderStyle.solid)),
              )
            : Container(
                alignment: Alignment.center,
                height: 100,
                width: 170,
                color: const Color(0xFFfaca39),
                child: const Text(
                  'Please Select a Flag for Team',
                  textAlign: TextAlign.center,
                ),
              ));
  }

  Widget _fields(
      {required String name,
      required TextEditingController variable,
      required bool e}) {
    return TextFormField(
      enabled: e,
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
    );
  }

  Widget _choosingCategory(dropdownValue) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem(
          value: '3X3',
          child: Text('3X3'),
        ),
        DropdownMenuItem(
          value: '5X5',
          child: Text('5X5'),
        ),
      ],
      onChanged: (value) {
        Provider.of<CreateTeamProvider>(context, listen: false)
            .settinglevel(value!);
      },
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

  Widget _search() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        cursorColor: Colors.white,
        onChanged: (value) {
          if (!searchtext.startsWith(value)) {
            searchtext = value;
            Connectivity.sendsock({'type': 'search_player', 'data': value});
          } else if (searchtext.startsWith(value)) {
            searchtext = value;
          }
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {},
              iconSize: 35,
              color: Colors.white,
              icon: const Icon(Icons.search)),
          fillColor: const Color(0xFF7f7f7f),
          filled: true,
          labelText: 'Search for player id, place',
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

  Widget _select(dropdownValue) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem(
          value: 'select',
          child: Text('Select Player'),
        ),
        DropdownMenuItem(
          value: 'selected',
          child: Text('Selected Player'),
        ),
      ],
      onChanged: (value) {
        Provider.of<CreateTeamProvider>(context, listen: false)
            .settingdropdown1(value!);
      },
    );
  }

  Widget _selectedBody() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: selectedPlayer == []
          ? const Text('No Player Selected')
          : ListView(
              children: selectedPlayer.map((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0e2f44),
                      ),
                      onPressed: () {
                        playerName.remove(e['userName']);
                        Provider.of<CreateTeamProvider>(context, listen: false)
                            .settingplayer(e1: e, from: 'subtract');
                      },
                      child: const Text('Deselect'),
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://www.hoopster.in/media/${e['pic']}'),
                    ),
                    title: Text(e['userName'],
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                        )),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _searchBody() {
    List<dynamic> s = Provider.of<SearchProvider>(context).gettingsearchbody;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ListView(
        children: s.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF0e2f44),
                ),
                onPressed: () {
                  if (!selectedPlayer.contains(e)) {
                    e['status'] = 'pending';
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .settingplayer(e1: e, from: 'add');
                  }
                },
                child: playerName.contains(e['userName']) ?const Text("Selected"):const Text('Select'),
              ),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage('https://www.hoopster.in/media/${e['pic']}'),
              ),
              title: Text(e['userName'],
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }
}
