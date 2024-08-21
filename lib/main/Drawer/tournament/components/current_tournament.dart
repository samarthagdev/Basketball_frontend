import 'package:basketball_frontend/main/Drawer/otherPages/ranking.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/current_tournament_1.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentTournamnet extends StatefulWidget {
  final String pageName; 
  const CurrentTournamnet({Key? key, required this.pageName}) : super(key: key);

  @override
  State<CurrentTournamnet> createState() => _CurrentTournamnetState();
}

class _CurrentTournamnetState extends State<CurrentTournamnet> {
  
  String searchtext = '';
  late List<dynamic> searchBody;
  final TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 0,
        centerTitle: true,
        title: Text(widget.pageName,
        textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10,top: 10),
        child: Column(
          children: <Widget>[
            _searcField(),
            _searchBody()
          ],
        ),
      ),
    );   
  }

  Widget _searcField(){
    return TextFormField(
        controller: _search,
        cursorColor: Colors.white,
        onChanged: (value) {
          if (!searchtext.startsWith(value)) {
            searchtext = value;
            Connectivity.sendsock({'type': 'search_tournament', 'data': value, 'data1':false});
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
          labelText: 'Search for tournament Name, Place',
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 42, 41, 44),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      );
  }

  Widget _searchBody(){
    List<dynamic> s = Provider.of<SearchProvider>(context).gettingsearchbody;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
          children: s.map((e) {
            return InkWell(
              onTap: () {
                if(widget.pageName == 'Ranking'){
                  Navigator.push(
                    context,
                    CustomPageRoute(
                        child: Ranking(
                              tourId: e['tour_id'],
                              tourName: e['tour_name'],
                            ), direction: AxisDirection.left));
                } else{
                  Navigator.push(
                    context,
                    CustomPageRoute(
                        child: SpecificTournament(
                              tourId: e['tour_id'],
                              tourName: e['tour_name'],
                              pageName: widget.pageName,
                            ), direction: AxisDirection.left));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(e['tour_name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text(e['tour_owner'],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w300)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}