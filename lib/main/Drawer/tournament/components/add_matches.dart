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

class AddMatches extends StatefulWidget {
  final String tourId;
  const AddMatches({Key? key, required this.tourId}) : super(key: key);

  @override
  State<AddMatches> createState() => _AddMatchesState();
}

class _AddMatchesState extends State<AddMatches> {
  
  Future<void> _addingTournamentMatches() async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/mainapp/addmatches'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tour_id':widget.tourId,
        'match_details': matchDetail,
        'date': date1,
      }),
    );
    if (response.statusCode == 200) {
      isButtonSelected = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Matches updated")));
      Navigator.pop(context);
    } else {
      setState(() {
        isButtonSelected = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("There is some error")));
    }
  }
  
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  late BuildContext addmatch;
  @override
  void initState() {
    Connectivity.sendsock(
        {'type': 'Get teams for matches', 'data': widget.tourId});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeHelper().intro(s: [key1, key2, key3], boxName: "addmatch_intro", context: addmatch);
    });
    super.initState();
  }

  List<dynamic> matchDetail = [];
  late Map<String, dynamic> matchTeams;
  DateTime date = DateTime.now();
  String date1 = 'Please Select Date';
  List<int> clear1 = [];
  bool isButtonSelected = false;
  @override
  Widget build(BuildContext context) {
    matchTeams = Provider.of<MatchesProvider>(context).gettingMatchTeams;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          addmatch = context;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
              backgroundColor: const Color(0xFFf8843d),
              elevation: 1,
              centerTitle: true,
              title: const Text('Add Matches',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            floatingActionButton: 
            Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Showcase(
                  key: key3,
                        description: "Save the matches that you have created before adding next date.",
                        descTextStyle: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600
                          ),
                  child: StatefulBuilder(
                    builder: (context, innerState) {
                      return FloatingActionButton.extended(
                      heroTag: 'btn1',
                      backgroundColor: const Color(0xFFf8843d),
                      onPressed:isButtonSelected?null:() {
                        if(date1 != 'Please Select Date' && clear1.isEmpty){
                          innerState((){
                            isButtonSelected = true;
                          });
                          _addingTournamentMatches();
                        }
                      },
                      label:isButtonSelected?const Center(child: CircularProgressIndicator(color: Colors.pink,),): const Icon(Icons.save));
                    }
                  ),
                ),
                const SizedBox(height: 5,),
                Showcase(
                  key: key1,
                  description: "Tap on it to add matches.\n\nNOTE: You will not be able to add matches if the host have not yet stoped the team registration.",
                  descTextStyle: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600
                          ),
                  child: FloatingActionButton.extended(
                  heroTag: 'btn2',
                  backgroundColor: const Color(0xFF003366),
                  onPressed: () {
                    setState(() {
                      matchDetail.add({
                        'team A': {},
                        'team B': {},
                        'time': 'Please Select Time',
                      });
                    });
                  },
                  label: const Icon(Icons.add)),
                ),
              ],
            ),
            body: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(left: 10, right: 10,),
              child: Column(
                children: <Widget>[
                  Showcase(
                    key: key2,
                    description: "Select date before adding matches",
                    descTextStyle: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600
                          ), 
                    child: _field1(context: context)),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: _lowerBody(),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _field1({required BuildContext context}) {
    return InkWell(
        onTap: () async {
          DateTime? result = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now().subtract(const Duration(days: 0)),
              lastDate: DateTime(date.year + 1, date.month + 1));
          if (result != null) {
            final DateFormat formatter = DateFormat('dd-MM-yyyy');
            setState(() {
              date1 = formatter.format(result);
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
              color: const Color(0xFFeeeeee),
              borderRadius: BorderRadius.circular(20.0)),
          height: 80,
          width: MediaQuery.of(context).size.width * .4,
          child: Text(date1),
        ));
  }

  Widget _lowerBody() {
    return ListView.builder(
      itemCount: matchDetail.length,
      itemBuilder: ((context, index) {
        var detail= matchDetail[index];
        if(detail['team A'].isEmpty || detail['team B'].isEmpty || detail['time'] == 'Please Select Time'){
          if(!clear1.contains(index)){
          clear1.add(index);}
        }else{
          clear1.remove(index);
        }
        return Dismissible(
          background: Container(color: const Color(0xFFe10000),),
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
              matchDetail.removeAt(index);
              clear1.remove(index);
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10.0),
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.height * .7,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Material(
              color: clear1.contains(index)?const Color(0xFFf0f8ff) : const Color(0xFFc0c0c0),
              elevation: 3.0,
              borderRadius: BorderRadius.circular(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _teamSelect('team A', index),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'VS',
                        style: GoogleFonts.alumniSans(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      _teamSelect('team B', index),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 7, minute: 15),
                        initialEntryMode: TimePickerEntryMode.input,
                      );

                      if (newTime != null) {
                        final now = DateTime.now();
                        final dt = DateTime(now.year, now.month, now.day,
                            newTime.hour, newTime.minute);
                        final DateFormat formatter = DateFormat.jm();
                        setState(() {
                          matchDetail[index]['time'] = formatter.format(dt);
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFcbbeb5),
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 50,
                      width: MediaQuery.of(context).size.width * .45,
                      child: Text(matchDetail[index]['time']),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _teamSelect(String whichTeam, int index) {
    return DropdownButton<Map<String, dynamic>>(
      value: matchTeams['lis_team'].isEmpty || matchTeams['lis_team'] == null
          ? null
          : matchDetail[index][whichTeam].isEmpty
              ? null
              : matchDetail[index][whichTeam],
      hint: SizedBox(
        width: MediaQuery.of(context).size.width*.3,
        child: const Text('Please Select Team', overflow: TextOverflow.fade,)),
      items: matchTeams['lis_team']
          .map<DropdownMenuItem<Map<String, dynamic>>>((e) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: e,
          child: SizedBox(
        width: MediaQuery.of(context).size.width*.3,
        child: Text(e['team_name'], overflow: TextOverflow.fade,)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            if (whichTeam == 'team A') {
              matchDetail[index]['team A'] = value;
            } else if (whichTeam == 'team B') {
              matchDetail[index]['team B'] = value;
            }
          });
        }
      },
    );
  }
}
