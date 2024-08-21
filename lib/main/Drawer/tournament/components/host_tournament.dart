import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:showcaseview/showcaseview.dart';

class HostTournament extends StatefulWidget {
  const HostTournament({Key? key, required this.pageName}) : super(key: key);
  final String pageName;
  @override
  State<HostTournament> createState() => _HostTournamentState();
}

class _HostTournamentState extends State<HostTournament> {
  Future<void> _hostingTournament() async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/mainapp/creatingtournament'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tour_name': _tourName.text,
        'tour_venue': _venue.text,
        'tour_description': _description.text,
        'tour_date': _doh.text,
        'tour_category': dropdownValue,
        'tour_owner': _userName,
        'tour_invitation': invitationList,
        'tour_referee': refereeList,
        'is_challenge': isChallenge
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Tournament Created")));
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

  final TextEditingController _tourName = TextEditingController();
  final TextEditingController _venue = TextEditingController();
  TextEditingController _owner = TextEditingController();
  TextEditingController _doh = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _search = TextEditingController();
  List<dynamic> refereeList = [];
  List<dynamic> invitationList = [];
  List<String> refereeList1 = [];
  List<String> invitationList1 = [];
  String searchtext = '';
  late String err;
  late String dropdownValue;
  String whichBody = 'info';
  late final String _userName;
  bool isChallenge = false;
  DateTime date = DateTime.now();
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.28, 40),
      maximumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 40),);

  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.28, 40),
      maximumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 40),);
  bool isButtonSelected = false;
  late BuildContext tour;
  @override
  void initState() {
    super.initState();
    _gettingData();
    if (widget.pageName == 'Challenge Teams') {
      isChallenge = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.pageName == 'Challenge Teams'){
        ThemeHelper().intro(s: [key1, key2, key3], boxName: "challanges", context: tour);
      } else{
        ThemeHelper().intro(s: [key1, key2, key3], boxName: "hostTournament", context: tour);
      }
    });
  }

  _gettingData() {
    _userName = DataProvider.gettingdatafromHive['id'];
    _owner = TextEditingController(text: _userName);
  }

  @override
  Widget build(BuildContext context) {
    _doh = TextEditingController(
        text: Provider.of<HostTournamentProvider>(context).gettingDate);
    dropdownValue =
        Provider.of<HostTournamentProvider>(context).gettingdropdown;
    err = Provider.of<HostTournamentProvider>(context).gettingerr;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          tour = context;
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
                title: Text(widget.pageName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              body: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Column(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    height: 70,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Showcase(
                            key: key1,
                            description:widget.pageName == 'Challenge Teams'?"Fill up the below information to host the challenge": "Fill up the below information to host the tournament",
                            descTextStyle: const TextStyle(
                                fontSize: 15, 
                                fontWeight: FontWeight.w600
                              ),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    whichBody = 'info';
                                    searchtext = '';
                                  });
                                  Provider.of<SearchProvider>(context, listen: false)
                                      .settingSearch([]);
                                },
                                child: const Text('Info'),
                                style: whichBody == 'info' ? _style1 : _style2),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Showcase(
                            key: key2,
                            description:widget.pageName == 'Challenge Teams'?"Send request to minimum 3 scorer.\nYou can request to more scorer in -> mytournament after you host the Challenge.\n\nNote: scorer should have a player account"
                            :"Send request to minimum 3 scorer.\nYou can request to more scorer in -> mytournament after you host the Tournamment.\n\nNote: scorer should have a player account",
                            descTextStyle: const TextStyle(
                                fontSize: 15, 
                                fontWeight: FontWeight.w600
                              ),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    whichBody = 'referee';
                                    searchtext = '';
                                  });
                                  Provider.of<SearchProvider>(context, listen: false)
                                      .settingSearch([]);
                                },
                                child: const Text('Scorer'),
                                style: whichBody == 'referee' ? _style1 : _style2),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Showcase(
                            key: key3,
                            description: widget.pageName == 'Challenge Teams'? "You can send the invitaion to diffrent team.\nYou can also send invitaiton after hosting the challenge -> mytournament":
                            "You can send the invitaion to diffrent team.\nYou can also send invitaiton after hosting the tournament -> mytournament",
                            descTextStyle: const TextStyle(
                                fontSize: 15, 
                                fontWeight: FontWeight.w600
                              ),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    whichBody = 'invitation';
                                    searchtext = '';
                                  });
                                  Provider.of<SearchProvider>(context, listen: false)
                                      .settingSearch([]);
                                },
                                child: const Text('Invitation'),
                                style: whichBody == 'invitation' ? _style1 : _style2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: lowerBody()),
                ]),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget lowerBody() {
    if (whichBody == 'info') {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              err,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(
              height: 5,
            ),
            _fields(
                e: true,
                name: widget.pageName == 'Challenge Teams'
                    ? 'Challenge Name'
                    : 'Tournament Name',
                variable: _tourName,
                len: 70),
            _fields(
                e: false,
                name: widget.pageName == 'Challenge Teams'
                    ? 'Challenger Name'
                    : 'Tournament Host Name',
                variable: _owner,
                len: 30),
            _fields(e: true, name: 'Venue', variable: _venue, len: 200),
            const SizedBox(
              height: 5,
            ),
            _choosingCategory(dropdownValue),
            _field1(name: 'Date of Starting', variable: _doh, context: context),
            _fields2(
                name: 'Other Information like Prizes, contact details',
                variable: _description),
            const SizedBox(
              height: 15,
            ),
            StatefulBuilder(builder: (context, innerState) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF003366)),
                  onPressed: isButtonSelected
                      ? null
                      : () {
                          if (refereeList.length >= 3) {
                            if (_tourName.text.isNotEmpty &&
                                _doh.text.isNotEmpty &&
                                _venue.text.isNotEmpty &&
                                _description.text.isNotEmpty) {
                              innerState(() {
                                isButtonSelected = true;
                              });
                              _hostingTournament();
                            } else {
                              Provider.of<HostTournamentProvider>(context,
                                      listen: false)
                                  .settingerr('Fill all the Fields');
                            }
                          } else {
                            Provider.of<HostTournamentProvider>(context,
                                    listen: false)
                                .settingerr(
                                    'Minimum 3 Scorer should be selected');
                          }
                        },
                  child: isButtonSelected
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.pink),
                        )
                      : widget.pageName == 'Challenge Teams'
                          ? const Text('Challenge')
                          : const Text('Host'));
            }),
            const SizedBox(height: 80,)
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _search,
              cursorColor: Colors.white,
              onChanged: (value) {
                if (!searchtext.startsWith(value)) {
                  searchtext = value;
                  if (whichBody == 'invitation') {
                    Connectivity.sendsock(
                        {'type': 'search_team', 'data': value});
                  } else {
                    Connectivity.sendsock(
                        {'type': 'search_player', 'data': value});
                  }
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
                labelText: whichBody != 'invitation'?'Search for player id, place':'Search for team name, place',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 42, 41, 44),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ),
          _searchBody()
        ],
      );
    }
  }

  Widget _searchBody() {
    List<dynamic> s = Provider.of<SearchProvider>(context).gettingsearchbody;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
          children: s.map((e) {
            if (whichBody == 'invitation') {
              e['pic'] = e['team_pic'];
              e['userName'] = e['team_name'] ?? '';
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                trailing: StatefulBuilder(builder: (context, innerState) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0e2f44),
                      ),
                      onPressed: () {
                        if (whichBody == 'invitation') {
                          if (!invitationList.contains(e)) {
                            e['status'] = 'pending';
                            invitationList.add(e);
                            innerState(() {
                              invitationList1.add(e['team_id']);
                            });
                          }
                        } else {
                          if (!refereeList.contains(e)) {
                            e['status'] = 'pending';
                            refereeList.add(e);
                            innerState(() => refereeList1.add(e['userName']));
                          }
                        }
                      },
                      child: whichBody == 'invitation'
                          ? invitationList1.contains(e['team_id'])
                              ? const Text('Invited')
                              : const Text('Invite')
                          : refereeList1.contains(e['userName'])
                              ? const Text('Selected')
                              : const Text('select'));
                }),
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
      ),
    );
  }

  Widget _fields(
      {required String name,
      required TextEditingController variable,
      required int len,
      required bool e}) {
    return TextFormField(
      enabled: e,
      cursorColor: Colors.white,
      controller: variable,
      maxLength: len,
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
        Provider.of<HostTournamentProvider>(context, listen: false)
            .settingdropdown(value!);
      },
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
            firstDate: DateTime.now().subtract(const Duration(days: 0)),
            lastDate: DateTime(date.year + 1, date.month + 1));
        if (result != null) {
          final DateFormat formatter = DateFormat('dd-MM-yyyy');
          Provider.of<HostTournamentProvider>(context, listen: false)
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
          icon: const Icon(CupertinoIcons.calendar),
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

  Widget _fields2({
    required String name,
    required TextEditingController variable,
  }) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: variable,
      maxLines: 6,
      maxLength: 400,
      decoration: InputDecoration(
        fillColor: const Color(0xFF7f7f7f),
        filled: true,
        icon: const Icon(Icons.notes),
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
}
