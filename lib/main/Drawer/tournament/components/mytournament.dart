import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/join_tournament_body.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/my_tournament_body_1.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/mytournament_body.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class MyTournament extends StatefulWidget {
  const MyTournament({Key? key}) : super(key: key);

  @override
  State<MyTournament> createState() => _MyTournamentState();
}

class _MyTournamentState extends State<MyTournament> {
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.28, 45),
      maximumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 45),);

  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.28, 45),
      maximumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 45),);
  late final String _id;
  late List<dynamic> joinedlis;
  late List<dynamic> hosttour;
  late List<dynamic> reftour;
  bool isPlayer = false;
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  late BuildContext mytour;
  String whichBody = 'Joined Tournament';
  @override
  void initState() {
    _getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeHelper().intro(s: [key1, key2, key3], boxName: "mytourpage", context: mytour);
    });
    super.initState();
  }

  void _getData() {
    _id = DataProvider.gettingdatafromHive['id'];
    
    var box = Hive.box('details');
    isPlayer= box.get('player', defaultValue: {}).isEmpty?false:true;
    if (isPlayer){
      Connectivity.sendsock({'type': 'Get Joined Tournament', 'data': _id});
    }
  }

  @override
  Widget build(BuildContext context) {
    joinedlis = Provider.of<MyTournamentProvider>(context).gettingJoinedLis;
    hosttour = Provider.of<MyTournamentProvider>(context).gettingHostTour;
    reftour = Provider.of<MyTournamentProvider>(context).gettingRefTour;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          mytour =context;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
              backgroundColor: const Color(0xFFf8843d),
              elevation: 1,
              centerTitle: true,
              title: const Text('My Tournament',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
              body: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
            children: <Widget>[
                Container(
                  height: 70,
                  margin: const EdgeInsets.only(top: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: <Widget>[
                      Showcase(
                        key: key1,
                        description: "You will get List of Tournaments that you have participated as player",
                        descTextStyle: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600
                          ),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                whichBody = 'Joined Tournament';
                              });
                              if(isPlayer){
                                Connectivity.sendsock(
                                  {'type': 'Get Joined Tournament', 'data': _id});
                              }
                            },
                            child: const Text('Joined Tournament', textAlign: TextAlign.center,),
                            style: whichBody == 'Joined Tournament' ? _style1 : _style2),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Showcase(
                        key: key2,
                        description: "You will get List of Tournaments that you have accepted to be scorer of it.\n\nYou can tap on the Tournament name to add matches & do scoring for it.",
                        descTextStyle: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600
                          ),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                whichBody = 'Referee';
                              });
                              if(isPlayer){
                                Connectivity.sendsock(
                                  {'type': 'Get Tournament by Referee', 'data': _id});
                              }
                            },
                            child: const Text('Scorer'),
                            style: whichBody == 'Referee' ? _style1 : _style2),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Showcase(
                        key: key3,
                        description: "You will get List of Tournaments that you have have hosted.\n\nTap on it to invite team, request scorer, add fixture.",
                        descTextStyle: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600
                          ),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                whichBody = 'Hosts';
                              });
                              Connectivity.sendsock(
                                  {'type': 'Get Tournament by Host', 'data': _id});
                            },
                            child: const Text('Hosts'),
                            style: whichBody == 'Hosts' ? _style1 : _style2),
                      ),
                    ]),
                  ),
                ),
                Expanded(child: _lowerBody())
            ],
          ),
              ));
        }
      ),
    );
  }

  Widget _lowerBody() {
    if (whichBody == 'Joined Tournament') {
      List<dynamic> tour = [];
      for(var x in joinedlis){
        x.forEach((key, value) {
          tour.add({key: value});
        });
      }
      return Container(
        margin: const EdgeInsets.only(top: 15),
        child: ListView(
          children: tour.map((e) {
            late String dicKey;
            e.forEach((key, value){
               dicKey= key;
            });
            return InkWell(
              onTap: () {
                Provider.of<JoinTournamentProvider>(context, listen: false)
                    .settingDetails({});
                Navigator.push(
                    context,
                    CustomPageRoute(
                        child: JoinTourDetails(
                              tourId: dicKey,
                            ), direction: AxisDirection.left));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(e[dicKey]['tour_name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text(e[dicKey]['host'],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w300)),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (whichBody == 'Referee') {
      
      return Container(
        margin: const EdgeInsets.only(top: 15),
        child: ListView(
          children: reftour.map((e) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CustomPageRoute(
                        child: StartingTourbyRef(
                              tourId: e['tour_id'],
                            ), direction: AxisDirection.left));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(e['tour_name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text(e['host'],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w300)),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 15),
        child: ListView(
          children: hosttour.map((e) {
            return InkWell(
              onTap: () {
                Provider.of<SearchProvider>(context, listen: false)
                    .settingSearch([]);
                Navigator.push(
                    context,
                    CustomPageRoute(
                        child: Host(
                              tourId: e['tour_id'],
                              tourName: e['tour_name'],
                            ), direction: AxisDirection.left));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(e['tour_name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text(e['tour_category'],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w300)),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
  }
}
