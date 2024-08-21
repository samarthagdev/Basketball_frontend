import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:showcaseview/showcaseview.dart';

class Host extends StatefulWidget {
  final String tourId;
  final String tourName;
  const Host({Key? key, required this.tourId, required this.tourName})
      : super(key: key);

  @override
  State<Host> createState() => _HostState();
}

class _HostState extends State<Host> {
  Future<void> _sendRequestTour(
      {required Map<String, dynamic> data, required String type}) async {
    final response = await http.post(
      Uri.parse('https://www.hoopster.in/mainapp/sendingjoinrequest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tour_id': widget.tourId,
        'data': data,
        'type': type
      }),
    );
    if (response.statusCode == 200) {
      if (type == 'Teams') {
        pending['tour_teams'].add(data);
      } else if (type == 'Referee') {
        pending['tour_referee'].add(data);
      }
      Provider.of<MyTournamentProvider>(context, listen: false)
          .settingPending(pending);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("There is some error")));
    }
  }

  Future<void> uploadingFixture({required String path}) async {
    final fields = <String, String>{
      'tour_id': widget.tourId,
    };
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.hoopster.in/mainapp/uploadingfixture'))
      ..headers.addAll(header)
      ..fields.addAll(fields);
    if (!imagePath!.startsWith('https://www.hoopster.in/')) {
      request.files.add(await http.MultipartFile.fromPath('pic', path,
          filename: widget.tourId, contentType: MediaType('image', 'png')));
    }
    http.Response response =
        await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      // var res = json.decode(response.body);
      isButtonSelected = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Uploaded Sucessfully")));
      Navigator.pop(context);
    } else {
      setState(() {
        isButtonSelected = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("There is some error")));
    }
  }

  final ButtonStyle _style1 = ElevatedButton.styleFrom(
      primary: const Color(0xFF7f7f7f),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.28, 45),
      maximumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 45),);

  final ButtonStyle _style2 = ElevatedButton.styleFrom(
      primary: const Color(0xFFcee7ea),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.28, 45),
      maximumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 45),);
  final ButtonStyle _style3 = ElevatedButton.styleFrom(
      primary: const Color(0xFFff0000),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.28, 45),
      maximumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.30, 45),);
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  String whichBody = 'Fixtures';
  final TextEditingController _search = TextEditingController();
  String searchtext = '';
  late Map<String, dynamic> pending;
  List<String> teamsId = [];
  List<String> refereeId = [];
  late Map<String, dynamic> fixture;
  XFile? image;
  String? imagePath;
  bool isButtonSelected =false;
  late BuildContext host;
  @override
  void initState() {
    Connectivity.sendsock(
        {'type': 'pending tour request', 'data': widget.tourId});
    Connectivity.sendsock(
        {'type': 'registration check', 'data': widget.tourId});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeHelper().intro(s: [key1, key2, key3], boxName: "mytourhost", context: host);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pending = Provider.of<MyTournamentProvider>(context).gettingPending;
    fixture = Provider.of<MyTournamentProvider>(context).gettingFixture;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          host = context;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
              backgroundColor: const Color(0xFFf8843d),
              elevation: 0,
              centerTitle: true,
              title: Text(widget.tourName, textAlign: TextAlign.center,
                  style:const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            body: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: 70,
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(children: <Widget>[
                        Showcase(
                          key: key1,
                          description: "1. Stop team registraion to make fixture\n\n2. You will get the list of teams that have accepted your invitation\n\n3. Upload the fixture.\n\n\nNote: A Scorer can only add matches if you have stoped the team registration.",
                          descTextStyle: const TextStyle(
                              fontSize: 15, 
                              fontWeight: FontWeight.w600
                            ),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  whichBody = 'Fixtures';
                                });
                              },
                              child: const Text('Fixtures'),
                              style: whichBody == 'Fixtures' ? _style1 : _style2),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Showcase(
                          key: key2,
                          description: "Send request to player to be scorer in tournament",
                          descTextStyle: const TextStyle(
                              fontSize: 15, 
                              fontWeight: FontWeight.w600
                            ),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  whichBody = 'Referee';
                                });
                                searchtext = '';
                                Provider.of<SearchProvider>(context, listen: false)
                                    .settingSearch([]);
                              },
                              child: const Text('Scorer'),
                              style: whichBody == 'Referee' ? _style1 : _style2),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Showcase(
                          key: key3,
                          description: "Send Invititation to team to join your tournament",
                          descTextStyle: const TextStyle(
                              fontSize: 15, 
                              fontWeight: FontWeight.w600
                            ),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  whichBody = 'Teams';
                                });
                                searchtext = '';
                                Provider.of<SearchProvider>(context, listen: false)
                                    .settingSearch([]);
                              },
                              child: const Text('Teams'),
                              style: whichBody == 'Teams' ? _style1 : _style2),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: _lowerBody(),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _lowerBody() {
    if (whichBody == 'Fixtures') {
      return Column(
        children: <Widget>[
          ElevatedButton(
              style: _style3,
              onPressed: () {
                if (fixture.isEmpty || fixture['registration']) {
                  Connectivity.sendsock(
                      {'type': 'stop registration', 'data': widget.tourId});
                } else {
                  Connectivity.sendsock({
                    'type': 'stop registration',
                    'data': widget.tourId,
                    'extra_data': 'start'
                  });
                }
              },
              child: fixture.isEmpty || fixture['registration']
                  ? const Text('Stop Teams Registration')
                  : const Text('Start Teams Registration')),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: fixture.isEmpty || fixture['registration']
                  ? const Center(
                      child: Text('Stop Team Registration to make Fixtures'))
                  : _fixture(fixture['teams']))
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _search,
              cursorColor: Colors.white,
              onChanged: (value) {
                if (!searchtext.startsWith(value)) {
                  searchtext = value;
                  if (whichBody == 'Teams') {
                    Connectivity.sendsock(
                        {'type': 'search_team', 'data': value});
                  } else {
                    Connectivity.sendsock(
                        {'type': 'search_player', 'data': value});
                  }
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
                labelText: 'Search for id, Place, Name',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 42, 41, 44),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ),
          _searchBody()
        ],
      );
    }
  }

  Widget _fixture(List<dynamic> value) {
    List<dynamic> _teams = [];
    for (var x in value) {
      if (x['status'] == 'accept') {
        _teams.add(x);
      }
    }
    String whichBody1 = 'team_names';
    return StatefulBuilder(builder: (context, innerState) {
      return Column(
        children: <Widget>[
          Text('Total number of Teams ${_teams.length}',
              style: GoogleFonts.lato(
                fontSize: 20,
                color: const Color(0xFF7f7f7f),
                fontWeight: FontWeight.w700,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  innerState(() {
                    whichBody1 = 'team_names';
                  });
                },
                child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 40,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 3.0,
                                color: whichBody1 == 'team_names'
                                    ? const Color(0xFF7f7f7f)
                                    : const Color(0xFFf8843d),
                                style: BorderStyle.solid))),
                    child: Text(
                      'Team Names',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  innerState(() {
                    whichBody1 = 'fixture_upload';
                  });
                },
                child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 40,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 3.0,
                                color: whichBody1 == 'fixture_upload'
                                    ? const Color(0xFF7f7f7f)
                                    : const Color(0xFFf8843d),
                                style: BorderStyle.solid))),
                    child: Text(
                      'Upload Fixture',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(child: _fixtureLowerBody(whichBody1, _teams))
        ],
      );
    });
  }

  Widget _fixtureLowerBody(String body, List<dynamic> _teams) {
    if (body == 'team_names') {
      return ListView(
        children: _teams.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage('https://www.hoopster.in/media/${e['pic']}'),
              ),
              title: Text(e['team_name'],
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  )),
            ),
          );
        }).toList(),
      );
    }
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        StatefulBuilder(builder: (context, innerState) {
          return InkWell(
              onTap: () async {
                try {
                  image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image == null) return;
                  imagePath = image!.path;
                  innerState(() => imagePath);
                } on PlatformException catch (e) {
                  throw Exception(e);
                }
              },
              child: imagePath != null
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.fill),
                          border: Border.all(
                              width: 1.0,
                              color: Colors.black,
                              style: BorderStyle.solid)),
                    )
                  : fixture['fixture'] != null && fixture['fixture'].isNotEmpty
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://www.hoopster.in/media/${fixture['fixture']}'),
                                  fit: BoxFit.fill),
                              border: Border.all(
                                  width: 1.0,
                                  color: Colors.black,
                                  style: BorderStyle.solid)),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
                          color: const Color(0xFFfaca39),
                          child: const Text(
                            'Please upload your tournament Fixture',
                            textAlign: TextAlign.center,
                          ),
                        ));
        }),
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: StatefulBuilder(
            builder: (context, innerState) {
              return ElevatedButton(
                  style: _style3,
                  onPressed:isButtonSelected?null: () {
                    if (imagePath != null) {
                      innerState((){
                        isButtonSelected = true;
                      });
                      uploadingFixture(path: imagePath!);
                    }
                  },
                  child:isButtonSelected?const Center(child: CircularProgressIndicator(color: Colors.pink),): const Text('Upload'));
            }
          ),
        )
      ],
    );
  }

  Widget _searchBody() {
    List<dynamic> s = Provider.of<SearchProvider>(context).gettingsearchbody;
    List<dynamic> tourTeam = pending['tour_teams'];
    List<dynamic> tourReferee = pending['tour_referee'];
    for (var x in tourTeam) {
      teamsId.add(x['team_id']);
    }
    for (var x in tourReferee) {
      refereeId.add(x['userName']);
    }
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
          children: s.map((e) {
            if (whichBody == 'Teams') {
              e['pic'] = e['team_pic'];
              e['userName'] = e['team_name'] ?? '';
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                trailing: StatefulBuilder(builder: (context, innerState) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0e2f44),
                      ),
                      onPressed: () {
                        e['status'] = 'pending';
                        if (whichBody == 'Teams') {
                          if (!teamsId.contains(e['team_id'])) {
                            _sendRequestTour(data: e, type: 'Teams');
                          }
                        } else if (whichBody == 'Referee') {
                          if (!refereeId.contains(e['userName'])) {
                            _sendRequestTour(data: e, type: 'Referee');
                          }
                        }
                      },
                      child: whichBody == 'Teams'
                          ? teamsId.contains(e['team_id'])
                              ? const Text('Invited')
                              : const Text('Invite')
                          : refereeId.contains(e['userName'])
                              ? const Text('Selected')
                              : const Text('select'));
                }),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage('https://www.hoopster.in/media/${e['pic']}'),
                ),
                title: Text(e['userName'],
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    )),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
