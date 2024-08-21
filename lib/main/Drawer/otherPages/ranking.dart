import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key, required this.tourId, required this.tourName})
      : super(key: key);
  final String tourId;
  final String tourName;
  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  String whichBody = 'rebound';
  final ButtonStyle _style = OutlinedButton.styleFrom(
      backgroundColor: const Color(0xFF333333),
      side: const BorderSide(color: Color(0xFF7f7f7f), width: 2),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  final ButtonStyle _style1 = OutlinedButton.styleFrom(
      backgroundColor: const Color(0xFFf0ece5),
      side: const BorderSide(color: Color(0xFFfe015a), width: 3),
      minimumSize: Size(
          MediaQuery.of(navigatorKey.currentContext!).size.width * 0.40, 50));
  late Map<String, dynamic> info;
  String dropdownValue = 'Team';
  @override
  void initState() {
    Connectivity.sendsock(
        {'type': 'ranking', 'data': widget.tourId, 'extra_data': 'rebound'});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    info = Provider.of<RankingProvider>(context).gettingRanking;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 1,
        centerTitle: true,
        title: const Text('Ranking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: info.isEmpty?
      const Center(
        child: CircularProgressIndicator(
          color: Colors.pinkAccent,
        ),
      )
      : 
      Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
            children: <Widget>[_upperBody(), _selectChoices(), _lowerBody()]),
      ),
    );
  }

  Widget _upperBody() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      height: 60,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            OutlinedButton(
                style: whichBody == 'rebound' ? _style : _style1,
                onPressed: () {
                  Connectivity.sendsock({
                    'type': 'ranking',
                    'data': widget.tourId,
                    'extra_data': 'rebound'
                  });
                  setState(() {
                    whichBody = 'rebound';
                  });
                },
                child: Text(
                  'Rebound',
                  style: TextStyle(
                      color: whichBody == 'rebound'
                          ? Colors.orange
                          : Colors.black),
                )),
            const SizedBox(
              width: 5,
            ),
            OutlinedButton(
                style: whichBody == 'points' ? _style : _style1,
                onPressed: () {
                  Connectivity.sendsock({
                    'type': 'ranking',
                    'data': widget.tourId,
                    'extra_data': 'points'
                  });
                  setState(() {
                    whichBody = 'points';
                  });
                },
                child: Text(
                  'Points',
                  style: TextStyle(
                      color:
                          whichBody == 'points' ? Colors.orange : Colors.black),
                )),
            const SizedBox(
              width: 5,
            ),
            OutlinedButton(
                style: whichBody == 'assist' ? _style : _style1,
                onPressed: () {
                  Connectivity.sendsock({
                    'type': 'ranking',
                    'data': widget.tourId,
                    'extra_data': 'assist'
                  });
                  setState(() {
                    whichBody = 'assist';
                  });
                },
                child: Text(
                  'Assist',
                  style: TextStyle(
                      color:
                          whichBody == 'assist' ? Colors.orange : Colors.black),
                )),
            const SizedBox(
              width: 5,
            ),
            OutlinedButton(
                style: whichBody == 'steal' ? _style : _style1,
                onPressed: () {
                  Connectivity.sendsock({
                    'type': 'ranking',
                    'data': widget.tourId,
                    'extra_data': 'steal'
                  });
                  setState(() {
                    whichBody = 'steal';
                  });
                },
                child: Text(
                  'Steal',
                  style: TextStyle(
                      color:
                          whichBody == 'steal' ? Colors.orange : Colors.black),
                )),
            const SizedBox(
              width: 5,
            ),
            OutlinedButton(
                style: whichBody == 'block' ? _style : _style1,
                onPressed: () {
                  Connectivity.sendsock({
                    'type': 'ranking',
                    'data': widget.tourId,
                    'extra_data': 'block'
                  });
                  setState(() {
                    whichBody = 'block';
                  });
                },
                child: Text(
                  'Block',
                  style: TextStyle(
                      color:
                          whichBody == 'block' ? Colors.orange : Colors.black),
                )),
          ],
        ),
      ),
    );
  }

  Widget _selectChoices() {
    return DropdownButton<String>(
        value: dropdownValue,
        items: const <DropdownMenuItem<String>>[
          DropdownMenuItem(value: 'Team', child: Text('Team')),
          DropdownMenuItem(value: 'Player', child: Text('Player')),
        ],
        onChanged: (value) {
          setState(() {
            dropdownValue = value!;
          });
        });
  }

  Widget _lowerBody() {
    List<dynamic> info1 =
        dropdownValue == 'Team' ? info['team'] : info['player'];
    String score = '';
    return Expanded(
        child: ListView(
            children: info1.map((e) {
      Map<String, dynamic> e1 =e;
      if(e1.containsKey('rebound')){
        score = 'rebound';
      } else if(e1.containsKey('points')){
        score = 'points';
      } else if(e1.containsKey('points')){
        score = 'points';
      } else if(e1.containsKey('steal')){
        score = 'steal';
      } else if(e1.containsKey('block')){
        score = 'block';
      } else if(e1.containsKey('assist')){
        score = 'assist';
      }
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 80,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.35,
              height: 60,
              decoration: BoxDecoration(
                  color: const Color(0XFFf0ece5),
                  borderRadius: BorderRadius.circular(30)),
              child: dropdownValue == 'Team'
                  ? Text(
                      e['team_name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    )
                  : Text(
                      e['player_name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
            ),
            const SizedBox(
              width: 50,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.35,
              height: 60,
              decoration: BoxDecoration(
                  color: const Color(0XFFf0ece5),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                      e[score].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    )
                  
            ),
          ],
        ),
      );
    }).toList()));
  }
}
