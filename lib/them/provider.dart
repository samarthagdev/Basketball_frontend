import 'package:basketball_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SignUpProvider with ChangeNotifier {
  String error = '';

  String get errorMethod1 {
    return error;
  }

  void errorMethod(String error1) {
    error = error1;
    notifyListeners();
  }
}

class SignInProvider with ChangeNotifier {
  String error = '';

  String get errorMethod1 {
    return error;
  }

  void errorMethod(String error1) {
    error = error1;
    notifyListeners();
  }
}

class WholeApp with ChangeNotifier {
  String dropdownValue = 'Male';
  void changeValue(String value) {
    dropdownValue = value;
    notifyListeners();
  }

  String get getvalue {
    if (date.isEmpty) {
      var box = Hive.box('details');
      Map<dynamic, dynamic> player = box.get('player', defaultValue: <String, dynamic>{});
      String? gender; 
      if(player.isNotEmpty){
        gender= player['gender'];
      }
      if (gender == null) {
        return 'Male';
      }
      return gender;
    }
    return dropdownValue;
  }

  String date = '';
  String get gettingDate {
    if (date.isEmpty) {
      var box = Hive.box('details');
      Map<dynamic, dynamic> player = box.get('player', defaultValue: <String, dynamic>{});
      String? dob;
      if(player.isNotEmpty){
        dob = player['dob'];
      }
      if (dob == null) {
        return '';
      }
      return dob;
    }
    return date;
  }

  void settingDate(String date1) {
    date = date1;
    notifyListeners();
  }

  String settingerr = '';
  String get gettingsettingerr {
    return settingerr;
  }

  void settingerror(String settingerr1) {
    settingerr = settingerr1;
    notifyListeners();
  }
}

class DrawerProvider with ChangeNotifier {
  double hei = 0.0;
  double get gettinghei {
    return hei;
  }

  void settinghei(double hei1) {
    hei = hei1;
    notifyListeners();
  }
}

class CreateTeamProvider with ChangeNotifier {
  String err = '';
  String get gettingErr {
    return err;
  }

  void settingerr(String e) {
    err = e;
    notifyListeners();
  }

  List<dynamic> selectedPlayer = [];
  List<dynamic> get gettingplayer {
    return selectedPlayer;
  }

  void settingplayer({required String from, Map<String, dynamic>? e1}) {
    if (from == 'add') {
      selectedPlayer.add(e1);
    } else if (from == 'removeall') {
      selectedPlayer.clear();
    } else {
      selectedPlayer.remove(e1);
    }
    notifyListeners();
  }

  String dropdownValue = '5X5';
  String get gettinglevel {
    return dropdownValue;
  }

  void settinglevel(String e) {
    dropdownValue = e;
    notifyListeners();
  }

  String dropdownValue1 = 'select';
  String get gettinglevel1 {
    return dropdownValue1;
  }

  void settingdropdown1(String e) {
    dropdownValue1 = e;
    notifyListeners();
  }

  Map<String, dynamic> myTeam = {};
  Map<String, dynamic> get gettingMyTeam {
    return myTeam;
  }

  void settingMyTeam(Map<String, dynamic> e) {
    myTeam = e;
    notifyListeners();
  }
}

class SearchProvider with ChangeNotifier {
  List<dynamic> data = [];

  List<dynamic> get gettingsearchbody {
    return data;
  }

  void settingSearch(List<dynamic> result) {
    data = result;
    notifyListeners();
  }
}

class NotificationProvider with ChangeNotifier {
  List<dynamic> notificationmess = [];

  List<dynamic> get gettingNotification {
    return notificationmess;
  }

  void settingNotification(List<dynamic> mess) {
    notificationmess = mess;
    notifyListeners();
  }
}

class ProfileProvider with ChangeNotifier {
  Map<String, dynamic> profile = {};

  Map<String, dynamic> get gettingProfile {
    return profile;
  }

  void settingProfile(Map<String, dynamic> value) {
    profile = value;
    notifyListeners();
  }
}

class TeamProfileProvider with ChangeNotifier {
  Map<String, dynamic> teamprofile = {};

