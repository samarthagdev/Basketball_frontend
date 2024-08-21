import 'package:basketball_frontend/SplashScreen/splash_screen.dart';
import 'package:basketball_frontend/main/Drawer/homepage.dart';
import 'package:basketball_frontend/them/firebase.dart';
import 'package:basketball_frontend/them/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
late FirebaseMessaging messaging;
Future<void> _messageHandler(
  RemoteMessage message,
) async {
await Firebase.initializeApp();
}

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
    )
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top]);
  await Firebase.initializeApp();
  messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(
    _messageHandler,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      RemoteNotification noti = message.notification!;
      Firetools.gettingNotification(noti.title);
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Color _primaryColor = const Color(0xFFfa7e1e);
  const MyApp({Key? key}) : super(key: key);

  // Color _accentColor = HexColor('#8A02AE');
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SignUpProvider()),
        ChangeNotifierProvider.value(value: SignInProvider()),
        ChangeNotifierProvider.value(value: WholeApp()),
        ChangeNotifierProvider.value(value: DrawerProvider()),
        ChangeNotifierProvider.value(value: CreateTeamProvider()),
        ChangeNotifierProvider.value(value: SearchProvider()),
        ChangeNotifierProvider.value(value: NotificationProvider()),
        ChangeNotifierProvider.value(value: ProfileProvider()),
        ChangeNotifierProvider.value(value: TeamProfileProvider()),
        ChangeNotifierProvider.value(value: JoinTeamProvider()),
        ChangeNotifierProvider.value(value: HostTournamentProvider()),
        ChangeNotifierProvider.value(value: JoinTournamentProvider()),
        ChangeNotifierProvider.value(value: CurrentTournamentProvider()),
        ChangeNotifierProvider.value(value: MyTournamentProvider()),
        ChangeNotifierProvider.value(value: MatchesProvider()),
        ChangeNotifierProvider.value(value: IndividualMatchProvider()),
        ChangeNotifierProvider.value(value: RankingProvider()),
        ChangeNotifierProvider.value(value: YoutubeProvider()),
        ChangeNotifierProvider.value(value: GameProvider()),
      ],
      child: MaterialApp(
        title: 'Basketball',
        navigatorKey: navigatorKey,
        routes: {
          '/youtube_back': (context) => const HomePage(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: _primaryColor,
            textTheme: const TextTheme(
              bodyText1: TextStyle(color: Color(0xFF000000)),
            ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(color: Color(0xFF000000)),
                backgroundColor: Colors.white)),
        home: const SplashScreen()
      )
    );
  }
}
