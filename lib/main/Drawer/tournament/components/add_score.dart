import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

class AddingScore extends StatefulWidget {
  final String matchId;
  final Map<String, dynamic> matchBetween;
  const AddingScore(
      {Key? key, required this.matchBetween, required this.matchId})
      : super(key: key);

  @override
  State<AddingScore> createState() => _AddingScoreState();
}

class _AddingScoreState extends State<AddingScore> {
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));

  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  final ButtonStyle _style4 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 40));

  final ButtonStyle _style5 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 40));
  final ButtonStyle _style3 = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      primary: const Color(0xFF333333),
      minimumSize: const Size(50, 50));
  late String whichTeam;
  late ScrollController scrollController;
  List<dynamic> teamA5 = [];
  List<dynamic> teamB5 = [];
  late Map<String, dynamic> macthInfo;
  String dropdownvalue = '1';
  late String refId;
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  GlobalKey key6 = GlobalKey();
  GlobalKey key7 = GlobalKey();
  GlobalKey key8 = GlobalKey();
  GlobalKey key9 = GlobalKey();
  GlobalKey key10 = GlobalKey();
  late BuildContext score;
  late BuildContext boxcontext;
  
  @override
  void initState() {
    Connectivity.sendsock(
        {'type': 'Getting Full Match Information', 'data': widget.matchId});
    _getHiveData();
    scrollController = ScrollController();
    super.initState();
  }

  void _getHiveData() {
    refId = DataProvider.gettingdatafromHive['id'];
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    return false;
  }

  Future<bool> _onWillPop1() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    macthInfo = Provider.of<MatchesProvider>(context).gettingMatchInfo;
    whichTeam = Provider.of<MatchesProvider>(context).gettingwhichTeam;
    // this will only run while selcting lineup
    if (macthInfo.isNotEmpty &&
        (macthInfo['team_a_player_playing'].isEmpty ||
            macthInfo['team_b_player_playing'].isEmpty)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _addingLineup());
    } else if (macthInfo.isNotEmpty) {
      if(whichTeam == 'other'){
        ThemeHelper().intro(s: [key3, key4, key5, key6, key7, key8,key9], boxName: "score_2", context: score);
      } else{
        ThemeHelper().intro(s: [key1, key2], boxName: "score_1", context: score);
      }
      //this is to enter playing in both team list
      List<String> fullteamA = macthInfo['team_a_player_playing'].keys.toList();
      List<String> fullteamB = macthInfo['team_b_player_playing'].keys.toList();
      if (teamA5.isEmpty || refId != macthInfo['ref_id']) {
        teamA5.clear();
        for (var x in fullteamA) {
          if (macthInfo['team_a_player_playing'][x]['playing'] == 'in') {
            teamA5.add(macthInfo['team_a_player_playing'][x]);
          }
        }
      }
      if (teamB5.isEmpty || refId != macthInfo['ref_id']) {
        teamB5.clear();
        for (var x in fullteamB) {
          if (macthInfo['team_b_player_playing'][x]['playing'] == 'in') {
            teamB5.add(macthInfo['team_b_player_playing'][x]);
          }
        }
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop1,
      child: ShowCaseWidget(
        builder: Builder(
          builder: (context) {
            score = context;
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  color: Colors.black,
                  onPressed: () {
                    Connectivity.sendsock(
                        {'type': 'close group by ref', 'data': widget.matchId});
                    Provider.of<MatchesProvider>(context, listen: false)
                        .settingMatchInfo({});
                    Provider.of<MatchesProvider>(context, listen: false)
                        .settingWhichTeam('Points');
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: const Color(0xFFf8843d),
                elevation: 1,
                centerTitle: true,
                title: Text(
                    '${widget.matchBetween['team A']['team_name']} vs ${widget.matchBetween['team B']['team_name']}',
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              body: Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                              style: whichTeam == 'Points' ? _style1 : _style2,
                              onPressed: () {
                                Provider.of<MatchesProvider>(context, listen: false)
                                    .settingWhichTeam('Points');
                              },
                              child: const Text("Points")),
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                              style: whichTeam == 'other' ? _style1 : _style2,
                              onPressed: () {
                                Provider.of<MatchesProvider>(context, listen: false)
                                    .settingWhichTeam('other');
                              },
                              child: const Text('Other Info')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: whichTeam == "Points" ? _lowerBody1() : _lowerBody(),
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<dynamic> _substitution(String team) {
    List<dynamic> playing5 = [];
    String err = '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowCaseWidget(
            builder: Builder(
              builder: (context) {
                boxcontext = context;
                return StatefulBuilder(
                  builder: (context, innerState) {
                    String teamName = team == 'team A'
                        ? widget.matchBetween['team A']['team_name']
                        : widget.matchBetween['team B']['team_name'];
                    Map<String, dynamic> playerStats = team == 'team A'
                        ? macthInfo['team_a_player_playing']
                        : macthInfo['team_b_player_playing'];
                    return SingleChildScrollView(
                      child: AlertDialog(
                        content: Column(
                          children: <Widget>[
                            Text(macthInfo['category']),
                            Showcase(
                              key: key10,
                              description: "1. Add the jersey number to for adding the scoring.\n\n2. Select the playing as per category(3X3, 5X5).\n\nNOTE:Player will only be selected if you have entered there jersey number.",
                              descTextStyle: const TextStyle(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w600
                                ),
                              child: Text('Select Playing for $teamName')),
                            Text(
                              err,
                              style: const TextStyle(fontSize: 10, color: Colors.red),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 15),
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * .57,
                                child: ListView(
                                    children: playerStats.keys.toList().map(
                                  (e) {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        color: const Color(0xFFf0f8ff),
                                        child: ListTile(
                                          trailing: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFF0e2f44),
                                            ),
                                            onPressed: () {
                                              if (!playing5.contains(playerStats[e])) {
                                                if (playerStats[e].containsKey('no.')) {
                                                  innerState(() {
                                                    playerStats[e]['username'] = e;
                                                    playing5.add(playerStats[e]);
                                                  });
                                                }
                                              } else {
                                                innerState(() {
                                                  playing5.remove(playerStats[e]);
                                                });
                                              }
                                            },
                                            child: playing5.contains(playerStats[e])
                                                ? const Text('Remove')
                                                : const Text('Add'),
                                          ),
                                          subtitle: Container(
                                            margin: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: TextFormField(
                                              cursorColor: Colors.white,
                                              onChanged: (value) {
                                                playerStats[e]['no.'] = value;
                                              },
                                              decoration: InputDecoration(
                                                fillColor: const Color(0xFF7f7f7f),
                                                filled: true,
                                                labelText:
                                                    playerStats[e].containsKey('no.')
                                                        ? playerStats[e]['no.']
                                                        : 'No.',
                                                labelStyle: const TextStyle(
                                                  color:
                                                      Color.fromARGB(255, 42, 41, 44),
                                                ),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color.fromARGB(255, 0, 0, 0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(e,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList()))
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (macthInfo['category'] == '5X5') {
                                  if (playing5.length == 5) {
                                    if (team == 'team A') {
                                      teamA5.clear();
                                      Connectivity.sendsock({
                                        'type': 'add_another_group_by_ref',
                                        'data': widget.matchId,
                                        'extra_data': 'substitution',
                                        'team_a_player_stats': playing5,
                                        'ref_id': refId
                                      });
                                    } else {
                                      teamB5.clear();
                                      Connectivity.sendsock({
                                        'type': 'add_another_group_by_ref',
                                        'data': widget.matchId,
                                        'extra_data': 'substitution',
                                        'team_b_player_stats': playing5,
                                        'ref_id': refId
                                      });
                                    }
                                    Navigator.pop(context);
                                  } else {
                                    innerState(() {
                                      err = 'Please Select 5 Players';
                                    });
                                  }
                                } else {
                                  if (playing5.length == 3) {
                                    if (team == 'team A') {
                                      teamA5.clear();
                                      Connectivity.sendsock({
                                        'type': 'add_another_group_by_ref',
                                        'data': widget.matchId,
                                        'extra_data': 'substitution',
                                        'team_a_player_stats': playing5,
                                        'ref_id': refId
                                      });
                                    } else {
                                      teamB5.clear();
                                      Connectivity.sendsock({
                                        'type': 'add_another_group_by_ref',
                                        'data': widget.matchId,
                                        'extra_data': 'substitution',
                                        'team_b_player_stats': playing5,
                                        'ref_id': refId
                                      });
                                    }
                                    Navigator.pop(context);
                                  } else {
                                    innerState(() {
                                      err = 'Please Select 3 Players';
                                    });
                                  }
                                }
                              },
                              child: const Text('Done'))
                        ],
                      ),
                    );
                  },
                );
              }
            ),
          );
        });
  }

  Future<dynamic> _addingLineup() {
    Map<String, dynamic> stats = {};
    String err = '';
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, innerState) {
            List<dynamic> player = macthInfo['team_a_player_playing'].isEmpty
                ? macthInfo['team_a_player']
                : macthInfo['team_b_player'];
            String teamName = macthInfo['team_a_player_playing'].isEmpty
                ? widget.matchBetween['team A']['team_name']
                : widget.matchBetween['team B']['team_name'];
            return WillPopScope(
              onWillPop: _onWillPop,
              child: AlertDialog(
                content: Column(
                  children: <Widget>[
                    Text(macthInfo['category']),
                    Text('Select Lineup for $teamName'),
                    Text(
                      err,
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .57,
                      child: ListView(
                        children: player.map((e) {
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            color: const Color(0xFFf0f8ff),
                            child: ListTile(
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF0e2f44),
                                ),
                                onPressed: () {
                                  if (!stats.containsKey(e['userName'])) {
                                    innerState(() {
                                      stats[e['userName']] = {
                                        'pic': e['pic'],
                                        'points': {
                                          '3pm': 0,
                                          '2pm': 0,
                                          'F.T': 0,
                                          'F.T attempt': 0,
                                          '3 attempt': 0,
                                          '2 attempt': 0
                                        },
                                        'assist': 0,
                                        'block': 0,
                                        'steal': 0,
                                        'rebound': {
                                          'Offensive': 0,
                                          'Defensive': 0
                                        },
                                        'playing': 'out'
                                      };
                                    });
                                  } else {
                                    innerState(() {
                                      stats.remove(e['userName']);
                                    });
                                  }
                                },
                                child: !stats.containsKey(e['userName'])
                                    ? const Text('Add')
                                    : const Text('Remove'),
                              ),
                              title: Text(e['userName'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (macthInfo['category'] == '5X5') {
                          if (stats.length >= 7 && stats.length <= 11) {
                            if (macthInfo['team_a_player_playing'].isEmpty) {
                              macthInfo['team_a_player_playing'] = stats;
                            } else {
                              macthInfo['team_b_player_playing'] = stats;
                              Connectivity.sendsock({
                                'type': 'add lineup for match',
                                'data': {
                                  'team_b_player_playing':
                                      macthInfo['team_b_player_playing'],
                                  'team_a_player_playing':
                                      macthInfo['team_a_player_playing']
                                },
                                'match_id': widget.matchId,
                                'ref_id': refId
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                            Provider.of<MatchesProvider>(context, listen: false)
                                .settingMatchInfo(macthInfo);
                          } else {
                            innerState(() {
                              err =
                                  'Minimum Player should be 7 and Maximum should be 11';
                            });
                          }
                        } else {
                          if (stats.length >= 3 && stats.length <= 5) {
                            if (macthInfo['team_a_player_playing'].isEmpty) {
                              macthInfo['team_a_player_playing'] = stats;
                            } else {
                              macthInfo['team_b_player_playing'] = stats;
                              Connectivity.sendsock({
                                'type': 'add lineup for match',
                                'data': {
                                  'team_b_player_playing':
                                      macthInfo['team_b_player_playing'],
                                  'team_a_player_playing':
                                      macthInfo['team_a_player_playing']
                                },
                                'match_id': widget.matchId,
                                'ref_id': refId
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                            Provider.of<MatchesProvider>(context, listen: false)
                                .settingMatchInfo(macthInfo);
                          } else {
                            innerState(() {
                              err =
                                  'Minimum Player should be 3 and Maximum should be 5';
                            });
                          }
                        }
                      },
                      child: const Text('Next'))
                ],
              ),
            );
          });
        });
  }

  Widget _lowerBody() {
      List<String> quater = ['1', '2', '3', '4'];
      String err = "";
      return StatefulBuilder(builder: (context, innerState) {
        return Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  err,
                  style: const TextStyle(color: Colors.red, fontSize: 25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Showcase(
                      key: key3,
                      description: "Add total assist of each player of both the team. You need to add before you end the game",
                      descTextStyle: const TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600
                        ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF556699),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width * 0.40, 50)),
                        onPressed: () {
                          _box(part: 'assist');
                        },
                        child: const Text("Assist"),
                      ),
                    ),
                    Showcase(
                      key: key4,
                      description: "Add total block of each player of both the team. You need to add before you end the game",
                      descTextStyle: const TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600
                        ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF556699),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width * 0.40, 50)),
                        onPressed: () {
                          _box(part: 'block');
                        },
                        child: const Text("Block"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Showcase(
                      key: key5,
                      description: "Add total Steal of each player of both the team. You need to add before you end the game",
                      descTextStyle: const TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600
                        ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF393d63),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width * 0.40, 50)),
                        onPressed: () {
                          _box(part: "steal");
                        },
                        child: const Text("Steal"),
                      ),
                    ),
                    Showcase(
                      key: key6,
                      description: "Add total Rebound of each player of both the team. You need to add before you end the game",
                      descTextStyle: const TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600
                        ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF393d63),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width * 0.40, 50)),
                        onPressed: () {
                          _box1();
                        },
                        child: const Text("Rebound"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Showcase(
                  key: key7,
                      description: "You can change the quarter here.",
                      descTextStyle: const TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600
                        ),
                  child: const Text('Select Quarter')),
                DropdownButton<String>(
                  value: macthInfo.containsKey('quarter')
                      ? macthInfo['quarter']
                      : dropdownvalue,
                  items: quater.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(value: e, child: Text(e));
                  }).toList(),
                  elevation: 0,
                  onChanged: (value) {
                    if (macthInfo['status'] == 'live' ||
                        macthInfo['status'] == 'time out') {
                      Connectivity.sendsock({
                        'type': 'add_another_group_by_ref',
                        'data': widget.matchId,
                        'extra_data': 'quarter',
                        'no': value,
                        'ref_id': refId
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Showcase(
                  key: key8,
                      description: "You can tap on time out to call it. and tap again to end it",
                      descTextStyle: const TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600
                        ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF133337),
                          minimumSize: Size(
                              MediaQuery.of(navigatorKey.currentContext!)
                                      .size
                                      .width *
                                  0.40,
                              50)),
                      onPressed: () {
                        if (macthInfo['status'] == 'live') {
                          Connectivity.sendsock({
                            'type': 'add_another_group_by_ref',
                            'data': widget.matchId,
                            'extra_data': 'time out',
                            'ref_id': refId
                          });
                        } else if (macthInfo['status'] == 'time out') {
                          Connectivity.sendsock({
                            'type': 'add_another_group_by_ref',
                            'data': widget.matchId,
                            'extra_data': 'live',
                            'ref_id': refId
                          });
                        }
                      },
                      child: macthInfo['status'] == 'time out'
                          ? const Text('End Time out')
                          : const Text('Time out')),
                ),
                const SizedBox(
                  height: 20,
                ),
                Showcase(
                  key: key9,
                      description: "1. You need to start the game.\n\n2. Then you need to enter assit, block, rebound, steal of each player.\n\n3. Then you can end the match end.",
                      
                      descTextStyle: const TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600
                        ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFc34a50),
                          minimumSize: Size(
                              MediaQuery.of(navigatorKey.currentContext!)
                                      .size
                                      .width *
                                  0.40,
                              50)),
                      onPressed: () {
                        if (macthInfo['status'] == 'upcoming') {
                          if (teamA5.isNotEmpty && teamB5.isNotEmpty) {
                            innerState(() {
                              err = "";
                              Connectivity.sendsock({
                                'type': 'add_another_group_by_ref',
                                'data': widget.matchId,
                                'extra_data': 'live',
                                'ref_id': refId
                              });
                            });
                          } else {
                            innerState(() {
                              err = "Please select playing 5 for both teams";
                            });
                          }
                        } else {
                          if (macthInfo['status'] == 'live' &&
                              macthInfo['quarter'] == '4') {
                            _box2();
                          }
                        }
                      },
                      child: macthInfo['status'] == 'upcoming'
                          ? const Text('Start Match')
                          : macthInfo['status'] == 'end'
                              ? const Text('Ended')
                              : const Text('End Match')),
                ),
                const SizedBox(height: 100,)
              ],
            ),
          ),
        );
      });
  }

  Widget _lowerBody1() {
    List<String> lisPoints = [
      '3pm',
      '3 attempt',
      '2pm',
      '2 attempt',
      'F.T',
      'F.T attempt'
    ];
    String userSelected = '';

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Text(widget.matchBetween['team A']['team_name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Showcase(
                  key: key1,
                  description: "Tap on + to add playing 5 respective team",
                  descTextStyle: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600
                    ),
                  child: IconButton(
                      icon: const Icon(CupertinoIcons.plus,
                          size: 30, color: Color(0xFF000000)),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                          ThemeHelper().intro(s: [key10], boxName: "score_3", context: boxcontext)
                        );
                        _substitution("team A");
                      }),
                ),
              ],
            ),
          ),
          StatefulBuilder(builder: (context, inner) {
            return GestureDetector(
              onTap: () {
                inner(() {
                  userSelected = "";
                });
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .3,
                child: Showcase(
                  key: key2,
                  description: "1. Here you will get the jersy no. of playing memeber of the respective team.\n\n2. Tap on individual number to add the score of particuler player which  will going to add into team score.",
                  descTextStyle: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600
                    ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: teamA5.map((e) {
                      return StatefulBuilder(builder: (context, innerState) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 10, top: 5),
                          alignment: Alignment.center,
                          child: userSelected != ''
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: lisPoints.map((e) {
                                      return Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: ElevatedButton(
                                          style: _style3,
                                          onPressed: () {
                                            HapticFeedback.vibrate();
                                            Connectivity.sendsock({
                                              'type': 'scoring',
                                              'data': widget.matchId,
                                              'extra_data': 'points',
                                              'team_a_player_stats': e,
                                              'username': userSelected
                                            });
                                            innerState(() {
                                              userSelected = '';
                                            });
                                          },
                                          child: Text(
                                            e,
                                            style: GoogleFonts.kanit(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : ElevatedButton(
                                  style: _style3,
                                  onPressed: () {
                                    innerState(() {
                                      userSelected = e['username'];
                                    });
                                  },
                                  child: Text(
                                    e['no.'],
                                    style: GoogleFonts.kanit(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        );
                      });
                    }).toList(),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Text(widget.matchBetween['team B']['team_name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                IconButton(
                    icon: const Icon(CupertinoIcons.plus,
                        size: 30, color: Color(0xFF000000)),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          ThemeHelper().intro(s: [key10], boxName: "score_3", context: boxcontext)
                        );
                      _substitution("team B");
                    }),
              ],
            ),
          ),
          StatefulBuilder(builder: (context, inner) {
            return GestureDetector(
              onTap: () {
                inner(() {
                  userSelected = "";
                });
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .4,
                child: ListView(
                  children: teamB5.map((e) {
                    return StatefulBuilder(builder: (context, innerState) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 10, top: 5),
                        alignment: Alignment.center,
                        child: userSelected != ''
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: lisPoints.map((e) {
                                    return Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: ElevatedButton(
                                        style: _style3,
                                        onPressed: () {
                                          HapticFeedback.vibrate();
                                          Connectivity.sendsock({
                                            'type': 'scoring',
                                            'data': widget.matchId,
                                            'extra_data': 'points',
                                            'team_b_player_stats': e,
                                            'username': userSelected
                                          });
                                          innerState(() {
                                            userSelected = '';
                                          });
                                        },
                                        child: Text(
                                          e,
                                          style: GoogleFonts.kanit(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : ElevatedButton(
                                style: _style3,
                                onPressed: () {
                                  innerState(() {
                                    userSelected = e['username'];
                                  });
                                },
                                child: Text(
                                  e['no.'],
                                  style: GoogleFonts.kanit(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      );
                    });
                  }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _box({required String part}) {
    String whichTeam1 = "team A";
    List<String> fullteamA = macthInfo['team_a_player_playing'].keys.toList();
    List<String> fullteamB = macthInfo['team_b_player_playing'].keys.toList();
    List<int> list = Iterable<int>.generate(50).toList();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, innerstate) {
              return ValueListenableBuilder<Box>(
                valueListenable: Hive.box('details').listenable(keys: ['ref_match_info']),
                builder: (context, box, widget1) {
                Map<String, dynamic> match1 =
                    box.get("ref_match_info", defaultValue: <String, dynamic>{});
                return AlertDialog(
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            part,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                    style:
                                        whichTeam1 == 'team A' ? _style4 : _style5,
                                    onPressed: () {
                                      innerstate(() {
                                        whichTeam1 = "team A";
                                      });
                                    },
                                    child: Text(widget.matchBetween['team A']
                                        ['team_name'])),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                    style:
                                        whichTeam1 == 'team B' ? _style4 : _style5,
                                    onPressed: () {
                                      innerstate(() {
                                        whichTeam1 = "team B";
                                      });
                                    },
                                    child: Text(widget.matchBetween['team B']
                                        ['team_name'])),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: ListView(
                          children: whichTeam1 == "team A"
                              ? fullteamA.map((e) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              .4,
                                          child: Text(
                                            e,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        DropdownButton<int>(
                                          value: part == "offensive rebound"
                                              ? match1['team_a_player_playing'][e]
                                                  ['rebound']['Offensive']
                                              : part == "defensive rebound"
                                                  ? match1['team_a_player_playing']
                                                      [e]['rebound']['Defensive']
                                                  : match1['team_a_player_playing']
                                                      [e][part],
                                          icon: const Icon(Icons.arrow_downward),
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.deepPurple),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                          onChanged: (int? value) {
                                            Connectivity.sendsock({
                                              'type': 'scoring',
                                              'data': widget.matchId,
                                              'extra_data': part,
                                              'team_a_player_stats': e,
                                              'value': value
                                            });
                                          },
                                          items: list.map<DropdownMenuItem<int>>(
                                              (int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(value.toString()),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()
                              : fullteamB.map((e) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              .4,
                                          child: Text(
                                            e,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        DropdownButton<int>(
                                          value: part == "offensive rebound"
                                              ? match1['team_b_player_playing'][e]
                                                  ['rebound']['Offensive']
                                              : part == "defensive rebound"
                                                  ? match1['team_b_player_playing']
                                                      [e]['rebound']['Defensive']
                                                  : match1['team_b_player_playing']
                                                      [e][part],
                                          icon: const Icon(Icons.arrow_downward),
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.deepPurple),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                          onChanged: (int? value) {
                                            Connectivity.sendsock({
                                              'type': 'scoring',
                                              'data': widget.matchId,
                                              'extra_data': part,
                                              'team_b_player_stats': e,
                                              'value': value
                                            });
                                          },
                                          items: list.map<DropdownMenuItem<int>>(
                                              (int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(value.toString()),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                        ))
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Done"))
                  ],
                );
              });
            }
          );
        });
  }

  void _box1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.width * .4,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      _box(part: "defensive rebound");
                    },
                    child: const Text("Dfensive Rebound")),
                TextButton(
                    onPressed: () {
                      _box(part: "offensive rebound");
                    },
                    child: const Text("Offensive Rebound")),
              ],
            ),
          ));
        });
  }

  void _box2(){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          content: const Text("Are You sure you want to end the match?\n\nHave you added assist, block, steal, and rebound of each player?", 
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
          actions: [
            TextButton(
              onPressed: (){
                Connectivity.sendsock({
                              'type': 'add_another_group_by_ref',
                              'data': widget.matchId,
                              'extra_data': 'end',
                              'ref_id': refId
                            });
                  Navigator.pop(context);
              }, 
              child: const Text("End"))
          ],
        );
      });
  }
}
