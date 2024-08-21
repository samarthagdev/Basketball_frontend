import 'dart:convert';
import 'package:basketball_frontend/main/Drawer/tournament/components/add_matches.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/add_score.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartingTourbyRef extends StatefulWidget {
  final String tourId;
  const StartingTourbyRef({Key? key, required this.tourId}) : super(key: key);

  @override
  State<StartingTourbyRef> createState() => _StartingTourbyRefState();
}

class _StartingTourbyRefState extends State<StartingTourbyRef> {
  @override
  void initState() {
    Connectivity.sendsock({'type': 'Get Matches', 'data': widget.tourId});
    super.initState();
  }

  late List<dynamic> allMatches;

  @override
  Widget build(BuildContext context) {
    allMatches = Provider.of<MatchesProvider>(context).gettingAllMatch;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 1,
        centerTitle: true,
        title: const Text('Start Matches',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF003366),
          onPressed: () => Navigator.push(
              context,
              CustomPageRoute(
                  child: AddMatches(
                        tourId: widget.tourId,
                      ), direction: AxisDirection.left)),
          label: const Text('Add Matches')),
      body: ListView.builder(
        itemCount: allMatches.length,
        itemBuilder: ((context, index) {
          Map<String, dynamic> match =
              json.decode(allMatches[index]['match_between']);
          return Dismissible(
            background: Container(
              color: const Color(0xFFe10000),
            ),
            key: Key(allMatches[index]['match_id']),
            onDismissed: (direction) {
              Connectivity.sendsock({
                'type': 'delete existing match',
                'data': allMatches[index]['match_id']
              });
              setState(() {
                allMatches.removeAt(index);
                Provider.of<MatchesProvider>(context, listen: false)
                    .settingAllMatch(allMatches);
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
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
                          child: Text(match['team A']['team_name']),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              Provider.of<MatchesProvider>(context, listen: false).settingMatchInfo({});
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: AddingScore(
                                            matchBetween: match,
                                            matchId: allMatches[index]
                                                ['match_id'],
                                          ), direction: AxisDirection.left));
                            },
                            icon: const Icon(
                              CupertinoIcons.play_fill,
                              size: 40,
                            )),
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
                          child: Text(match['team B']['team_name']),
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
                      child: Text(match['time']),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
