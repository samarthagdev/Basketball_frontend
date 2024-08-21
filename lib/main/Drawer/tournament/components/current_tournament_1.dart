import 'dart:convert';
import 'package:basketball_frontend/main/Drawer/tournament/components/individual_match_info.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SpecificTournament extends StatefulWidget {
  final String tourId;
  final String tourName;
  final String pageName;
  const SpecificTournament(
      {Key? key,
      required this.tourId,
      required this.tourName,
      required this.pageName})
      : super(key: key);

  @override
  State<SpecificTournament> createState() => _SpecificTournamentState();
}

class _SpecificTournamentState extends State<SpecificTournament> {
  @override
  void initState() {
    Connectivity.sendsock(
        {'type': 'All Matches of Tour', 'data': widget.tourId});
    super.initState();
  }

  late List<dynamic> allMatches;
  String selectedDate = '';
  List<String> date = [];
  @override
  Widget build(BuildContext context) {
    allMatches =
        Provider.of<CurrentTournamentProvider>(context).gettingAllMatches;

    return Scaffold(
       appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 1,
        centerTitle: true,
        title: Text(widget.tourName,
        textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
      body: allMatches.isEmpty?
      const Center(
        child: Text("No matches have been added yet", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
      )
      : Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: <Widget>[
            SizedBox(width: double.infinity, height: 30, child: _upperBody()),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: _lowerBody()),
          ],
        ),
      ),
    );
  }

  Widget _upperBody() {
    for (var x in allMatches) {
      if (!date.contains(x['date'])) {
        date.add(x['date']);
      }
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: date.map((e) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedDate = e;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * .2,
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: (selectedDate == '' && date[0] == e) ||
                                selectedDate == e
                            ? const Color(0xFFc2b6b8)
                            : const Color(0xFFCC00DD),
                        width: 3.0,
                        style: BorderStyle.solid))),
            child: Text(e,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        );
      }).toList(),
    );
  }

  Widget _lowerBody() {
    List<dynamic> matchBetween = [];
    for (var x in allMatches) {
      if (selectedDate == '') {
        if (x['date'] == date[0]) {
          matchBetween.add({
            'id': x['match_id'],
            'between': json.decode(x['match_between'])
          });
        }
      } else {
        if (x['date'] == selectedDate) {
          matchBetween.add({
            'id': x['match_id'],
            'between': json.decode(x['match_between'])
          });
        }
      }
    }
    return ListView(
      scrollDirection: Axis.vertical,
      children: matchBetween.map((e) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                CustomPageRoute(
                    child: IndividualMatchInfo(
                      matchBetween: e['between'],
                      matchId: e['id'],
                      pageName: widget.pageName,
                    ),
                    direction: AxisDirection.left));
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10.0),
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.height * .8,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Material(
              color: const Color(0xFFc0c0c0),
              elevation: 3.0,
              borderRadius: BorderRadius.circular(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFc39797),
                            borderRadius: BorderRadius.circular(20.0)),
                        height: 70,
                        width: MediaQuery.of(context).size.width * .35,
                        child: Text(e['between']['team A']['team_name']),
                      ),
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
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFc39797),
                            borderRadius: BorderRadius.circular(20.0)),
                        height: 70,
                        width: MediaQuery.of(context).size.width * .35,
                        child: Text(e['between']['team B']['team_name']),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFcbbeb5),
                        borderRadius: BorderRadius.circular(20.0)),
                    height: 50,
                    width: MediaQuery.of(context).size.width * .45,
                    child: Text(e['between']['time']),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
