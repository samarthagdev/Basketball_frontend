import 'package:basketball_frontend/main/BottomNavigationBar/profile/add_player.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/profile/profile.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class TeamProfile extends StatefulWidget {
  final String id;
  final String pic;
  const TeamProfile({Key? key, required this.id, required this.pic})
      : super(key: key);

  @override
  State<TeamProfile> createState() => _TeamProfileState();
}

class _TeamProfileState extends State<TeamProfile> {
  late Map<String, dynamic> profileData;
  String buttonSelected = 'stats';
  late final String _username;
  List<Widget> teamUpperRow = [];
  bool isOwner = false;
  GlobalKey key3 = GlobalKey();
  late BuildContext teamcontext;
  @override
  void initState() {
    super.initState();
    _gettingProfileData();
  }

  _gettingProfileData() {
    _username = DataProvider.gettingdatafromHive['id'];
    Connectivity.sendsock({'type': 'team_profile', 'data': widget.id});
  }

  @override
  Widget build(BuildContext context) {
    profileData = Provider.of<TeamProfileProvider>(context).gettingTeamProfile;
    if (profileData.isNotEmpty) {
      teamUpperRow = _username != profileData['owner']
          ? [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.back),
              ),
              const Icon(CupertinoIcons.lock),
              Text(profileData['owner'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: const Color(0xFF3b2f3b),
                      fontWeight: FontWeight.w900)),
            ]
          : [
              SizedBox(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.back),
                    ),
                    const Icon(CupertinoIcons.lock),
                    Text(profileData['owner'],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: const Color(0xFF3b2f3b),
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              SizedBox(
                child: IconButton(
                      onPressed: () {
                        Provider.of<SearchProvider>(context, listen: false)
                            .settingSearch([]);
                        Provider.of<JoinTeamProvider>(context, listen: false)
                            .settingPending([]);
                        Navigator.push(
                            context,
                            CustomPageRoute(
                                child: ExistingTeamAdd(
                                  teamid: widget.id,
                                  owner: _username,
                                ),
                                direction: AxisDirection.left));
                      },
                      icon: Showcase(
                        key: key3,
                        description: "Make sure to make a player account in the menu bar",
                        descTextStyle: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600
                          ),
                        child: const Icon(CupertinoIcons.add))),
                ),
            ];
      WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeHelper().intro(s: [key3], boxName: "tean_profile", context: teamcontext);
    });
    }

    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          teamcontext = context;
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Color(0xFFffffff)),
              child: profileData.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                Row(
                                    mainAxisAlignment:
                                        profileData['owner'] == _username
                                            ? MainAxisAlignment.spaceBetween
                                            : MainAxisAlignment.start,
                                    children: teamUpperRow),
                                const SizedBox(height: 20),
                                Material(
                                  elevation: 4.0,
                                  borderRadius: BorderRadius.circular(34.0),
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFFffdfdf),
                                            offset: Offset(0, 8),
                                            spreadRadius: 3,
                                            blurRadius: 8,
                                          )
                                        ],
                                        color: const Color(0xFF3b2f3b),
                                        borderRadius: BorderRadius.circular(34.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://www.hoopster.in/media/${widget.pic}'),
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    profileData['team_name'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF3b2f3b),
                                    ),
                                  ),
                                ),
                                Text(
                                  profileData['category'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF89a6ad),
                                  ),
                                ),
                                Text(
                                  profileData['address'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF89a6ad),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 50),
                              padding: const EdgeInsets.only(top: 20),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(45.0)),
                                  color: Color(0xFF1c1d21)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                        elevation: 4.0,
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFf5ffa6),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Color(0xFF25262a),
                                                    offset: Offset(0, 6),
                                                    blurRadius: 7,
                                                    spreadRadius: 1)
                                              ]),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                buttonSelected = 'stats';
                                              });
                                            },
                                            color: buttonSelected == 'stats'
                                                ? const Color(0xFFf8843d)
                                                : Colors.black,
                                            icon: const Icon(
                                              CupertinoIcons.chart_bar_alt_fill,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Material(
                                        elevation: 4.0,
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFf5ffa6),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Color(0xFF25262a),
                                                    offset: Offset(0, 6),
                                                    blurRadius: 7,
                                                    spreadRadius: 1)
                                              ]),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                buttonSelected = 'player';
                                              });
                                            },
                                            color: buttonSelected == 'player'
                                                ? const Color(0xFFf8843d)
                                                : Colors.black,
                                            icon: const Icon(
                                              CupertinoIcons.person_3_fill,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      child: buttonSelected == 'stats'
                                          ? _details()
                                          : _player())
                                ],
                              )),
                        ],
                      ),
                    ),
            ),
          );
        }
      ),
    );
  }

  Widget _player() {
    List<dynamic> profilePlayerData = profileData['players'];
    List<dynamic> profilePlayerData1 = [];
    if (profileData['owner'] == _username) {
      profilePlayerData1 = profilePlayerData;
      isOwner = true;
    } else {
      for (var x in profilePlayerData) {
        if (x['status'] == 'accept') {
          profilePlayerData1.add(x);
        }
      }
    }
    return Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * .55),
        margin:
            const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 100),
        child: Column(
          children: profilePlayerData1.map((e) {
            return InkWell(
              onTap: () {
                Provider.of<ProfileProvider>(context, listen: false)
                    .settingProfile({});
                Navigator.push(
                        context,
                        CustomPageRoute(
                            child: Profile(
                              id: e['userName'],
                              page: 'other',
                            ),
                            direction: AxisDirection.left))
                    .then((_) {
                  Connectivity.sendsock(
                      {'type': 'team_profile', 'data': widget.id});
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: isOwner
                        ? e['status'] == 'accept'
                            ? const Color(0xFFf5ffa6)
                            : const Color(0xFFcc0000)
                        : const Color(0xFFf5ffa6),
                    borderRadius: BorderRadius.circular(20.0)),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://www.hoopster.in/media/${e['pic']}'),
                  ),
                  title: Text(
                    e['userName'],
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _details() {
    List<String> totalMatchkeys = profileData['totalMatch'].keys.toList();
    List<dynamic> totalMatchvalues = profileData['totalMatch'].values.toList();
    List<String> pointskeys = profileData['points'].keys.toList();
    List<dynamic> pointsvalues = profileData['points'].values.toList();
    List<String> reboundkeys = profileData['rebound'].keys.toList();
    List<dynamic> reboundvalues = profileData['rebound'].values.toList();
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 100),
      child: Column(
        children: <Widget>[
          Text(
            'Total Matches Played',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: const Color(0xFFffffff),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xFF25262a),
                ),
                columns: totalMatchkeys.map((String e) {
                  return DataColumn(
                      label: Text(
                    e,
                    style: const TextStyle(color: Color(0xFFf5ffa6)),
                    textAlign: TextAlign.center,
                  ));
                }).toList(),
                rows: [
                  DataRow(
                    cells: totalMatchvalues.map((e) {
                      return DataCell(
                        Text(e.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFffffff))),
                      );
                    }).toList(),
                  )
                ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Total Points',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: const Color(0xFFffffff),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xFF25262a),
                ),
                columns: pointskeys.map((String e) {
                  return DataColumn(
                      label: Text(e,
                          style: const TextStyle(color: Color(0xFF006c6e)),
                          textAlign: TextAlign.center));
                }).toList(),
                rows: [
                  DataRow(
                    cells: pointsvalues.map((e) {
                      return DataCell(Text(e.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFffffff))));
                    }).toList(),
                  )
                ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Total Rebound',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: const Color(0xFFffffff),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DataTable(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFF25262a),
              ),
              columns: reboundkeys.map((String e) {
                return DataColumn(
                  label: Text(
                    e,
                    style: const TextStyle(color: Color(0xFFcee7ea)),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
              rows: [
                DataRow(
                  cells: reboundvalues.map((e) {
                    return DataCell(Text(e.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFffffff))));
                  }).toList(),
                )
              ]),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Assist/ Block/ Steal',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: const Color(0xFFffffff),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DataTable(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFF25262a),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Assist',
                    style: TextStyle(color: Color(0xFFff5a5f)),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Block',
                    style: TextStyle(color: Color(0xFFff5a5f)),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Steal',
                    style: TextStyle(color: Color(0xFFff5a5f)),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(profileData['assist'].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFffffff)))),
                    DataCell(Text(profileData['block'].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFffffff)))),
                    DataCell(Text(profileData['steal'].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFffffff)))),
                  ],
                )
              ]),
        ],
      ),
    );
  }
}
