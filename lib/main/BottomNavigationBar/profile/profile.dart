import 'package:basketball_frontend/main/BottomNavigationBar/profile/team_profile.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String page;
  final String? id;
  const Profile({Key? key, required this.page, this.id}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Map<String, dynamic> profileData;
  String buttonSelected = 'stats';
  @override
  void initState() {
    super.initState();
    _gettingProfileData();
  }

  _gettingProfileData() {
    if (widget.page == 'bottomNavigationBar') {
      String _username = DataProvider.gettingdatafromHive['id'];
      Connectivity.sendsock({'type': 'profile', 'data': _username});
    }
    else {
      Connectivity.sendsock({'type': 'profile', 'data': widget.id});
    }
  }

  List<Widget> row1 = [];

  @override
  Widget build(BuildContext context) {
    profileData = Provider.of<ProfileProvider>(context).gettingProfile;
    if (profileData.isNotEmpty){
    row1 = widget.page == 'bottomNavigationBar'
        ? [
            const SizedBox(
              width: 10,
            ),
            const Icon(CupertinoIcons.lock),
            const SizedBox(
              width: 3,
            ),
            Text(profileData['userName'],
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: const Color(0xFF3b2f3b),
                    fontWeight: FontWeight.w900)),
          ]
        : [
            IconButton(icon: const Icon(CupertinoIcons.back), onPressed: (){Navigator.pop(context);}),
            const SizedBox(
              width: 10,
            ),
            const Icon(CupertinoIcons.lock),
            const SizedBox(
              width: 3,
            ),
            Text(profileData['userName'],
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: const Color(0xFF3b2f3b),
                    fontWeight: FontWeight.w900)),
          ];
    }
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: row1),
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
                                    image: profileData['pic'] != '' ?NetworkImage(
                                        'https://www.hoopster.in/media/${profileData['pic']}') : const AssetImage('assets/basketball_scene.jpg') as ImageProvider,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              profileData['name'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3b2f3b),
                              ),
                            ),
                          ),
                          Text(
                            'Basketball Never Stops',
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
                                          buttonSelected = 'flags';
                                        });
                                      },
                                      color: buttonSelected == 'stats'
                                          ? Colors.black
                                          : const Color(0xFFf8843d),
                                      icon: const Icon(
                                        CupertinoIcons.collections_solid,
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
                                    : _flag())
                          ],
                        )),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _flag() {
    if (!profileData.containsKey('totalMatch')){
      return Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height*.55
        ),
        child: Center(
              child: Text(
              'You Do Not Have Player Account',
              style: GoogleFonts.lato(
                fontSize: 20,
                color: const Color(0xFFffffff),
                fontWeight: FontWeight.w700,
              ),
            )),
      );
    } 
    List<dynamic> profileteamData = profileData['teams'];
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
      margin: const EdgeInsets.only(top: 20, left: 5, bottom: 100),
      child: profileteamData.isEmpty
          ? Center(
              child: Text(
              'Not Joined Any Team Yet',
              style: GoogleFonts.lato(
                fontSize: 20,
                color: const Color(0xFFffffff),
                fontWeight: FontWeight.w700,
              ),
            ))
          : Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 5,
              spacing: 5,
              children: profileteamData.map((e) {
                return InkWell(
                  onTap: () {
                    Provider.of<TeamProfileProvider>(context, listen: false)
                        .settingTeamProfile({});
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child:TeamProfile(
                                  id: e['id'],
                                  pic: e['pic'],
                                ), direction: AxisDirection.left)).then((_){
                                  if(widget.id == null){
                                    String _username = DataProvider.gettingdatafromHive['id'];
                                    Connectivity.sendsock({'type': 'profile', 'data': _username});
                                  } else{
                                    Connectivity.sendsock({'type': 'profile', 'data': widget.id});
                                  }
                                });
                  },
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .31,
                      height: 90,
                      decoration: BoxDecoration(
                          color: const Color(0xFF006c6e),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFff5a5f),
                              spreadRadius: 3,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            )
                          ],
                          image: DecorationImage(
                            onError: (exception, stackTrace) {},
                            image: NetworkImage(
                                'https://www.hoopster.in/media/${e['pic']}'),
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          )),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _details() {
    if (!profileData.containsKey('totalMatch')){
      return Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height*.55
        ),
        child: Center(
              child: Text(
              'You Do Not Have Player Account',
              style: GoogleFonts.lato(
                fontSize: 20,
                color: const Color(0xFFffffff),
                fontWeight: FontWeight.w700,
              ),
            )),
      );
    }
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
