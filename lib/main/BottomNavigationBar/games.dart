import 'package:basketball_frontend/main/Drawer/tournament/components/current_tournament_1.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class Games extends StatefulWidget {
  const Games({Key? key}) : super(key: key);

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  DateTime currentDate = DateTime.now();
  late String selectedDate;
  late int noOfday;
  late int month;
  late int year;
  List<int> dayNo = [];
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  List<String> monthsName = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> daysName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  List<DateTime> currentMonthList = [];
  late List<dynamic> tour;
  List<dynamic> tour1= [];
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }
  GlobalKey key1 = GlobalKey();
  GlobalKey key3 = GlobalKey(); 
  late BuildContext gameContext;
  @override
  void initState() {
    noOfday = getDaysInMonth(currentDate.year, currentDate.month);
    dayNo = List<int>.generate(noOfday, (i) {
      i = i + 1;
      return i;
    });
    month = currentDate.month;
    year = currentDate.year;
    selectedDate = formatter.format(currentDate);
    Connectivity.sendsock({
                  'type': "Get Tournament of Specific date",
                  'data': selectedDate
                });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeHelper().intro(s: [key1, key3], boxName: "game", context: gameContext);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tour = Provider.of<GameProvider>(context).gettingTourInfo;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          gameContext=context;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const Text('Games',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              actions: [
                Showcase(
                  key: key3,
                  description: "To filter the event of selected date, tap on it",
                  descTextStyle: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600
                    ),
                  child: IconButton(
                      icon: const Icon(Icons.filter_alt_outlined,
                          size: 30, color: Color(0xFF000000)),
                      onPressed: () async{
                        List<String>? filter =  await ThemeHelper().filter();
                        if(filter != null && filter.isNotEmpty){
                          tour1.clear();
                          for (var x in filter){
                            for(var y in tour){
                              if((y['tour_venue'].toLowerCase()).contains(x.toLowerCase())){
                                tour1.add(y);
                            }
                            }
                          }
                          if(tour1.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No venue found for applied filter')));
                          }
                        } else{
                          tour1.clear();
                        }
                        setState(() {
                            
                          });              
                        }),
                ),
              ],
            ),
            body: Column(
                children: <Widget>[
                  _month(),
                  Showcase(
                    key: key1,
                    description: "Select date to find the tournaments hosted on particuler day",
                    descTextStyle: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600
                    ),
                    child: _date()),
                  _tour(),
                ],
              ),
          );
        }
      ),
    );
  }

  Widget _month() {
    return Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.grey[350],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 7, right: 5, bottom: 7),
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.grey[400]),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: monthsName[month - 1],
                  elevation: 5,
                  menuMaxHeight: MediaQuery.of(context).size.height * .6,
                  alignment: Alignment.center,
                  onChanged: (String? value) {
                    setState(() {
                      month = monthsName.indexOf(value!) + 1;
                      dayNo.clear();
                      dayNo =
                          List<int>.generate(getDaysInMonth(year, month), (i) {
                        i = i + 1;
                        return i;
                      });
                      selectedDate = "";
                      tour1.clear();
                    });
                    Provider.of<GameProvider>(context, listen: false).settingTourInfo([]);
                  },
                  items:
                      monthsName.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 7, right: 5, bottom: 7),
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.grey[400]),
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: year,
                  elevation: 5,
                  menuMaxHeight: MediaQuery.of(context).size.height * .6,
                  alignment: Alignment.center,
                  onChanged: (int? value) {
                    setState(() {
                      year = value!;
                      selectedDate = "";
                      tour1.clear();
                    });
                    Provider.of<GameProvider>(context, listen: false).settingTourInfo([]);
                  },
                  items: <DropdownMenuItem<int>>[
                    DropdownMenuItem<int>(
                      value: year - 1,
                      child: Text((year - 1).toString(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ),
                    DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ),
                    DropdownMenuItem<int>(
                      value: year + 1,
                      child: Text((year + 1).toString(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _date() {
    return Container(
      // padding: const EdgeInsets.only(left: 10, right: 10),
      height: 60,
      color: Colors.grey[350],
      child: StatefulBuilder(builder: (context, innerState) {
        return ListView.builder(
          itemCount: dayNo.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            int e = dayNo[index];
            late bool isSelected;
            String stringDate;
            if (e.toString().length == 1) {
              stringDate = "0$e-$month-$year";
              isSelected = selectedDate == stringDate ? true : false;
            } else {
              stringDate = "$e-$month-$year";
              isSelected = selectedDate == stringDate ? true : false;
            }
            return InkWell(
              onTap: () {
                innerState(() {
                  selectedDate = stringDate;
                  tour1.clear();
                });
                Connectivity.sendsock({
                  'type': "Get Tournament of Specific date",
                  'data': stringDate
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 30,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: isSelected
                            ? const BorderSide(
                                style: BorderStyle.solid,
                                width: 3,
                                color: Colors.amber)
                            : BorderSide.none)),
                child: Column(
                  children: [
                    Text(daysName[(DateTime(year, month, e).weekday) - 1]),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      e.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _tour() {
    return Expanded(
      child: Container(
        child: tour.isEmpty
            ? const Center(
                child: Text(
                  "No Scheduled Events",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              )
            : ListView.builder(
              itemCount: tour1.isNotEmpty?tour1.length:tour.length,
              itemBuilder: (context, index) {
                  Map<String, dynamic> e= tour1.isNotEmpty?tour1[index]:tour[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              child: SpecificTournament(
                                tourId: e['tour_id'],
                                tourName: e['tour_name'],
                                pageName: "Previous Page",
                              ),
                              direction: AxisDirection.left));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      color: Colors.grey[350],
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(e['tour_name'], style: const TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.w600
                      ),),
                    ),
                  );
                }
              ),
      ),
    );
  }

}