  Map<String, dynamic> get gettingTeamProfile {
    return teamprofile;
  }

  void settingTeamProfile(Map<String, dynamic> value) {
    teamprofile = value;
    notifyListeners();
  }
}

class JoinTeamProvider with ChangeNotifier {
  List<dynamic> pending = [];
  List<dynamic> get gettingPending {
    return pending;
  }

  void settingPending(List<dynamic> e) {
    pending = e;
    notifyListeners();
  }
}

class HostTournamentProvider with ChangeNotifier {
  String dropdownValue = '5X5';
  String get gettingdropdown {
    return dropdownValue;
  }

  void settingdropdown(String value) {
    dropdownValue = value;
    notifyListeners();
  }

  String date = '';
  String get gettingDate {
    return date;
  }

  void settingDate(String date1) {
    date = date1;
    notifyListeners();
  }

  String err = '';
  String get gettingerr {
    return err;
  }

  void settingerr(String value) {
    err = value;
    notifyListeners();
  }
}

class JoinTournamentProvider with ChangeNotifier {
  Map<String, dynamic> details = {};

  Map<String, dynamic> get gettingDetails {
    return details;
  }

  void settingDetails(Map<String, dynamic> value) {
    details = value;
    notifyListeners();
  }

  List<dynamic> teams = [];
  List<dynamic> get getTeams {
    return teams;
  }

  void settingTeams(List<dynamic> value) {
    teams = value;
    notifyListeners();
  }

  List<dynamic> tourId = [];
  List<dynamic> get getTourId {
    return tourId;
  }

  void settingTourId(List<dynamic> value) {
    tourId = value;
    notifyListeners();
  }
}

class CurrentTournamentProvider with ChangeNotifier {
  List<dynamic> allmatches = [];
  List<dynamic> get gettingAllMatches {
    return allmatches;
  }

  void settingAllMatch(List<dynamic> value) {
    allmatches = value;
    notifyListeners();
  }
}

class MyTournamentProvider with ChangeNotifier {
  List<dynamic> joinedlis = [];

  List<dynamic> get gettingJoinedLis {
    return joinedlis;
  }

  void settingJoinedLis(List<dynamic> value) {
    joinedlis = value;
    notifyListeners();
  }

  List<dynamic> refTour = [];
  List<dynamic> get gettingRefTour {
    return refTour;
  }

  void settingRefTour(List<dynamic> value) {
    refTour = value;
    notifyListeners();
  }

  List<dynamic> hostTour = [];
  List<dynamic> get gettingHostTour {
    return hostTour;
  }

  void settingHostTour(List<dynamic> value) {
    hostTour = value;
    notifyListeners();
  }

  Map<String, dynamic> pending = {};
  Map<String, dynamic> get gettingPending {
    return pending;
  }

  void settingPending(Map<String, dynamic> value) {
    pending = value;
    notifyListeners();
  }

  Map<String, dynamic> fixture = {};
  Map<String, dynamic> get gettingFixture {
    return fixture;
  }

  void settingFixture(Map<String, dynamic> value) {
    fixture = value;
    notifyListeners();
  }
}

class MatchesProvider with ChangeNotifier {
  Map<String, dynamic> teamlis = {};
  Map<String, dynamic> get gettingMatchTeams {
    return teamlis;
  }

  void settingMatchTeams(Map<String, dynamic> value) {
    teamlis = value;
    notifyListeners();
  }

  List<dynamic> allMatches = [];
  List<dynamic> get gettingAllMatch {
    return allMatches;
  }

  void settingAllMatch(List<dynamic> value) {
    allMatches = value;
    notifyListeners();
  }

  Map<String, dynamic> fullMatchInfo = {};
  Map<String, dynamic> get gettingMatchInfo {
    return fullMatchInfo;
  }

  void settingMatchInfo(Map<String, dynamic> value) {
    fullMatchInfo = value;
    notifyListeners();
  }

  String whichTeam = 'Points';
  String get gettingwhichTeam {
    return whichTeam;
  }

