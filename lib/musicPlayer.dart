import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plant_app/database.dart';
import 'package:plant_app/homePage.dart'; 
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';

class MusicPlayer extends StatefulWidget {
  final Song song;
  MusicPlayer(this.song);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

double currentSlider = 0;

class _MusicPlayerState extends State<MusicPlayer>
  with SingleTickerProviderStateMixin {
  late AnimationController
      iconController;
  bool isAnimated = false;
  bool showPlay = true;
  bool shopPause = false;
  
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iconController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    audioPlayer.open(Audio(widget.song.file),autoStart: false,showNotification: true);
    
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: "image",
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.song.image), fit: BoxFit.cover)),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Hello, Selamat datang",
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  Text("", style: TextStyle(fontSize: 10))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 8, left: 15),
                child: Icon(Icons.notifications_active_outlined, size: 30),
              )
            ],
          ),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: ExpandableBottomSheet(
              background: Container(
                margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    blurRadius: 14,
                    spreadRadius: 16,
                    color: Colors.black.withOpacity(0.2),
                  )
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 1.5, color: Colors.white.withOpacity(0.2))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child:
                                  Text(
                                    widget.song.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              widget.song.singer,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            InkWell(child: Icon(CupertinoIcons.backward_fill, color: Colors.white),onTap: (){
                              audioPlayer.seekBy(Duration(seconds: -10));
                            },),
                              GestureDetector(
                                onTap: () {
                                  AnimateIcon();
                                },
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: iconController,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(child: Icon(CupertinoIcons.forward_fill, color: Colors.white),onTap: (){
                                audioPlayer.seekBy(Duration(seconds: 10));
                                audioPlayer.seek(Duration(seconds: 10));
                                audioPlayer.next();
                              },),
                            ],
                          ),
                          audioPlayer.builderCurrent(
                            builder: (context, Playing? playing) {
                          return Column(
                            children: <Widget>[
                              audioPlayer.builderRealtimePlayingInfos(
                                  builder: (context, RealtimePlayingInfos? infos) {
                                if (infos == null) {
                                  return SizedBox();
                                }
                                print('infos: $infos');
                                return Column(
                                  children: [
                                    // PositionSeekWidget(
                                    //   currentPosition: infos.currentPosition,
                                    //   duration: infos.duration,
                                    //   seekTo: (to) {
                                    //     _assetsAudioPlayer.seek(to);
                                    //   },
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     NeumorphicButton(
                                    //       onPressed: () {
                                    //         _assetsAudioPlayer
                                    //             .seekBy(Duration(seconds: -10));
                                    //       },
                                    //       child: Text('-10'),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 12,
                                    //     ),
                                    //     NeumorphicButton(
                                    //       onPressed: () {
                                    //         _assetsAudioPlayer
                                    //             .seekBy(Duration(seconds: 10));
                                    //       },
                                    //       child: Text('+10'),
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                );
                              }),
                            ],
                          );
                        }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              persistentHeader: Container(
                height: 40,
                child: Center(
                  child: Text('Lyrics'),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  ),
                  color: Colors.grey[500],
                ),
              ),
              expandableContent: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                color: Colors.white,
                child: Center(
                  // child: Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(top: 20)),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10),
                            //   child: Text(
                            //     'Arti :',
                            //     textAlign: TextAlign.left,
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.bold
                            //       ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10),
                            //   child: Text(
                            //     'Isi',
                            //     textAlign: TextAlign.justify,
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 16,
                            //       ),
                            //   ),
                            // ),
                            // Padding(padding: const EdgeInsets.only(top: 10)),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10),
                            //   child: Text(
                            //     'Terjemahan :',
                            //     textAlign: TextAlign.right,
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.bold
                            //       ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,0),
                              // padding: const EdgeInsets.fromLTRB(10,0,10,30),
                              child: Text(
                                widget.song.lyric,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // ),
                ),
              ),
            ),
            
          ),
        ),
      ],
    );
  }

  void AnimateIcon() {
    setState(() {
      isAnimated = !isAnimated;
     if(isAnimated)
       {
         iconController.forward();
         audioPlayer.play();
       }else{
       iconController.reverse();
       audioPlayer.pause();
     }
    });
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    iconController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}
