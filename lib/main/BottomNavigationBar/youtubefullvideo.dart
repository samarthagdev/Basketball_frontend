import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FuLLVideo extends StatefulWidget {
  const FuLLVideo({Key? key, required this.id, required this.live})
      : super(key: key);
  final String id;
  final bool live;
  @override
  State<FuLLVideo> createState() => _FuLLVideoState();
}

class _FuLLVideoState extends State<FuLLVideo> {
  late YoutubePlayerController _controller;
  late YoutubeMetaData _videoMetaData;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: widget.live,
        forceHD: true,
        enableCaption: true,
      ),
    );
    _videoMetaData = const YoutubeMetaData();
    _videoMetaData = _controller.metadata;
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerBuilder(
        onEnterFullScreen: () {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.landscapeLeft]);
        },
        onExitFullScreen: () {
          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
          // const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
          // SystemUiOverlayStyle.dark;
          // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          //     systemNavigationBarColor: Colors.blue,
          //     statusBarColor: Colors.pink,
          //   ));
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top]);
          // Navigator.pop(context);
        },
        player: YoutubePlayer(
          bottomActions: [
            CurrentPosition(),
            const SizedBox(width: 10.0),
            ProgressBar(isExpanded: true),
            const SizedBox(width: 10.0),
            RemainingDuration(),
            _fullScreenButton1(),
          ],
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.pinkAccent,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
        builder: (context, player) {
          Orientation currentOrientation = MediaQuery.of(context).orientation;
          //  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          //     systemNavigationBarColor: Colors.blue,
          //     statusBarColor: Colors.pink,
          //   ));
          if (currentOrientation != Orientation.landscape) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFFfa7e1e),
                title: Text(
                  _videoMetaData.title,
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(fit: BoxFit.scaleDown, child: player),
              ),
            );
          }
          return Scaffold(
            body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(fit: BoxFit.scaleDown, child: player)),
          );
        },
      ),
    );
  }

  Widget _fullScreenButton1() {
    return IconButton(
        onPressed: () {
          Orientation currentOrientation = MediaQuery.of(context).orientation;
          if (currentOrientation != Orientation.landscape) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeLeft
            ]);
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
          }
        },
        icon: const Icon(
          Icons.fullscreen,
          color: Colors.white,
        ));
  }
}
