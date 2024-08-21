import 'package:basketball_frontend/main/Drawer/tournament/components/current_tournament.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/host_tournament.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/join_tournament.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/mytournament.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Tournament extends StatefulWidget {
  const Tournament({ Key? key }) : super(key: key);

  @override
  State<Tournament> createState() => _TournamentState();
}

class _TournamentState extends State<Tournament> {
  
 late final String _id;
 late List<dynamic> _teams;

 @override
  void initState() {
    _getingId();
    super.initState();
  }
  void _getingId(){
    _id = DataProvider.gettingdatafromHive['id'];
    Connectivity.sendsock({'type':'Get Teams', 'data':_id});
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    _teams = Provider.of<JoinTournamentProvider>(context).getTeams;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 0,
        centerTitle: true,
        title: const Text('Tournament',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
                  onTap: (){
                    Provider.of<SearchProvider>(context, listen: false).settingSearch([]);
                    Navigator.push(context, CustomPageRoute(child: const HostTournament(pageName: 'Host Tournament',), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                      width: _width * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Host Tournament',
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
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child: const CurrentTournamnet(pageName: 'Previous Tournament',), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                      width: _width * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Previous Tournament',
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
                    Provider.of<SearchProvider>(context, listen: false).settingSearch([]);
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child: const CurrentTournamnet(pageName: 'On Going Tournament',), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                      width: _width * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Current Tournament',
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
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            child: JoinTournament(teams: _teams,), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                      width: _width * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Join Tournament',
                        textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    Provider.of<SearchProvider>(context, listen: false)
                      .settingSearch([]);
                    Navigator.push(context, CustomPageRoute(child:const MyTournament(), direction: AxisDirection.left));
                  },
                  child: Container(
                    height: 60,
                      width: _width * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(20.0)),
                    child: Text('My Tournamennt',
                        textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}