  void settingWhichTeam(String value) {
    whichTeam = value;
    notifyListeners();
  }
}

class IndividualMatchProvider with ChangeNotifier {
  Map<String, dynamic> info = {};
  Map<String, dynamic> get gettingMatchInfo {
    return info;
  }

  void settingMatchInfo(Map<String, dynamic> value) {
    info = value;
    notifyListeners();
  }
}

class RankingProvider with ChangeNotifier {
  Map<String, dynamic> info = {};
  Map<String, dynamic> get gettingRanking {
    return info;
  }

  void settingRanking(Map<String, dynamic> value) {
    info = value;
    notifyListeners();
  }
}

class YoutubeProvider with ChangeNotifier {
  bool info = true;
  bool get gettingYoutube {
    return info;
  }

  void settingYoutube(bool value) {
    info = value;
    notifyListeners();
  }
}

class GameProvider with ChangeNotifier {
  List<dynamic> tour = [];
  List<dynamic> get gettingTourInfo {
    return tour;
  }

  void settingTourInfo(List<dynamic> value) {
    tour = value;
    notifyListeners();
  }
}

class DataProvider {
  static Map<String, dynamic> get gettingdatafromHive {
    var box = Hive.box('details');
    String uniId = box.get('personal')['uniId'];
    String? no = box.get('personal')['number'];
    Map<dynamic, dynamic> player =
        box.get('player', defaultValue: <String, dynamic>{});
    String height = '';
    String weight = '';
    String address = '';
    String? img = '';
    if (player.isNotEmpty) {
       height = player['height'];
       weight = player['weight'];
       address = player['address'];
       img = player['photoUrl'];
    }
    return {
      'id': uniId,
      'num': no,
      'hei': height,
      'wei': weight,
      'city': address,
      'pic': img
    };
  }

  static void eraseValue() {
    Provider.of<SignInProvider>(navigatorKey.currentContext!, listen: false)
        .errorMethod('');
    Provider.of<SignUpProvider>(navigatorKey.currentContext!, listen: false)
        .errorMethod('');
    Provider.of<WholeApp>(navigatorKey.currentContext!, listen: false)
        .settingDate('');
    Provider.of<WholeApp>(navigatorKey.currentContext!, listen: false)
        .settingerror('');
    Provider.of<WholeApp>(navigatorKey.currentContext!, listen: false)
        .changeValue('Male');
    Provider.of<CreateTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settingdropdown1('select');
    Provider.of<CreateTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settinglevel('5X5');
    Provider.of<CreateTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settingerr('');
    Provider.of<CreateTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settingplayer(from: 'removeall');
    Provider.of<CreateTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settingMyTeam({});
    Provider.of<NotificationProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingNotification([]);
    Provider.of<SearchProvider>(navigatorKey.currentContext!, listen: false)
        .settingSearch([]);
    Provider.of<ProfileProvider>(navigatorKey.currentContext!, listen: false)
        .settingProfile({});
    Provider.of<TeamProfileProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingTeamProfile({});
    Provider.of<JoinTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settingPending([]);
    Provider.of<HostTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingdropdown('5X5');
    Provider.of<HostTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingDate('');
    Provider.of<HostTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingerr('');
    Provider.of<JoinTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingDetails({});
    Provider.of<JoinTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingTeams([]);
    Provider.of<JoinTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingTourId([]);
    Provider.of<CurrentTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingAllMatch([]);
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingJoinedLis([]);
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingHostTour([]);
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingPending({});
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingFixture({});
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingRefTour([]);
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingMatchTeams({});
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingAllMatch([]);
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingMatchInfo({});
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingWhichTeam('Points');
    Provider.of<IndividualMatchProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingMatchInfo({});
    Provider.of<RankingProvider>(navigatorKey.currentContext!, listen: false)
        .settingRanking({});
    Provider.of<YoutubeProvider>(navigatorKey.currentContext!, listen: false)
        .settingYoutube(true);
    Provider.of<GameProvider>(navigatorKey.currentContext!, listen: false)
        .settingTourInfo([]);
  }
}
