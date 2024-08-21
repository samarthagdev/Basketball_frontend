import 'package:basketball_frontend/main/BottomNavigationBar/profile/profile.dart';
import 'package:basketball_frontend/main/BottomNavigationBar/profile/team_profile.dart';
import 'package:basketball_frontend/main/Drawer/otherPages/ranking.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class JoinTourDetails extends StatefulWidget {
  final String tourId;
  const JoinTourDetails({Key? key, required this.tourId}) : super(key: key);

  @override
  State<JoinTourDetails> createState() => _JoinTourDetailsState();
}

class _JoinTourDetailsState extends State<JoinTourDetails> {
  late Map<String, dynamic> _details;
  String whichBody = 'team';
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  late BuildContext tourDescription;
  @override
  void initState() {
    Connectivity.sendsock({'type': 'Tour Details', 'data': widget.tourId});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeHelper().intro(s: [key1, key2, key3, key4, key5], boxName: "tourDescription", context: tourDescription);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _details = Provider.of<JoinTournamentProvider>(context).gettingDetails;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          tourDescription = context;
          return Scaffold(
            floatingActionButton: 
            Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Showcase(
                  key: key1,
                    description: "Tournament Ranking",
                    descTextStyle: const TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w600
                      ),
                  child: FloatingActionButton.extended(
                  heroTag: 'btn1',
                  backgroundColor: const Color(0xFFf8843d),
                  onPressed: () {
                    Navigator.push(context, CustomPageRoute(child:Ranking(tourId: _details['tour_id'], tourName: _details['tour_name']), direction: AxisDirection.left));
                  },
                  label: const Icon(Icons.bar_chart)),
                ),
                const SizedBox(height: 5,),
                Showcase(
                  key: key2,
                  description: "Tournament Fixture",
                  descTextStyle: const TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w600
                    ),
                  child: FloatingActionButton.extended(
                  heroTag: 'btn2',
                  backgroundColor: const Color(0xFF003366),
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: _details['tour_fixture'] != null? Container(
                            height: MediaQuery.of(context).size.height * .7,
                            width: MediaQuery.of(context).size.width* .7,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage('https://www.hoopster.in/media/${_details['tour_fixture']}')
                              )
                            ),
                          ):Container(
                            height: 200,
                            width: 100,
                            alignment: Alignment.center,
                            child: const Text('No Fixture Uploaded by Host', textAlign: TextAlign.center, style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),),
                          ),
                        );
                      });
                  },
                  label: const Icon(Icons.account_tree)),
                )
              ],
            ),
            backgroundColor: const Color(0xFFf8843d),
            resizeToAvoidBottomInset: false,
            body: _details.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0XFFffffff),
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      ClipPath(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: double.infinity,
                          color: const Color(0xFF25262a),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 25,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(CupertinoIcons.back,
                                      size: 20, color: Color(0xFFffffff)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
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
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/curry1.png'),
                                      )),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _details['tour_category'],
                                    style: GoogleFonts.anton(
                                        fontSize: 30, color: const Color(0xFFffffff)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 22,
                                width: MediaQuery.of(context).size.width *.95,
                                child: Text(
                                  _details['tour_name'],
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFffffff),
                                  ),
                                ),
                              ),
                              Text(
                                _details['tour_owner'],
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
                        clipper: CustomClipPath(),
                      ),
                      ClipPath(
                        clipper: TopClipPath(),
                        child: Container(
                          margin: const EdgeInsets.only(top: 250, right: 15),
                          decoration: const BoxDecoration(
                              color: Color(0xFFffffff),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0))),
                          height: MediaQuery.of(context).size.height * .6,
                          child: StatefulBuilder(builder: (context, innerState) {
                            return Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 60,
                                  margin: const EdgeInsets.only(left: 20, right: 20),
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFf0f6fd),
                                      borderRadius: BorderRadius.circular(30.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Showcase(
                                        key: key3,
                                        description: "List of Teams in Tournament",
                                        descTextStyle: const TextStyle(
                                            fontSize: 15, 
                                            fontWeight: FontWeight.w600
                                          ),
                                        child: IconButton(
                                            onPressed: () {
                                              innerState(() {
                                                whichBody = 'team';
                                              });
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.person_2_fill)),
                                      ),
                                      Showcase(
                                        key: key4,
                                        description: "Tournament description",
                                        descTextStyle: const TextStyle(
                                            fontSize: 15, 
                                            fontWeight: FontWeight.w600
                                          ),
                                        child: IconButton(
                                            onPressed: () {
                                              innerState(() {
                                                whichBody = 'description';
                                              });
                                            },
                                            icon: const Icon(Icons.description)),
                                      ),
                                      Showcase(
                                        key: key5,
                                        description: "List of Scorer in Tournament",
                                        descTextStyle: const TextStyle(
                                            fontSize: 15, 
                                            fontWeight: FontWeight.w600
                                          ),
                                        child: IconButton(
                                            onPressed: () {
                                              innerState(() {
                                                whichBody = 'referee';
                                              });
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.person_crop_rectangle)),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: _lowerBody()),
                              ],
                            );
                          }),
                        ),
                      )
                    ],
                  ),
          );
        }
      ),
    );
  }

  Widget _lowerBody() {
    if (whichBody == 'team') {
      List<dynamic> _teams = _details['tour_teams'];
      return ListView(
        children: _teams.map((e) {
          e['team_name'] = e['team_name'].toUpperCase();
          return InkWell(
            onTap: () {
              Provider.of<TeamProfileProvider>(context, listen: false)
                  .settingTeamProfile({});
              Navigator.push(
                  context,
                  CustomPageRoute(
                      child: TeamProfile(id: e['team_id'], pic: e['pic']), direction: AxisDirection.left));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(34.0),
                  child: Container(
                    height: 200,
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
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://www.hoopster.in/media/${e['pic']}'),
                        )),
                  ),
                ),
                title: Text(e['team_name']),
              ),
            ),
          );
        }).toList(),
      );
    } else if (whichBody == 'description') {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(34.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*.4,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFec5c87),
                      borderRadius: BorderRadius.circular(34.0)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Starting Date', textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFffffff),
                            ),),
                        Text(_details['tour_date'], textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFffad2c),
                          ),),
                      ],
                    ),
                  )
                ),
                const SizedBox(width: 10,),
                Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(34.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*.4,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFa871b9),
                      borderRadius: BorderRadius.circular(34.0)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Venue', textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFffffff),
                            ),),
                        Text(_details['tour_venue'], textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFffad2c),
                          ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Material(
              elevation: 4.0,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container( 
                    padding: const EdgeInsets.only(bottom: 15),
                    width: MediaQuery.of(context).size.width*.6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8b80da),
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Description', textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFffffff),
                            ),),
                    Text(_details['tour_description'],textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFffad2c),
                          ),)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      List<dynamic> _referee = _details['tour_referee'];
      return ListView(
        children: _referee.map((e) {
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
                          ), direction: AxisDirection.left));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: ListTile(
                leading: e['pic'] != null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://www.hoopster.in/media/${e['pic']}'),
                      )
                    : const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFffd700),
                      ),
                title: Text(e['userName']),
              ),
            ),
          );
        }).toList(),
      );
    }
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - size.height * .3);
    path.lineTo(size.width, size.height - size.height * .3);
    path.lineTo(size.width, 0);
    path.moveTo(size.width, size.height - size.height * .3);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width - 18, size.height, size.width - 18,
        size.height - size.height * .1);
    path.lineTo(size.width - 18, size.height - size.height * .1);
    path.lineTo(size.width - 18, size.height - size.height * .3);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopClipPath extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
