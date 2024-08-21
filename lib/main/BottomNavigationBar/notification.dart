import 'dart:convert';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllNotification extends StatefulWidget {
  const AllNotification({Key? key}) : super(key: key);

  @override
  State<AllNotification> createState() => _AllNotificationState();
}

class _AllNotificationState extends State<AllNotification> {
  
  @override
  void initState() {
    super.initState();
    Connectivity.sendsock({'data':'notification','type':'notification'});
  }
  
  late List<dynamic> notification;
  final ButtonStyle _style = ElevatedButton.styleFrom(
    primary: const Color(0xFF003366),
    // minimumSize: const Size(50, 30),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      side: const BorderSide(color: Color(0xFF003366))
    )
  );
  final ButtonStyle _style1 = ElevatedButton.styleFrom(
    primary: const Color(0xFFcc0000),
    // minimumSize: const Size(50, 30),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      side: const BorderSide(color: Color(0xFFcc0000))
    )
  );

  @override
  Widget build(BuildContext context) {
    notification = Provider.of<NotificationProvider>(context).gettingNotification;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Notification',
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        body: ListView(children: notification.map((e) {
          var e1 = json.decode(e['messages']);
          if(e1['type'] == 'normal'){
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                title: Text(e1['title']),
                subtitle: Text(e1['body']),
              ),
            );
          }
          else if(e1['type'] == 'createTeam'){
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                title: Text(e1['team']),
                subtitle: Text("${e1['owner']} requested you to join them as team player"),
                trailing: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.45,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response', 'data':e1, 'pk':e['id'], 'response':'accept'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Join'), style: _style),
                      const SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response', 'data':e1, 'pk':e['id'], 'response':'decline'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Reject'), style: _style1)
                    ],
                  ),
                ),
              ),
            );
          }
          else if(e1['type'] == 'join_team'){
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                title: Text(e1['team'], textAlign: TextAlign.center),
                subtitle: Text('${e1['userName']} wants to join', textAlign: TextAlign.center,),
                trailing: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.45,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response1', 'data':e1, 'pk':e['id'], 'response':'accept'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Accept'), style: _style),
                      const SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response1', 'data':e1, 'pk':e['id'], 'response':'decline'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Reject'), style: _style1)
                    ],
                  ),
                ),
              ),
            );
          }
          else if(e1['type'] == 'team_tournament'){
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                title: Text(e1['tour_name']),
                subtitle: Text("${e1['host']} wants your team ${e1['team_name']} to participate"),
                trailing: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.45,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response 2', 'data':e1, 'pk':e['id'], 'response':'accept'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Join'), style: _style),
                      const SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response 2', 'data':e1, 'pk':e['id'], 'response':'decline'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Reject'), style: _style1)
                    ],
                  ),
                ),
              ),
            );
          }
          else if(e1['type'] == 'referee_tournament'){
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                title: Text(e1['tour_name']),
                subtitle: Text("${e1['host']} wants you to join as scorer"),
                trailing: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.45,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response 3', 'data':e1, 'pk':e['id'], 'response':'accept'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Join'), style: _style),
                      const SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response 3', 'data':e1, 'pk':e['id'], 'response':'decline'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Reject'), style: _style1)
                    ],
                  ),
                ),
              ),
            );
          }
          else if(e1['type'] == 'join_tournament'){
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                title: Text('${e1['team_name']} - ${e1['tour_name']}'),
                subtitle: Text("${e1['team_owner']} wants to participate in tournament"),
                trailing: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.45,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response 4', 'data':e1, 'pk':e['id'], 'response':'accept'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Join'), style: _style),
                      const SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){
                        Connectivity.sendsock({'type': 'notification response 4', 'data':e1, 'pk':e['id'], 'response':'decline'});
                        notification.remove(e);
                        Provider.of<NotificationProvider>(context, listen: false).settingNotification(notification);
                      }, child: const Text('Reject'), style: _style1)
                    ],
                  ),
                ),
              ),
            );
          }
          else{
          return Expanded(child: Container(
            alignment: Alignment.center,
            child: Text('No Notification', style: GoogleFonts.roboto(
              fontSize:25,
              fontWeight: FontWeight.bold
            ),),
          ));
          }
          
        }).toList()
        )
        );
  }
}
