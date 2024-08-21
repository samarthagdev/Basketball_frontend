import 'package:basketball_frontend/Main/Drawer/otherPages/contact.dart';
import 'package:basketball_frontend/Main/Drawer/otherPages/settings.dart';
import 'package:basketball_frontend/Main/Drawer/team/team.dart';
import 'package:basketball_frontend/Main/Drawer/tournament/tournament.dart';
import 'package:basketball_frontend/login/login.dart';
import 'package:basketball_frontend/main/Drawer/otherPages/youtube.dart';
import 'package:basketball_frontend/main/Drawer/tournament/components/current_tournament.dart';
import 'package:basketball_frontend/socket/sock.dart';
import 'package:basketball_frontend/them/custom_page_route.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:basketball_frontend/them/them_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  
  const SideDrawer({ Key? key,}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  
  bool isSideBarOpen = false;
  IconData ic = CupertinoIcons.forward;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    double height = Provider.of<DrawerProvider>(context).gettinghei;
    return InkWell(
      onTap: () => Provider.of<DrawerProvider>(context, listen: false).settinghei(0.0),
      child: Material(
          elevation: 5.0,
          borderRadius: const BorderRadius.only(topLeft:Radius.circular(30), topRight: Radius.circular(30)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds:450),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFf0f8ff),
              borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight: Radius.circular(30)),
            ),
            height: size *height,
              child: ListView(
                    controller: ScrollController(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: <Widget>[
                      const Icon(CupertinoIcons.ellipsis, size: 25),
                      const SizedBox(height: 16,),
                      _drawerItemDesgin(itemname: 'Tournament', icon: Icons.people,
                       onclicked: () => drawerItemSelected(context, 0)
                       ),
                      _drawerItemDesgin(itemname: 'Ranking', icon: Icons.bar_chart_sharp, 
                      onclicked: () => drawerItemSelected(context, 1)
                      ),
                      
                      _drawerItemDesgin(itemname: 'Team', icon: Icons.flag, 
                      onclicked: () => drawerItemSelected(context, 2)
                      ),
                      
                      _drawerItemDesgin(itemname: 'Contact Us', icon: Icons.contact_page, 
                      onclicked: () => drawerItemSelected(context, 3)
                      ),

                      _drawerItemDesgin(itemname: 'YouTuber', icon: Icons.video_collection, 
                      onclicked: () => drawerItemSelected(context, 4)
                      ),
                      
                      const Divider(thickness: 3, color: Colors.white24,),
                      _drawerItemDesgin(itemname: 'Player Account', icon: Icons.person_add,
                      onclicked: () => drawerItemSelected(context, 11)
                      ),
                      
                      _drawerItemDesgin(itemname: 'Log out', icon: Icons.logout_rounded,
                      onclicked: () => drawerItemSelected(context, 12)
                      ),
                      const SizedBox(height: 16,),

                    ],
                  ),
            ),
        ),
    );
        }

Widget _drawerItemDesgin({required String itemname, required IconData icon, VoidCallback? onclicked,}){
  const color = Colors.black;
  
  return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(itemname, style: GoogleFonts.openSans(
        fontSize: 20,
      ),),
      onTap: onclicked,
    );
}

void drawerItemSelected(BuildContext context, int index){
  switch (index) {

    case 0:
          Navigator.push(context, CustomPageRoute(child:const Tournament(), direction: AxisDirection.left));
          break;
    case 1:
          Provider.of<SearchProvider>(context, listen: false).settingSearch([]);
          Navigator.push(context, CustomPageRoute(child: const CurrentTournamnet(pageName: 'Ranking',), direction: AxisDirection.left));
          break;
    case 2:
          Navigator.push(context, CustomPageRoute(child: const Team(), direction: AxisDirection.left));
          break;
    case 3:
          Navigator.push(context, CustomPageRoute(child: const Contact(), direction: AxisDirection.left));
          break;
    case 4:
          Navigator.push(context, CustomPageRoute(child: const YouTuber(), direction: AxisDirection.left));
          break;
    case 11:
          Navigator.push(context, CustomPageRoute(child: const Settings(), direction: AxisDirection.left));
          break;
    case 12:
          var details = Hive.box('details');
          if(details.get('personal')['method'] != 'custom') ThemeHelper.signout(context, details.get('personal')['method']);
          details.put('personal', <String, dynamic>{});
          details.put('player', <String, dynamic>{});          
          Connectivity.sendsock({'data':'close','type':'close'});
          DataProvider.eraseValue();
          Navigator.pushAndRemoveUntil(context, CustomPageRoute(child: const LoginPage(), direction: AxisDirection.left),(Route<dynamic> route) => false);
  }
}

}