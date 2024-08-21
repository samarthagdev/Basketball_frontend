import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTuber extends StatefulWidget {
  const YouTuber({Key? key}) : super(key: key);

  @override
  State<YouTuber> createState() => _YouTuberState();
}

class _YouTuberState extends State<YouTuber> {
  bool isYoutube = true;
  final TextEditingController _youtube = TextEditingController();
   bool live = false;
  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff7f50),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  final utube = RegExp(r'^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.be)\/.+$');
  
  @override
  void initState() {
    _gettingHiveData();
    super.initState();
  }

  _gettingHiveData() {
    final String _user = DataProvider.gettingdatafromHive['id'];
    Connectivity.sendsock({'type': 'check if youtuber or not', 'data': _user});
  }
  Future<bool> _onWillPop() async {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

    return false;
  }
  @override
  Widget build(BuildContext context) {
    isYoutube = Provider.of<YoutubeProvider>(context).gettingYoutube;
    if (!isYoutube) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goBack());
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 0,
        centerTitle: true,
        title: const Text('Add url of your Youtube Videos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _youtube,
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                fillColor: Color(0xFF7f7f7f),
                filled: true,
                labelText: 'Add Video Url',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 42, 41, 44),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [                
                const Text('Live', style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700
                ),),
                const SizedBox(width: 10,),
                Checkbox(
                  value: live,
                  onChanged: (bool? value) {
                    setState(() {
                      live = value!;
                    });
                  },
                ),
              ],
            ), //
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: _style2, onPressed: () {
                  if(utube.hasMatch(_youtube.text)){
                    String? id = YoutubePlayer.convertUrlToId(_youtube.text);
                    if(id != null){
                      Connectivity.sendsock({'type':'add youtube id', 'data':id, 'is_live':live});
                      setState(() {
                        live = false;
                      _youtube.clear();
                      });
                    }
                  } else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Url")));
                  }
                  
                }, child: const Text('Add'))
          ],
        ),
      ),
    );
  }

  void _goBack() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: AlertDialog(
              content: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'You are not registered as Youtuber in Hooopster.\nTo register your account contact:- \nbasketbcommunity@gmail.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                        style: _style2,
                        onPressed: () {
                          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);                         
                        },
                        child: const Text('Go Back'))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
