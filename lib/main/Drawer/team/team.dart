import 'package:basketball_frontend/main/Drawer/team/components/create_team.dart';
import 'package:basketball_frontend/main/Drawer/team/components/join_team.dart';
import 'package:basketball_frontend/main/Drawer/team/components/myteam.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/host_tournament.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Team extends StatelessWidget {
  const Team({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 0,
        centerTitle: true,
        title: const Text('Team',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                  onTap: (){
                    Navigator.push(context, CustomPageRoute(child: const MyTeams(),direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                    width: _width * 0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text('My Team',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    Provider.of<SearchProvider>(context, listen: false).settingSearch([]);
                    Navigator.push(context,CustomPageRoute(child:const HostTournament(pageName: 'Challenge Teams'), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                    width: _width * 0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Challenge Teams',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
                  onTap: () {
                    Provider.of<SearchProvider>(context, listen: false)
                        .settingSearch([]);
                    Provider.of<CreateTeamProvider>(context, listen: false).settingplayer(from: 'removeall');
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child: const CreateTeam(), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                    width: _width * 0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Create a Team',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    Provider.of<SearchProvider>(context, listen: false)
                      .settingSearch([]);
                    Provider.of<JoinTeamProvider>(context, listen: false)
                      .settingPending([]);
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child: const TeamJoin(), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                    width: _width * 0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Join a Team',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
