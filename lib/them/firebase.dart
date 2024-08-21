import 'package:basketball_frontend/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Firetools{
  
  
static Future<String?>gettingtoken()async{
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
}


static Future<void> gettingNotification(title, ) async{
  ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text("$title")));
}


Future topicSubscribe(String topic)async{
  await FirebaseMessaging.instance.subscribeToTopic(topic);
}


Future topicUnSubscribe(String topic)async{
  await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}

}