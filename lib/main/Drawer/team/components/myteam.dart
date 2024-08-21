import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/profile/team_profile.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class MyTeams extends StatefulWidget {
  const MyTeams({Key? key}) : super(key: key);

  @override
  State<MyTeams> createState() => _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  String team = 'player';
  late Map<String, dynamic> myTeamData;
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  late BuildContext myteamcontex;
  @override
  void initState() {
    super.initState();
    _gettingProfileData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      ThemeHelper().intro(s: [key1, key2], boxName: "myTeam", context: myteamcontex);
    });
  }

  _gettingProfileData() {
    String _username = DataProvider.gettingdatafromHive['id'];
    Connectivity.sendsock({'type': 'my_team', 'data': _username});
  }

  @override
  Widget build(BuildContext context) {
    myTeamData = Provider.of<CreateTeamProvider>(context).gettingMyTeam;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          myteamcontex =context;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
            backgroundColor: const Color(0xFFf8843d),
            elevation: 1,
            centerTitle: true,
            title: const Text('My Team',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          body: myTeamData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Showcase(
                          key: key1,
                          description: "To get the list of Teams that you as player is playing, tap on it",
                          descTextStyle: const TextStyle(
                              fontSize: 15, 
                              fontWeight: FontWeight.w600
                            ),
                          child: ElevatedButton(
                              style: team == 'player' ? _style1 : _style2,
                              onPressed: () {
                                setState(() {
                                  team = 'player';
                                });
                              },
                              child: const Text('Teams as Player')),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Showcase(
                          key: key2,
                          description: "To get the list of Teams that you have created then tap on it",
                          descTextStyle: const TextStyle(
                              fontSize: 15, 
                              fontWeight: FontWeight.w600
                            ),
                          child: ElevatedButton(
                              style: team == 'player' ? _style2 : _style1,
                              onPressed: () {
                                setState(() {
                                  team = 'owner';
                                });
                              },
                              child: const Text('Teams as Owner')),
                        ),
                      ],
                    )),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 5, top: 20),
                  child: team == 'player' ? _asPlayer() : _asOwner()),
              ],
            ),
          ),
        );
      })
    );
  }

  Widget _asPlayer() {
    List<dynamic> _getTeamsPlayer = myTeamData['player'];
    if (myTeamData['player'] == []) {
      return Center(
          child: Text(
        'You are not in any Team yet',
        style: GoogleFonts.lato(
          fontSize: 20,
          color: const Color(0xFFffffff),
          fontWeight: FontWeight.w700,
        ),
      ));
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: 5,
      spacing: 5,
      children: _getTeamsPlayer.map((e) {
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
                        ), direction: AxisDirection.left));
          },
          child: Material(
            elevation: 4.0,
            child: Container(
              width: MediaQuery.of(context).size.width * .45,
              height: 100,
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
    );
  }

  Widget _asOwner() {
    List<dynamic> _getTeamsOwner = myTeamData['own_team'];
    if (myTeamData['own_team'] == []) {
      return Center(
          child: Text(
        'You do not own any Team yet',
        style: GoogleFonts.lato(
          fontSize: 20,
          color: const Color(0xFFffffff),
          fontWeight: FontWeight.w700,
        ),
      ));
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: 5,
      spacing: 5,
      children: _getTeamsOwner.map((e) {
        return InkWell(
          onTap: () {
            Provider.of<TeamProfileProvider>(context, listen: false)
                .settingTeamProfile({});
            Navigator.push(
                context,
                CustomPageRoute(
                    child: TeamProfile(
                          id: e['team_id'],
                          pic: e['team_pic'],
                        ), direction: AxisDirection.left));
          },
          child: Material(
            elevation: 4.0,
            child: Container(
              width: MediaQuery.of(context).size.width * .45,
              height: 100,
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
                        'https://www.hoopster.in/media/${e['team_pic']}'),
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  )),
            ),
          ),
        );
      }).toList(),
    );
  }
}
