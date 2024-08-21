import 'dart:convert';
import 'package:basketball_frontend/main/BottomNavigationBar/youtubefullvideo.dart';
import 'package:basketball_frontend/main/Drawer/otherPages/youtube.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/individual_match_info.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late YoutubePlayerController _ytbPlayerController;
  String whichBody = 'Basketball Videos';
  final _controller = ScrollController();
  final _controller1 = ScrollController();
  List<String> filter = [];
  late double hei;
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey(); 
  late BuildContext homeContext;
  @override
  void initState() {
    Connectivity.sendsock({'type': 'start homepage', 'data': 1});
    super.initState();
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset){
        _fecthData('other video next page number');
      }
    });
    _controller1.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.offset){
        _fecthData('live match next page number');
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      ThemeHelper().intro(s: [key1, key2, key3], boxName: "home", context: homeContext);
    });
  }

  Future<void> _fecthData(whichpage)async{
    var box = Hive.box('details');
    if(whichpage == 'live match next page number'){
      int page = box.get('live match next page number', defaultValue: 0);
      if(page != 0){
        Connectivity.sendsock({'type':'update home page', 'data':1, 'live match next page number':page});
      }
    } else{
      int page = box.get('other video next page number', defaultValue: 0);
      if(page != 0){
        Connectivity.sendsock({'type':'update home page', 'data':1, 'other video next page number':page});
      }
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hei = Provider.of<DrawerProvider>(context).gettinghei;
    return GestureDetector(
      onTap: (){
        if(hei == 0.55){
           Provider.of<DrawerProvider>(context, listen: false)
                  .settinghei(0.0);
        }
      },
      child: ShowCaseWidget(
        builder: Builder(
          builder: (context) {
            homeContext=context;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: Showcase(
                  key: key1,
                  description: "Make sure to make a player account in the menu bar",
                  descTextStyle: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600
                    ),
                  child: IconButton(
                      icon: const Icon(CupertinoIcons.line_horizontal_3,
                          size: 30, color: Color(0xFF000000)),
                      onPressed: () => Provider.of<DrawerProvider>(context, listen: false)
                          .settinghei(0.55)),
                ),
                actions: [
                  Showcase(
                    key: key2,
                    description: "To filter Live Matches tap on it",
                    descTextStyle: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_alt_outlined,
                          size: 30, color: Color(0xFF000000)),
                      onPressed: ()async{
                         filter =  await ThemeHelper().filter()??[];
                         if(filter.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No venue found for applied filter')));
                         }
                         setState(() {
                           
                         });
                      }),
                  ),
                  Showcase(
                    key: key3,
                    description: "To add your youtube video tap on it.",
                    descTextStyle: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600
                    ),
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.plus,
                          size: 30, color: Color(0xFF000000)),
                      onPressed: () => Navigator.push(context, CustomPageRoute(child: const YouTuber(), direction: AxisDirection.left))),
                  ),
                ],
              ),
              body: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                whichBody = 'Basketball Videos';
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .25,
                              alignment: Alignment.center,
                              height: 60,
                              margin: const EdgeInsets.only(top: 10, left: 20),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: whichBody == 'Basketball Videos'
                                              ? Colors.grey
                                              : Colors.orange,
                                          style: BorderStyle.solid,
                                          width: 4))),
                              child: Text(
                                'Basketball Videos',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoSlab(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                whichBody = 'Live Matches';
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .25,
                              alignment: Alignment.center,
                              height: 60,
                              margin: const EdgeInsets.only(top: 10, left: 20),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: whichBody == 'Live Matches'
                                              ? Colors.grey
                                              : Colors.orange,
                                          style: BorderStyle.solid,
                                          width: 4))),
                              child: Text(
                                'Live Matches',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoSlab(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                whichBody = 'Live Streaming';
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .25,
                              alignment: Alignment.center,
                              height: 60,
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 20,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: whichBody == 'Live Streaming'
                                              ? Colors.grey
                                              : Colors.orange,
                                          style: BorderStyle.solid,
                                          width: 4))),
                              child: Text(
                                'Live Streaming',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoSlab(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: whichBody == 'Basketball Videos'
                          ? _otherVideo()
                          : whichBody == 'Live Streaming'
                              ? _streaming()
                              : _liveTour())
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _streaming() {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('details').listenable(keys: ['live videos']),
      builder: (context, box, widget) {
        List<dynamic> liveStream =
            box.get('live videos', defaultValue: <dynamic>[]);
        return ListView.builder(
          itemCount: liveStream.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, CustomPageRoute(child:FuLLVideo(id: liveStream[index]['video_id'],live: true,), direction: AxisDirection.left));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .6,
                height: MediaQuery.of(context).size.height * .3,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                decoration:
                    BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage('https://i.ytimg.com/vi/${liveStream[index]['video_id']}/hqdefault.jpg')
                      ),
                      borderRadius: BorderRadius.circular(20)), 
              ),
            );
          },
        );
      },
    );
  }

  Widget _liveTour() {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('details').listenable(keys: ['live Match', 'live match next page number']),
      builder: (context, box, widget) {
        List<dynamic> liveMatch =
            box.get('live Match', defaultValue: <dynamic>[]);
        int page = box.get('live match next page number', defaultValue: 0);
        if(filter.isNotEmpty){
          List<dynamic> filterLiveMatch = [];
          for(var y in filter){
            for(var x in liveMatch){
            if((x['match_venue'].toLowerCase()).contains(y.toLowerCase())){
              filterLiveMatch.add(x);
            }
          }
          }
          liveMatch = filterLiveMatch;
        }
        return ListView.builder(
          controller: _controller1,
          itemCount:page != 0? liveMatch.length+1:liveMatch.length,
          itemBuilder: (context, index) {
            if(index<liveMatch.length){
              Map<String, dynamic> e = liveMatch[index];
              Map<String, dynamic> matchBetween = json.decode(e['match_between']);
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CustomPageRoute(
                        child: IndividualMatchInfo(
                              matchBetween: matchBetween,
                              matchId: e['match_id'],
                              pageName: "On Going Tournament",
                            ), direction: AxisDirection.left));
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                height: MediaQuery.of(context).size.height * .2,
                width: MediaQuery.of(context).size.height * .8,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Material(
                  color: const Color(0xFFc0c0c0),
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: const Color(0xFFc39797),
                                borderRadius: BorderRadius.circular(20.0)),
                            height: 70,
                            width: MediaQuery.of(context).size.width * .35,
                            child: Text(matchBetween['team A']['team_name']),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'VS',
                            style: GoogleFonts.alumniSans(
                                fontSize: 35, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: const Color(0xFFc39797),
                                borderRadius: BorderRadius.circular(20.0)),
                            height: 70,
                            width: MediaQuery.of(context).size.width * .35,
                            child: Text(matchBetween['team B']['team_name']),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFcbbeb5),
                            borderRadius: BorderRadius.circular(20.0)),
                        height: 50,
                        width: MediaQuery.of(context).size.width * .45,
                        child: Text(matchBetween['time']),
                      ),
                    ],
                  ),
                ),
              ),
            );
            }
            else {
              return const CircularProgressIndicator(
              color: Colors.pink,
            );
            }
          },
        );
      },
    );
  }

  Widget _otherVideo() {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('details').listenable(keys: ['other videos', 'other video next page number']),
      builder: (context, box, widget) {
        List<dynamic> videos =
            box.get('other videos', defaultValue: <dynamic>[]);
        int page = box.get('other video next page number', defaultValue: 0);
        return ListView.builder(
          controller: _controller,
          itemCount: page != 0?videos.length+1:videos.length,
          itemBuilder: (context, index) {
            if(index<videos.length){
              return InkWell(
              onTap: (){
                Navigator.push(context, CustomPageRoute(child: FuLLVideo(id: videos[index]['video_id'],live: false,), direction: AxisDirection.left));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .6,
                height: MediaQuery.of(context).size.height * .3,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                decoration:
                    BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage('https://i.ytimg.com/vi/${videos[index]['video_id']}/hqdefault.jpg')
                      ),
                      borderRadius: BorderRadius.circular(20)), 
              ),
            );
            } else{
              return const Center(
                child:  CircularProgressIndicator(
                  color: Colors.pinkAccent,
                ),
              );
            }
          },
        );
      },
    );
  }
}
