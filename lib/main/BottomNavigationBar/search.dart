import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/profile/profile.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/profile/team_profile.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchData extends StatefulWidget {
  const SearchData({Key? key}) : super(key: key);

  @override
  State<SearchData> createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> {
  String searchtext = '';
  late List<dynamic> searchBody;
  String searchitem = 'search_normal';
  final TextEditingController _search = TextEditingController();
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));

  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));

  @override
  Widget build(BuildContext context) {
    searchBody = Provider.of<SearchProvider>(context).gettingsearchbody;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          body2(),
          const SizedBox(
            height: 10,
          ),
          body1(),
          body3(),
        ],
      ),
    );
  }

  Widget body1() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _search,
        cursorColor: Colors.white,
        onChanged: (value) {
          if (!searchtext.startsWith(value)) {
            searchtext = value;
            Connectivity.sendsock({'type': searchitem, 'data': value});
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
          labelText: searchitem == "search_player"? 'Search for player id, place':searchitem == "search_team"?'Search for team name, place':'Search user id, place',
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 42, 41, 44),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }

  Widget body2() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15, right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: <Widget>[
              // ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         searchBody.clear();
              //         searchitem = 'search_player';
              //       });
              //       if (_search.text.isNotEmpty) {
              //         Connectivity.sendsock(
              //             {'type': 'search_player', 'data': _search.text});
              //       }
              //     },
              //     child: const Text('Player'),
              //     style: searchitem == 'search_player' ? _style1 : _style2),
              // const SizedBox(
              //   width: 5,
              // ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchBody.clear();
                      searchitem = 'search_team';
                    });
                    if (_search.text.isNotEmpty) {
                      Connectivity.sendsock(
                          {'type': 'search_team', 'data': _search.text});
                    }
                  },
                  child: const Text('Team'),
                  style: searchitem == 'search_team' ? _style1 : _style2),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchBody.clear();
                      searchitem = 'search_normal';
                    });
                    if (_search.text.isNotEmpty) {
                      Connectivity.sendsock(
                          {'type': 'search_normal', 'data': _search.text});
                    }
                  },
                  child: const Text('Player'),
                  style: searchitem == 'search_normal' ? _style1 : _style2),
            ],
          ),
      ),
    );
  }

  Widget body3() {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 25),
          child: ListView(
            children: searchBody.map((e) {
              if (searchitem == 'search_team') {
                e['pic'] = e['team_pic'];
                e['userName'] = e['team_name'] ?? '';
              } else if (searchitem == 'search_normal') {
                e['pic'] = e['profile_pic'];
              }
              return InkWell(
                onTap: () {
                  if (searchitem == 'search_normal' ||
                      searchitem == 'search_player') {
                    Provider.of<ProfileProvider>(context, listen: false)
                        .settingProfile({});
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child: Profile(
                                  id: e['userName'],
                                  page: 'other',
                                ), direction: AxisDirection.left));
                  } else if (searchitem == 'search_team') {
                    Provider.of<TeamProfileProvider>(context, listen: false)
                        .settingTeamProfile({});
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child:TeamProfile(
                                  id: e['team_id'],
                                  pic: e['pic'],
                                ), direction: AxisDirection.left));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: e['pic'] != null
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage:NetworkImage(
                                        'https://www.hoopster.in/media/${e['pic']}'),
                          )
                        : const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFffd700),
                          ),
                    title: Text(e['userName'] ?? '',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                        )),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}
