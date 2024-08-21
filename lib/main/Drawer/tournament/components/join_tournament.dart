import 'package:basketball_frontend/main/Drawer/tournament/components/join_tournament_body.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:showcaseview/showcaseview.dart';

class JoinTournament extends StatefulWidget {
  final List<dynamic> teams;
  const JoinTournament({Key? key, required this.teams}) : super(key: key);

  @override
  State<JoinTournament> createState() => _JoinTournamentState();
}

class _JoinTournamentState extends State<JoinTournament> {

  Future<void> _joinTournament(
      {required String teamId, required String tourId}) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/mainapp/tourjoining'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{
            'team_id': teamId, 
            'tour_id': tourId}),
    );
    if (response.statusCode == 200) {
      lisTour.add(tourId);
      Provider.of<JoinTournamentProvider>(context, listen: false)
          .settingTourId(lisTour);
    } else {
      throw Exception('There is some error');
    }
  }

  final TextEditingController _search = TextEditingController();
  String searchtext = '';
  late List<dynamic> lisTour;
  late String _dropdownValue; 
  GlobalKey key1 = GlobalKey();
  late BuildContext jointour;
  @override
  void initState() {
    if(widget.teams.isNotEmpty){
      Connectivity.sendsock(
        {'type': 'pending tour teams', 'data': widget.teams[0]['team_id']});
    _dropdownValue = widget.teams[0]['team_id'];
    }else{
      _dropdownValue = 'None';
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeHelper().intro(s: [key1], boxName: "joinTour", context: jointour);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lisTour = Provider.of<JoinTournamentProvider>(context).getTourId;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          jointour = context;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
              backgroundColor: const Color(0xFFf8843d),
              elevation: 1,
              actions: [
                StatefulBuilder(builder: (context, innerState) {
                  return Showcase(
                    key: key1,
                    description: "To Join a Tournament you need to be owner/creater of team.",
                    descTextStyle: const TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w600
                      ),
                    child: DropdownButton<String>(
                      value: widget.teams.isEmpty ? 'None' : _dropdownValue,
                      items: widget.teams.map((e) {
                        return DropdownMenuItem<String>(
                          value: e['team_id'],
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *.3,
                            child: Text(e['team_name'], overflow: TextOverflow.fade,),),
                        );
                      }).toList(),
                      onChanged: (value) {
                        innerState(() => _dropdownValue = value!);
                        Connectivity.sendsock({
                          'type': 'pending tour teams',
                          'data': value
                        });
                      },
                    ),
                  );
                })
              ],
              title: const Text('Join Tournament',
                  style: TextStyle(fontSize: 15,)),
            ),
            
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _search,
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      if (!searchtext.startsWith(value)) {
                        searchtext = value;
                        Connectivity.sendsock(
                            {'type': 'search_tournament', 'data': value, 'data1':true});
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
                      labelText: 'Search for Tournament Name, Place, Host Name',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 42, 41, 44),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                ),
                lowerBody()
              ],
            ),
          );
        }
      ),
    );
  }

  Widget lowerBody() {
    List<dynamic> s = Provider.of<SearchProvider>(context).gettingsearchbody;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
          children: s.map((e) {
            return InkWell(
              onTap: () {
                Provider.of<JoinTournamentProvider>(context, listen: false)
                    .settingDetails({});
                Navigator.push(
                    context,
                    CustomPageRoute(
                        child: JoinTourDetails(
                              tourId: e['tour_id'],
                            ), direction: AxisDirection.left));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF0e2f44),
                    ),
                    onPressed: () {
                      if(!lisTour.contains(e['tour_id']) && _dropdownValue != 'None'){
                        _joinTournament(teamId: _dropdownValue, tourId: e['tour_id']);
                      }
                    },
                    child: lisTour.contains(e['tour_id'])?const Text('Pending'):const Text('Join'),
                  ),
                  title: Text(e['tour_name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text(e['tour_owner'],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w300)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
