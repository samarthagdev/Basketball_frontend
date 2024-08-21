import 'package:basketball_frontend/main/BottomNavigationBar/profile/team_profile.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class TeamJoin extends StatefulWidget {
  const TeamJoin({Key? key}) : super(key: key);

  @override
  State<TeamJoin> createState() => _TeamJoinState();
}

class _TeamJoinState extends State<TeamJoin> {
  Future<void> _joinTeam(
      {required String teamId, required String userName}) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/mainapp/joiningteam'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'team_id': teamId, 'userName': userName}),
    );
    if (response.statusCode == 200) {
      pending.add(teamId);
      Provider.of<JoinTeamProvider>(context, listen: false)
          .settingPending(pending);
    } else {
      throw Exception('There is some error');
    }
  }

  String searchtext = '';
  late List<dynamic> searchBody;
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFFcc0000),
      // minimumSize: const Size(50, 30),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: Color(0xFFcc0000))));
  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFcc0000),
      // minimumSize: const Size(50, 30),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: Color(0xFFcee7ea))));
  late final String _username;
  bool isPlayer = false;
  late List<dynamic> pending;

  @override
  void initState() {
    super.initState();
    _gettingProfileData();
  }

  _gettingProfileData() {
    _username = DataProvider.gettingdatafromHive['id'];
    String? _height = DataProvider.gettingdatafromHive['hei'];
    if (_height != '') {
      isPlayer = true;
      Connectivity.sendsock({'type': 'pending_request', 'data': _username});
    }
  }

  @override
  Widget build(BuildContext context) {
    searchBody = Provider.of<SearchProvider>(context).gettingsearchbody;
    pending = Provider.of<JoinTeamProvider>(context).gettingPending;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: const Color(0xFFf8843d),
          elevation: 1,
          centerTitle: true,
          title: const Text('Join Team',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                cursorColor: Colors.white,
                onChanged: (value) {
                  if (!searchtext.startsWith(value)) {
                    searchtext = value;
                    Connectivity.sendsock(
                        {'type': 'search_team', 'data': value});
                  } else if (searchtext.startsWith(value)) {
                    searchtext = value;
                  }
                },
                maxLength: 30,
                decoration: const InputDecoration(
                  fillColor: Color(0xFF7f7f7f),
                  filled: true,
                  suffixIcon: Icon(CupertinoIcons.search),
                  labelText: 'Search for Team',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 42, 41, 44),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
            body3(context)
          ],
        ));
  }

  Widget body3(BuildContext context) {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 25),
          child: ListView(
            children: searchBody.map((e) {
              bool chekingRequest = pending.contains(e['team_id']);
              return InkWell(
                onTap: () {
                  Provider.of<TeamProfileProvider>(context, listen: false)
                      .settingTeamProfile({});
                  Navigator.push(
                      context,
                      CustomPageRoute(
                          child: TeamProfile(
                            id: e['team_id'],
                            pic: e['team_pic'],
                          ),
                          direction: AxisDirection.left));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    trailing: ElevatedButton(
                        style: chekingRequest ? _style2 : _style1,
                        onPressed: () {
                          if (isPlayer && !chekingRequest) {
                            _joinTeam(
                                teamId: e['team_id'], userName: _username);
                          }
                        },
                        child: chekingRequest
                            ? const Text('Requested')
                            : const Text('Join')),
                    leading: e['team_pic'] != null
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                'https://www.hoopster.in/media/${e['team_pic']}'),
                          )
                        : const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFffd700),
                          ),
                    title: Text(e['team_name'] ?? '',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                        )),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}
