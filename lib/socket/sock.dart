import 'dart:async';
import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/socket/data_handling.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

IOWebSocketChannel? channel;

class Connectivity {
  bool isClosed = false;
  Future<void> sock(BuildContext context) async {
    var box = Hive.box('details');
    String userid = box.get('personal')['uniId'];
    String token = box.get('personal')['token'];
    channel = IOWebSocketChannel.connect(
        Uri.parse('ws://www.hoopster.in/ws/chat/'),
        headers: {
          "origin": "ws://www.hoopster.in",
          "userid": userid,
          "token": token,
        });
    channel!.stream.listen((event) {
      var res = json.decode(event);
      if (res['from'] == 'search_player' ||
          res['from'] == 'search_team' ||
          res['from'] == 'search_normal' ||
          res['from'] == 'search_tournament') {
        DataHandling().searchData(res['message'], res['from']);
      } else if (res['from'] == 'notification') {
        DataHandling().notificationData(res['message']);
      } else if (res['from'] == 'profile') {
        DataHandling().profileData(res['message']);
      } else if (res['from'] == 'team_profile') {
        DataHandling().teamProfileData(res['message']);
      } else if (res['from'] == 'my_team') {
        DataHandling().myTeam(res['message']);
      } else if (res['from'] == 'pending_request' ||
          res['from'] == 'pending_request1') {
        DataHandling().pendingRequest(res['message']);
      } else if (res['from'] == 'Tour Details') {
        DataHandling().tourDetails(res['message']);
      } else if (res['from'] == 'Get Teams') {
        DataHandling().setTeam(res['message']);
      } else if (res['from'] == 'pending tour teams') {
        DataHandling().setTourid(res['message']);
      } else if (res['from'] == 'Get Joined Tournament') {
        DataHandling().setJoinedtour(res['message']);
      } else if (res['from'] == 'Get Tournament by Host') {
        DataHandling().setHosttour(res['message']);
      } else if (res['from'] == 'pending tour request') {
        DataHandling().setPendingtour(res['message']);
      } else if (res['from'] == 'stop registration' ||
          res['from'] == 'registration check') {
        DataHandling().setfixture(res['message']);
      } else if (res['from'] == 'Get Tournament by Referee') {
        DataHandling().setReftour(res['message']);
      } else if (res['from'] == 'Get teams for matches') {
        DataHandling().setTeamsMatches(res['message']);
      } else if (res['from'] == 'Get Matches') {
        DataHandling().setAllMatches(res['message']);
      } else if (res['from'] == 'Getting Full Match Information') {
        DataHandling().setMatchesInfo(res['message']);
      } else if (res['from'] == 'All Matches of Tour') {
        DataHandling().setCurrentMatch(res['message']);
      } else if( res['from'] == 'add_another_group'){
        DataHandling().setCurrentMatchInfo(res['message']);
      } else if( res['from'] == 'Match Started by ref to ref'){        
        DataHandling().updateMatchInfoRef(res['message']);
      } else if( res['from'] == 'Match Started by ref to viewer'){
        DataHandling().updateMatchInfoViewer(res['message']);
      } else if( res['from'] == 'scoring'){
        DataHandling().updateMatchInfoViewer1(res['message']);
      } else if( res['from'] == 'ranking'){
        DataHandling().setRanking(res['message']);
      } else if( res['from'] == 'check if youtuber or not'){
        DataHandling().isYoutuber(res['message']);
      } else if( res['from'] == 'start homepage'){
        DataHandling().youtube(res['message']);
      } else if( res['from'] == 'update home page'){
        DataHandling().youtube1(res['message']);
      } else if( res['from'] == 'add youtube id'){
        DataHandling().youtubeUrlAdded(res['message']);
      } else if( res['from'] == 'Get Tournament of Specific date'){
        DataHandling().gameInfo(res['message']);
      } else if( res['from'] == 'close'){
        isClosed =true;
      }
    }, onDone: () {
      if(!isClosed){
        sock(navigatorKey.currentContext!);
      }
      }, 
       onError: (error) => wserror, 
       cancelOnError: true);
  }
  wserror(err) async {
    await sock(navigatorKey.currentContext!);
  } 

  // errBox() async {
  //   if(channel?.innerWebSocket == null){
  //     isDone = true;
  //   showModalBottomSheet(
  //     isDismissible: false,
  //     context: navigatorKey.currentContext!,
  //     builder: (context) {
  //     return Container(
  //       alignment: Alignment.center,
  //       width: double.infinity,
  //       height: 100,
  //       color: const Color(0xFFdc143d),
  //       child: const Text('Offline', textAlign: TextAlign.center, style: TextStyle(
  //         fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black
  //       ),),
  //     );
  //   });
  // }
  // }
  closingsock() {
    channel?.sink.close(status.goingAway); 
  }

  static sendsock(data) {
    // if(channel?.innerWebSocket == null){
    //   Connectivity().sock(navigatorKey.currentContext!);
    // }
    channel?.sink
        .add(jsonEncode(<String, Map<String, dynamic>>{'message': data}));
  }
}
