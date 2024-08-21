import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class IndividualMatchInfo extends StatefulWidget {
  const IndividualMatchInfo(
      {Key? key,
      required this.matchBetween,
      required this.matchId,
      required this.pageName})
      : super(key: key);
  final Map<String, dynamic> matchBetween;
  final String matchId;
  final String pageName;

  @override
  State<IndividualMatchInfo> createState() => _IndividualMatchInfoState();
}

class _IndividualMatchInfoState extends State<IndividualMatchInfo> {
  String whichTeam = 'team A';
  int scoreA = 0;
  int scoreB = 0;
  int quarter = 1;
  late Map<String, dynamic> info;
  @override
  void initState() {
    Connectivity.sendsock(
        {'type': 'add_another_group', 'data': widget.matchId});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    info = Provider.of<IndividualMatchProvider>(context).gettingMatchInfo;
    if (info.isNotEmpty) {
      scoreA =
          info['team_a_1'] + (info['team_a_2'] * 2) + (info['team_a_3'] * 3);
      scoreB =
          info['team_b_1'] + (info['team_b_2'] * 2) + (info['team_b_3'] * 3);
      quarter = int.parse(info['quarter']);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          color: Colors.black,
          onPressed: () {
            Connectivity.sendsock(
                {'type': 'close group by player', 'data': widget.matchId});
            Provider.of<IndividualMatchProvider>(context, listen: false)
                .settingMatchInfo({});
            var box = Hive.box('details');
            box.put('viewer_match_info', <String, dynamic>{});
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 0,
        centerTitle: true,
        title: Text(
            "${widget.matchBetween['team A']['team_name']} vs ${widget.matchBetween['team B']['team_name']}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ),
      body: info.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            )
          : Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    color: const Color(0xFF333333),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          height: 20,
                          margin: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            info['status'],
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.greenAccent),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://www.hoopster.in/media/${widget.matchBetween['team A']['pic']}'))),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://www.hoopster.in/media/${widget.matchBetween['team B']['pic']}'))),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.matchBetween['team A']['team_name'],
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: const Color(0xFFffffff),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(
                              widget.matchBetween['team B']['team_name'],
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: const Color(0xFFffffff),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: 100,
                              alignment: Alignment.center,
                              color: const Color(0xFFeeeeee),
                              child: Text(
                                scoreA.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 30),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .05,
                              width: 30,
                              alignment: Alignment.center,
                              color: const Color(0xFFeeeeee),
                              child: Text(
                                quarter.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: 100,
                              alignment: Alignment.center,
                              color: const Color(0xFFeeeeee),
                              child: Text(
                                scoreB.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _selectTeamStats(),
                  _lowerBody()
                ],
              )),
    );
  }

  Widget _selectTeamStats() {
    List<Widget> rowLis = info['status'] == 'end'
        ? <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  whichTeam = 'team A';
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .2,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: whichTeam == 'team A'
                                ? const Color(0xFFc2b6b8)
                                : const Color(0xFFCC00DD),
                            width: 3.0,
                            style: BorderStyle.solid))),
                child: Text(widget.matchBetween['team A']['team_name'],
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  whichTeam = 'team B';
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .2,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: whichTeam == 'team B'
                                ? const Color(0xFFc2b6b8)
                                : const Color(0xFFCC00DD),
                            width: 3.0,
                            style: BorderStyle.solid))),
                child: Text(widget.matchBetween['team B']['team_name'],
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  whichTeam = 'details';
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .2,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: whichTeam == 'details'
                                ? const Color(0xFFc2b6b8)
                                : const Color(0xFFCC00DD),
                            width: 3.0,
                            style: BorderStyle.solid))),
                child: Text("Details",
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
          ]
        : <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  whichTeam = 'team A';
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .2,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: whichTeam == 'team A'
                                ? const Color(0xFFc2b6b8)
                                : const Color(0xFFCC00DD),
                            width: 3.0,
                            style: BorderStyle.solid))),
                child: Text(widget.matchBetween['team A']['team_name'],
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  whichTeam = 'team B';
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .2,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: whichTeam == 'team B'
                                ? const Color(0xFFc2b6b8)
                                : const Color(0xFFCC00DD),
                            width: 3.0,
                            style: BorderStyle.solid))),
                child: Text(widget.matchBetween['team B']['team_name'],
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
          ];
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: rowLis),
    );
  }

  Widget _lowerBody() {
    if (info['status'] == 'upcoming') {
      return Expanded(
        child: Center(
          child: Text(
            'Upcoming',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (whichTeam == 'details') {
      return Expanded(
          child: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_a_offensive_rebound'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Offensive Rebound",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_b_offensive_rebound'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_a_defensive_rebound'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Defensive Rebound",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_b_defensive_rebound'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_a_assist'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Assist",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_b_assist'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${info['team_a_3'].toString()}/${info['team_a_3_attempt'].toString()}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "3 Pointers",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${info['team_b_3'].toString()}/${info['team_b_3_attempt'].toString()}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${info['team_a_2'].toString()}/${info['team_a_2_attempt'].toString()}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "2 Pointers",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${info['team_b_2'].toString()}/${info['team_b_2_attempt'].toString()}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${info['team_a_1'].toString()}/${info['team_a_1_attempt'].toString()}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Free Throw",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      "${info['team_b_1'].toString()}/${info['team_b_1_attempt'].toString()}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_a_block'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Block",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_b_block'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_a_steal'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: const Color(0xFFf0ece5),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Steal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      info['team_b_steal'].toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
          ),
        ],
      ));
    }
    List<dynamic> players = [];
    if (whichTeam == 'team A') {
      players = info['team_a_player_stats'].keys.toList();
    } else {
      players = info['team_b_player_stats'].keys.toList();
    }
    return Expanded(
      child: ListView(
        children: players.map((e) {
          Map<String, dynamic> player;
          if (whichTeam == 'team A') {
            player = info['team_a_player_stats'][e];
          } else {
            player = info['team_b_player_stats'][e];
          }
          return Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF333333),
            ),
            margin: const EdgeInsets.only(top: 10, left: 4),
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 55,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://www.hoopster.in/media/${player['pic']}'),
                  ),
                ),
                Container(
                    width: 100,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      e,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.height * .08,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: player['playing'] == 'in'
                          ? const Color(0xFF50ffa0)
                          : const Color(0xFFeeeeee)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Text(
                              "${player['points']['3pm']}/${player['points']['3 attempt']} 3p "),
                          const VerticalDivider(),
                          Text(
                              "${player['points']['2pm']}/${player['points']['2 attempt']} 2p "),
                          const VerticalDivider(),
                          Text(
                              "${player['points']['F.T']}/${player['points']['F.T attempt']} 1p "),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
