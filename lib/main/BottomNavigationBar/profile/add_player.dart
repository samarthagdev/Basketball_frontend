import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ExistingTeamAdd extends StatefulWidget {
  final String teamid;
  final String owner;
  const ExistingTeamAdd({Key? key, required this.teamid, required this.owner}) : super(key: key);

  @override
  State<ExistingTeamAdd> createState() => _ExistingTeamAddState();
}

class _ExistingTeamAddState extends State<ExistingTeamAdd> {

  Future<void> _addPlayer(
      {required Map<String, dynamic> playerInfo}) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/mainapp/addingplayer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, dynamic>{'team_id': widget.teamid, 'player': playerInfo}),
    );
    if (response.statusCode == 200) {
       pending.add(playerInfo['userName']);
      Provider.of<JoinTeamProvider>(context, listen: false)
          .settingPending(pending);
    } else {
      throw Exception('There is some error');
    }
  }


  String searchtext = '';
  late List<dynamic> pending;
  
  @override
  void initState() {
    super.initState();
    _gettingData();
  }
  _gettingData(){
    Connectivity.sendsock({'type':'pending_request1', 'data':widget.owner, 'team': widget.teamid});
  }

  @override
  Widget build(BuildContext context) {
    pending = Provider.of<JoinTeamProvider>(context).gettingPending;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFf8843d),
          title: const Text('Add Player to your Team'),
        ),
      body: Column(
          children: <Widget>[
            const SizedBox(height: 20,),
            _search(),
            Expanded(child: _searchBody())
          ],
        ),
    );   
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

  Widget _searchBody() {
    List<dynamic> s = Provider.of<SearchProvider>(context).gettingsearchbody;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ListView(
              children: s.map((e) {
                bool isCheking = pending.contains(e['userName']);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: isCheking? const Color(0xFFcc0000):const Color(0xFF0e2f44),
                      ),
                      onPressed: () {
                        if (!isCheking){
                          e['status'] = 'pending';
                          _addPlayer(playerInfo: e);}
                      },
                      child: isCheking?const Text('Requested'): const Text('Select'),
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
}