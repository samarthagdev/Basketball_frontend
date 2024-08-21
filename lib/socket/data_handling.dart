import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class DataHandling {
  void searchData(data, type) {
    Provider.of<SearchProvider>(navigatorKey.currentContext!, listen: false)
        .settingSearch(data);
  }

  void notificationData(data) {
    Provider.of<NotificationProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingNotification(data);
  }

  void profileData(data) {
    Provider.of<ProfileProvider>(navigatorKey.currentContext!, listen: false)
        .settingProfile(data);
  }

  void teamProfileData(data) {
    Provider.of<TeamProfileProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingTeamProfile(data);
  }

  void myTeam(data) {
    Provider.of<CreateTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settingMyTeam(data);
  }

  void pendingRequest(data) {
    Provider.of<JoinTeamProvider>(navigatorKey.currentContext!, listen: false)
        .settingPending(data);
  }

  void tourDetails(data) {
    Provider.of<JoinTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingDetails(data);
  }

  void setTeam(data) {
    Provider.of<JoinTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingTeams(data);
  }

  void setTourid(data) {
    Provider.of<JoinTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingTourId(data);
  }

  void setJoinedtour(data) {
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingJoinedLis(data);
  }

  void setHosttour(data) {
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingHostTour(data);
  }

  void setPendingtour(data) {
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingPending(data);
  }

  void setfixture(data) {
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingFixture(data);
  }

  void setReftour(data) {
    Provider.of<MyTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingRefTour(data);
  }

  void setTeamsMatches(data) {
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingMatchTeams(data);
  }

  void setAllMatches(data) {
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingAllMatch(data);
  }

  void setMatchesInfo(data) {
    var box = Hive.box('details');
    box.put("ref_match_info", data);
    box.delete("viewer_match_info");
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingMatchInfo(data);
  }

  void setCurrentMatch(data) {
    Provider.of<CurrentTournamentProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingAllMatch(data);
  }

  void setCurrentMatchInfo(data) {
    var box = Hive.box('details');
    box.put("viewer_match_info", data);
    Provider.of<IndividualMatchProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingMatchInfo(data);
  }

  void updateMatchInfoRef(data) {
    var box = Hive.box('details');
    Map<String, dynamic> match =
        box.get("ref_match_info", defaultValue: <String, dynamic>{});
    match['team_a_player_playing'] = data['team_a_player_stats'];
    match['team_b_player_playing'] = data['team_b_player_stats'];
    match['status'] = data['status'];
    match['quarter'] = data['quarter'];
    Provider.of<MatchesProvider>(navigatorKey.currentContext!, listen: false)
        .settingMatchInfo(match);
    box.put("ref_match_info", match);
  }

  void updateMatchInfoViewer(data) {
    var box = Hive.box('details');
    Map<String, dynamic> match =
        box.get("viewer_match_info", defaultValue: <String, dynamic>{})
            as Map<String, dynamic>;
    match['team_a_player_stats'] = data['team_a_player_stats'];
    match['team_b_player_stats'] = data['team_b_player_stats'];
    match['status'] = data['status'];
    match['quarter'] = data['quarter'];
    Provider.of<IndividualMatchProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingMatchInfo(match);
    box.put("viewer_match_info", match);
  }

  void updateMatchInfoViewer1(data) {
    var box = Hive.box('details');
    Map<String, dynamic> match =
        box.get("viewer_match_info", defaultValue: <String, dynamic>{})
            as Map<String, dynamic>;
    match['team_a_player_stats'] = data['team_a_player_stats'];
    match['team_a_1'] = data['team_a_1'];
    match['team_a_2'] = data['team_a_2'];
    match['team_a_3'] = data['team_a_3'];
    match['team_b_player_stats'] = data['team_b_player_stats'];
    match['team_b_1'] = data['team_b_1'];
    match['team_b_2'] = data['team_b_2'];
    match['team_b_3'] = data['team_b_3'];
    Provider.of<IndividualMatchProvider>(navigatorKey.currentContext!,
            listen: false)
        .settingMatchInfo(match);
    box.put("viewer_match_info", match);
    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Score Updated")));
    Map<String, dynamic> match1 =
        box.get("ref_match_info", defaultValue: <String, dynamic>{});
    match1['team_a_player_playing'] = data['team_a_player_stats'];
    match1['team_b_player_playing'] = data['team_b_player_stats'];
    box.put("ref_match_info", match1);
  }

  void setRanking(data) {
    Provider.of<RankingProvider>(navigatorKey.currentContext!, listen: false)
        .settingRanking(data);
  }

  void isYoutuber(data) {
    Provider.of<YoutubeProvider>(navigatorKey.currentContext!, listen: false)
        .settingYoutube(data);
  }

  void youtube(data) {
    var box = Hive.box('details');
    box.put('live videos', data['Live Streaming']);
    box.put('other videos', data['Other Video']);
    box.put('live Match', data['Live Match']);
    box.put('other video next page number', data['other_video_next_page']);
    box.put('live match next page number', data['live_match_next_page']);
  }

  void youtube1(Map<String, dynamic> data) {
    var box = Hive.box('details');
    box.put('live videos', data['Live Streaming']);

    if (data.containsKey('Live Match')) {
      List<dynamic> liveMatch =
          box.get('live Match', defaultValue: <dynamic>[]);
      liveMatch.addAll(data['Live Match']);
      box.put('live Match', liveMatch);
      box.put('live match next page number', data['live_match_next_page']);
    } 
    
    else if (data.containsKey('Other Video')) {
      List<dynamic> otherVideo =
          box.get('other videos', defaultValue: <dynamic>[]);
      box.put('other video next page number', data['other_video_next_page']);
      otherVideo.addAll(data['Other Video']);
      box.put('other videos', otherVideo);
    }
  }

  void youtubeUrlAdded(data) {
    if ('Done' == data) {
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text("Video Added")));
    } else {
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text("Error in adding video")));
    }
  }

  void gameInfo(data){
    Provider.of<GameProvider>(navigatorKey.currentContext!, listen: false)
        .settingTourInfo(data);
  }
}
