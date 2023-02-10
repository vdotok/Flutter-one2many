import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/Screeens/home/streams/remoteStream.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_one2many/src/grouplist/GroupListScreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

class CallStartOnetoMany extends StatefulWidget {
  final MainProvider mainProvider;
  final localRenderer;
  final registerRes;
  final stopCall;
  final remoteRenderer;
  const CallStartOnetoMany(
      {Key key,
      this.mainProvider,
      this.localRenderer,
      this.registerRes,
      this.stopCall,
      this.remoteRenderer})
      : super(key: key);

  @override
  _CallStartOnetoManyState createState() => _CallStartOnetoManyState();
}

class _CallStartOnetoManyState extends State<CallStartOnetoMany> {
  DateTime _time;
  Timer _ticker;
  String _pressDuration = "00:00";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("this is group name in call start screnn ${callTo}");
    print("this is time in Call Accept Screen $time");
    if (time == null) {
      _time = DateTime.now();
    } else {
      _time = time;
    }

    _updateTimer();
    _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (twoDigitHours == "00")
      return "$twoDigitMinutes:$twoDigitSeconds";
    else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  void _updateTimer() {
    //_time = DateTime.now();
    final duration = DateTime.now().difference(_time);
    final newDuration = _formatDuration(duration);
    //if (mounted) {

    setState(() {
      _pressDuration = newDuration;

      print("IN SET STATE SINGNALING CLIENT>PRESS DURATION $_time");

      //  sharedPref.save("Duration", _pressDuration);
    });
    //}
    //  setState(() {

    //   });
  }

  @override
  dispose() {
    _ticker.cancel();

    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (strArr.last == "GroupList") {
      print("here in onpress back arrow grouplist");
      widget.mainProvider.homeScreen();

      widget.mainProvider.activeCall();
      strArr.remove("GroupList");
    } else if (strArr.last == "CreateGroupChat") {
      print("here in onpress back arrow");
      widget.mainProvider.createGroupChatScreen();

      widget.mainProvider.activeCall();
      strArr.remove("CreateGroupChat");
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    print(
        "this is index in a onremotestream1 ${rendererListWithRefID.length} $isDialer");

    return ispublicbroadcast
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: Container(
                child: Stack(children: <Widget>[
              participantcount >= 1
                  ? broadcasttype == "camera" ||
                          broadcasttype == "appaudioandcamera" ||
                          broadcasttype == "micaudioandcamera"
                      ? RemoteStream(
                          remoteRenderer: rendererListWithRefID[0]
                              ["rtcVideoRenderer"],
                          // remoteRenderer: rendererListWithRefID[0]
                          //     ["rtcVideoRenderer"],
                        )
                      : Container()
                  : Container(),
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      10,
                      50.85,
                      0,
                      0,
                    ),
                  ),
                  Row(
                    children: [
                      participantcount < 1
                          ? SizedBox()
                          : Text(
                              "Public Broadcast",
                              style: TextStyle(
                                  fontSize: 26,
                                  decoration: TextDecoration.none,
                                  fontFamily: secondaryFontFamily,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.normal,
                                  color: darkBlackColor),
                            ),
                      participantcount < 1 ? SizedBox() : Spacer(),
                      participantcount < 1
                          ? SizedBox()
                          : TextButton(
                              onPressed: () {
                                print(
                                    "this is url for public broadcast $publicbroadcasturl");
                                Clipboard.setData(new ClipboardData(
                                    text: publicbroadcasturl));
                              },
                              child: Text('Copy URL',
                                  style: TextStyle(color: textTypeColor)),
                            ),
                    ],
                  ),
                  participantcount < 1
                      ? SizedBox()
                      : Container(
                          child: Align(
                              alignment: Alignment.topRight,
                              // color: Colors.red,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text(
                                        _pressDuration,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontSize: 14,
                                            fontFamily: secondaryFontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: darkBlackColor),
                                      ),
                                    ),
                                    (broadcasttype == "camera" ||
                                            broadcasttype ==
                                                "appaudioandcamera" ||
                                            broadcasttype ==
                                                "micaudioandcamera")
                                        ? Container(
                                            // padding: EdgeInsets.zero,
                                            // height: 500,
                                            // width: 500,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 15, 20, 0),

                                            child: GestureDetector(
                                              child: SvgPicture.asset(
                                                  'assets/switch_camera.svg'),
                                              onTap: () {
                                                signalingClient.switchCamera();
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        //crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            child:
                                                //SvgPicture.asset("assets/person.svg")
                                                Icon(
                                              Icons.person,
                                              color: participantcolor,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "+",
                                                  style: TextStyle(
                                                      color: participantcolor),
                                                ),
                                                Text(
                                                  "$participantcount",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontFamily:
                                                          secondaryFontFamily,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: participantcolor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Row(
                                    //   //mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //     Container(
                                    //       child: Icon(
                                    //         Icons.person_add_alt_1_outlined,
                                    //         color: participantcolor,
                                    //       ),
                                    //     ),
                                    //     Container(
                                    //       padding:
                                    //           const EdgeInsets.only(right: 20),
                                    //       child: Text(
                                    //         "$participantcount",
                                    //         style: TextStyle(
                                    //             fontSize: 14,
                                    //             decoration: TextDecoration.none,
                                    //             fontFamily: secondaryFontFamily,
                                    //             fontWeight: FontWeight.w400,
                                    //             fontStyle: FontStyle.normal,
                                    //             color: participantcolor),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ]))),
                ],
              ),
              // enableCamera
              //     ? RTCVideoView(widget.localRenderer,
              //         key: forsmallView,
              //         mirror: false,
              //         objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
              //
              //    : Container(),
              participantcount >= 1
                  ? broadcasttype == "camera" ||
                          broadcasttype == "appaudioandcamera" ||
                          broadcasttype == "micaudioandcamera"
                      ? SizedBox()
                      : Center(
                          child: Text(
                            '''You are sharing your 
screen at the moment..''',
                            style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                fontFamily: searchFontFamily,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: screensharetextcolor),
                          ),
                        )
                  : Center(
                      // padding: EdgeInsets.only(top: 55, left: 20),
                      //height: 79,
                      //width: MediaQuery.of(context).size.width,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // padding: EdgeInsets.only(top: 150, left: 50),
                            child: Text(
                              "Initiating Public Broadcast",
                              style: TextStyle(
                                  fontSize: 22,
                                  decoration: TextDecoration.none,
                                  fontFamily: secondaryFontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: darkBlackColor),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                              //padding: EdgeInsets.only(left: 65),
                              child: Image.asset(
                            'assets/broadcast.png',
                          )),
                          SizedBox(height: 40),
                          Container(
                            //  margin: EdgeInsets.only(left: 85),
                            width: 115,
                            height: 35,
                            decoration: BoxDecoration(
                                color: participantcolor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton(
                              onPressed: () {
                                print(
                                    "this is url for public broadcast $publicbroadcasturl");
                                Clipboard.setData(new ClipboardData(
                                    text: publicbroadcasturl));
                              },
                              child: Text('Copy URL',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 56,
                ),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // meidaType == MediaType.video
                    //     ?

                    isMultiSession
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  child: !enableCamera2
                                      ? SvgPicture.asset(
                                          'assets/screenshareon.svg')
                                      : SvgPicture.asset(
                                          'assets/screenshareoff.svg'),
                                  onTap: Platform.isIOS
                                      ? null
                                      : participantcount >= 1
                                          ? () {
                                              setState(() {
                                                enableCamera2 = !enableCamera2;
                                              });

                                              signalingClient.audioVideoState(
                                                  audioFlag: switchMute ? 1 : 0,
                                                  videoFlag:
                                                      enableCamera2 ? 1 : 0,
                                                  mcToken: widget
                                                      .registerRes["mcToken"]);
                                              signalingClient
                                                  .enableScreen(enableCamera2);
                                            }
                                          : null),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  child: !enableCamera
                                      ? SvgPicture.asset('assets/video_off.svg')
                                      : SvgPicture.asset('assets/video.svg'),
                                  onTap: participantcount >= 1
                                      ? () {
                                          setState(() {
                                            enableCamera = !enableCamera;
                                          });
                                          signalingClient.audioVideoState(
                                              audioFlag: switchMute ? 1 : 0,
                                              videoFlag: enableCamera ? 1 : 0,
                                              mcToken: widget
                                                  .registerRes["mcToken"]);
                                          signalingClient
                                              .enableCamera(enableCamera);
                                        }
                                      : null)
                            ],
                          )
                        : GestureDetector(
                            child: !enableCamera
                                ? broadcasttype == "camera"
                                    ? SvgPicture.asset('assets/video_off.svg')
                                    : SvgPicture.asset(
                                        'assets/screenshareon.svg')
                                : broadcasttype == "camera"
                                    ? SvgPicture.asset('assets/video.svg')
                                    : SvgPicture.asset(
                                        'assets/screenshareoff.svg'),
                            onTap: Platform.isIOS && broadcasttype != "camera"
                                ? null
                                : participantcount >= 1
                                    ? () {
                                        setState(() {
                                          enableCamera = !enableCamera;
                                        });
                                        signalingClient.audioVideoState(
                                            audioFlag: switchMute ? 1 : 0,
                                            videoFlag: enableCamera ? 1 : 0,
                                            mcToken:
                                                widget.registerRes["mcToken"]);
                                        signalingClient
                                            .enableCamera(enableCamera);
                                      }
                                    : null),
                    SizedBox(
                      width: 10,
                    ),

                    // : SizedBox(),

                    GestureDetector(
                      child: SvgPicture.asset(
                        'assets/end.svg',
                      ),
                      onTap: () {
                        remoteVideoFlag = true;
                        widget.stopCall();
                        setState(() {
                          isAppAudiobuttonSelected = false;
                          iscamerabuttonSelected = false;
                          ismicAudiobuttonSelected = false;
                          participantcount = 0;
                        });
                        // inCall = false;

                        // setState(() {
                        //   _isCalling = false;
                        // });
                      },
                    ),

                    // SvgPicture.asset('assets/images/end.svg'),

                    SizedBox(width: 10),
                    isMultiSession
                        ? broadcasttype == "appaudioandcamera"
                            ? Row(
                                children: [
                                  GestureDetector(
                                      child: !switchMute2
                                          ? SvgPicture.asset(
                                              'assets/appaudioon.svg')
                                          : SvgPicture.asset(
                                              'assets/appaudiooff.svg'),
                                      onTap: Platform.isIOS
                                          ? null
                                          : participantcount >= 1
                                              ? () {
                                                  final bool enabled =
                                                      signalingClient
                                                          .muteInternalMic();
                                                  print(
                                                      "this is enabled3236 $enabled");
                                                  setState(() {
                                                    switchMute2 = enabled;
                                                  });
                                                }
                                              : null),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      child: !switchMute
                                          ? SvgPicture.asset(
                                              'assets/mute_microphone.svg')
                                          : SvgPicture.asset(
                                              'assets/microphone.svg'),
                                      onTap: participantcount >= 1
                                          ? () {
                                              final bool enabled =
                                                  signalingClient.muteMic();
                                              print(
                                                  "this is enabled7465 $enabled");
                                              setState(() {
                                                switchMute = enabled;
                                              });
                                            }
                                          : null)
                                ],
                              )
                            : GestureDetector(
                                child: !switchMute
                                    ? SvgPicture.asset(
                                        'assets/mute_microphone.svg')
                                    : SvgPicture.asset('assets/microphone.svg'),
                                onTap: participantcount >= 1
                                    ? () {
                                        final bool enabled =
                                            signalingClient.muteMic();
                                        print("this is enabled-000 $enabled");
                                        setState(() {
                                          switchMute = enabled;
                                        });
                                      }
                                    : null)
                        : GestureDetector(
                            child: !switchMute
                                ? broadcasttype == "camera" ||
                                        broadcasttype == "micaudio"
                                    ? SvgPicture.asset(
                                        'assets/mute_microphone.svg')
                                    : SvgPicture.asset('assets/appaudioon.svg')
                                : broadcasttype == "camera" ||
                                        broadcasttype == "micaudio"
                                    ? SvgPicture.asset('assets/microphone.svg')
                                    : SvgPicture.asset(
                                        'assets/appaudiooff.svg'),
                            onTap: Platform.isIOS && broadcasttype != "camera"
                                ? null
                                : participantcount >= 1
                                    ? () {
                                        final bool enabled =
                                            signalingClient.muteMic();
                                        print("this is enabled $enabled");
                                        setState(() {
                                          switchMute = enabled;
                                        });
                                      }
                                    : null),
                  ],
                ),
              )
            ])))
        //groupbroadcast starts from here 
        
        : groupBroadcast == true

            ? isDialer == false
            //receiver side
                ? 
               
                rendererListWithRefID.length == 0?Container():
                rendererListWithRefID.length == 1
                    ? WillPopScope(
                        onWillPop: _onWillPop,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(chatRoomColor),
                          ),
                        ))
                    : WillPopScope(
                        onWillPop: _onWillPop,
                        child: Container(
                          child: Stack(children: <Widget>[
                            // ignore: unrelated_type_equality_checks
                            meidaType == "video"
                                ? remoteVideoFlag
                                    ? rendererListWithRefID.length == 2
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    10) // green as background color
                                                ),
                                            // borderRadius: BorderRadius.circular(10.0),
                                            child:RTCVideoView(
                                                    rendererListWithRefID[1]
                                                        ["rtcVideoRenderer"],
                                                    // key: forsmallView,
                                                    mirror: false,
                                                    objectFit: RTCVideoViewObjectFit
                                                        .RTCVideoViewObjectFitCover),
                                          )

                                        // RemoteStream(
                                        //     remoteRenderer:
                                        //         rendererListWithRefID[1]
                                        //             ["rtcVideoRenderer"],
                                        //   )
                                        : rendererListWithRefID.length == 4
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10) // green as background color
                                                    ),
                                                // borderRadius: BorderRadius.circular(10.0),
                                                child: RTCVideoView(
                                                    rendererListWithRefID[2]
                                                        ["rtcVideoRenderer"],
                                                    // key: forsmallView,
                                                    mirror: true,
                                                    objectFit: RTCVideoViewObjectFit
                                                        .RTCVideoViewObjectFitCover),
                                              )

                                            // RemoteStream(
                                            //     remoteRenderer:
                                            //         rendererListWithRefID[2]
                                            //             ["rtcVideoRenderer"],
                                            //   )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                  colors: [
                                                    backgroundAudioCallDark,
                                                    backgroundAudioCallLight,
                                                    backgroundAudioCallLight,
                                                    backgroundAudioCallLight,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment(0.0, 0.0),
                                                )),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    'assets/userIconCall.svg',
                                                  ),
                                                ),
                                              )
                                    : Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                          colors: [
                                            backgroundAudioCallDark,
                                            backgroundAudioCallLight,
                                            backgroundAudioCallLight,
                                            backgroundAudioCallLight,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment(0.0, 0.0),
                                        )),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/userIconCall.svg',
                                          ),
                                        ),
                                      )
                                :
                                //Text("bye"),
                                Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        backgroundAudioCallDark,
                                        backgroundAudioCallLight,
                                        backgroundAudioCallLight,
                                        backgroundAudioCallLight,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment(0.0, 0.0),
                                    )),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/userIconCall.svg',
                                      ),
                                    ),
                                  ),

                            Container(
                              padding: EdgeInsets.fromLTRB(
                                10,
                                55,
                                0,
                                0,
                              ),
                              //height: 79,
                              //width: MediaQuery.of(context).size.width,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    //      mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // (session_type == "call")
                                      //     ?
                                          Text(
                                              // (meidaType == "video")
                                              //     ? 
                                                  'You are on call with',
                                                  // :
                                                  //  'You are audio calling with',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily:
                                                      secondaryFontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: darkBlackColor),
                                            )
                                        //  : Container(),
                                    ],
                                  ),
                                  // (session_type == "call")
                                  //     ? 
                                      Container(
                                          // padding: EdgeInsets.only(left: 50),
                                          child: Text(
                                            'A Group',
                                            style: TextStyle(
                                                fontSize: 24,
                                                decoration: TextDecoration.none,
                                                fontFamily: primaryFontFamily,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                color: darkBlackColor),
                                          ),
                                        )
                                  //    : Container(),
                                ],
                              ),
                            ),
                            Container(
                                // color: Colors.red,
                                child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 120.33, 20, 27),
                                    child: _pressDuration == null
                                        ? Container()
                                        : Text(
                                            '$_pressDuration',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 14,
                                                fontFamily: secondaryFontFamily,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                color: darkBlackColor),
                                          ),
                                  ),
                                  !kIsWeb
                                      ? Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 0.33, 20, 27),
                                          child: GestureDetector(
                                            child: switchSpeaker
                                                ? SvgPicture.asset(
                                                    'assets/VolumnOn.svg')
                                                : SvgPicture.asset(
                                                    'assets/VolumeOff.svg'),
                                            onTap: () {
                                              print(
                                                  "onetomany receriver speaker $switchSpeaker");
                                              setState(() {
                                                switchSpeaker = !switchSpeaker;
                                              });
                                              signalingClient
                                                  .switchSpeaker(switchSpeaker);
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )),

                            // /////////////// this is local stream

                            rendererListWithRefID.length == 4
                                ? Positioned(
                                    left: 225.0,
                                    bottom: 145.0,
                                    right: 20,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        height: 170,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  10) // green as background color
                                              ),
                                          child: enableCamera ?
                                          RTCVideoView(
                                                    rendererListWithRefID[3]
                                                        ["rtcVideoRenderer"],
                                                    // key: forsmallView,
                                                    mirror: false,
                                                    objectFit: RTCVideoViewObjectFit
                                                        .RTCVideoViewObjectFitCover)
                                              // ? RemoteStream(
                                              //     remoteRenderer:
                                              //         rendererListWithRefID[3]
                                              //             ["rtcVideoRenderer"])
                                              : Container(color: Colors.pink),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                            Container(
                              padding: EdgeInsets.only(
                                bottom: 56,
                              ),
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: SvgPicture.asset(
                                      'assets/end.svg',
                                    ),
                                    onTap: () {
                                      remoteVideoFlag = true;
                                      widget.stopCall();
                                      isAppAudiobuttonSelected = false;
                                      iscamerabuttonSelected = false;
                                      ismicAudiobuttonSelected = false;
                                      // inCall = false;

                                      // setState(() {
                                      //   _isCalling = false;
                                      // });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ))
               
               
                //dialer side, caller, initiator
                : WillPopScope(
                    onWillPop: _onWillPop,
                    child: Container(
                      child: Stack(children: <Widget>[
                        meidaType == "video"
                            ? enableCamera
                                ? 
                                isMultiSession?
                                RemoteStream(
                                    remoteRenderer: rendererListWithRefID[0]
                                        ["rtcVideoRenderer"],
                                  ):
                                  broadcasttype=="camera"?
                                   RemoteStream(
                                    remoteRenderer: rendererListWithRefID[0]
                                        ["rtcVideoRenderer"],
                                  ):
                                  Container()
                                : Container()
                            : Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    backgroundAudioCallDark,
                                    backgroundAudioCallLight,
                                    backgroundAudioCallLight,
                                    backgroundAudioCallLight,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment(0.0, 0.0),
                                )),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/userIconCall.svg',
                                  ),
                                ),
                              ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            10,
                            55,
                            0,
                            0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (meidaType == "video")
                                        ? 'You are on screen share calling with'
                                        : 'You are audio calling with',
                                    style: TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.none,
                                        fontFamily: secondaryFontFamily,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: darkBlackColor),
                                  ),
                                ],
                              ),
                              Container(
                                //padding: EdgeInsets.only(left: 50),
                                child: Text(
                                  'A Group',
                                  style: TextStyle(
                                      fontSize: 24,
                                      decoration: TextDecoration.none,
                                      fontFamily: primaryFontFamily,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      color: darkBlackColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        !kIsWeb
                            ? meidaType == "video"
                                ? Container(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 120.33, 20, 27),
                                            child: Text(
                                              '$_pressDuration',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      secondaryFontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: darkBlackColor),
                                            ),
                                          ),

                                          (broadcasttype == "camera" ||
                                                  broadcasttype ==
                                                      "appaudioandcamera" ||
                                                  broadcasttype ==
                                                      "micaudioandcamera")
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 0, 20, 27),
                                                  child: GestureDetector(
                                                    child: SvgPicture.asset(
                                                      'assets/switch_camera.svg',
                                                    ),
                                                    onTap: () {
                                                      signalingClient
                                                          .switchCamera();
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 0, 20, 27),
                                                ),

                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 20, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              //crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  child:
                                                      //SvgPicture.asset("assets/person.svg")
                                                      Icon(
                                                    Icons.person,
                                                    color: participantcolor,
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "+",
                                                        style: TextStyle(
                                                            color:
                                                                participantcolor),
                                                      ),
                                                      Text(
                                                        "$participantcount",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontFamily:
                                                                secondaryFontFamily,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color:
                                                                participantcolor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    // color: Colors.red,
                                    child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 120.33, 20, 27),
                                          child: GestureDetector(
                                            child: !switchSpeaker
                                                ? SvgPicture.asset(
                                                    'assets/VolumnOn.svg')
                                                : SvgPicture.asset(
                                                    'assets/VolumeOff.svg'),
                                            onTap: () {
                                              signalingClient
                                                  .switchSpeaker(switchSpeaker);
                                              setState(() {
                                                switchSpeaker = !switchSpeaker;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            : SizedBox(),
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 56,
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // meidaType == MediaType.video
                              //     ?
                              isMultiSession
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            child: !enableCamera2
                                                ? SvgPicture.asset(
                                                    'assets/screenshareon.svg')
                                                : SvgPicture.asset(
                                                    'assets/screenshareoff.svg'),
                                            onTap: Platform.isIOS
                                                ? null
                                                : participantcount >= 1
                                                    ? () {
                                                        setState(() {
                                                          enableCamera2 =
                                                              !enableCamera2;
                                                        });
                                                        signalingClient
                                                            .audioVideoState(
                                                                audioFlag:
                                                                    switchMute
                                                                        ? 1
                                                                        : 0,
                                                                videoFlag:
                                                                    enableCamera2
                                                                        ? 1
                                                                        : 0,
                                                                mcToken: widget
                                                                        .registerRes[
                                                                    "mcToken"]);
                                                        signalingClient
                                                            .enableScreen(
                                                                enableCamera2);
                                                      }
                                                    : null),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            child: !enableCamera
                                                ? SvgPicture.asset(
                                                    'assets/video_off.svg')
                                                : SvgPicture.asset(
                                                    'assets/video.svg'),
                                            onTap: participantcount >= 1
                                                ? () {
                                                    setState(() {
                                                      enableCamera =
                                                          !enableCamera;
                                                    });
                                                    signalingClient
                                                        .audioVideoState(
                                                            audioFlag:
                                                                switchMute
                                                                    ? 1
                                                                    : 0,
                                                            videoFlag:
                                                                enableCamera
                                                                    ? 1
                                                                    : 0,
                                                            mcToken: widget
                                                                    .registerRes[
                                                                "mcToken"]);
                                                    signalingClient
                                                        .enableCamera(
                                                            enableCamera);
                                                  }
                                                : null)
                                      ],
                                    )
                                  : GestureDetector(
                                      child: !enableCamera
                                          ? broadcasttype == "camera"
                                              ? SvgPicture.asset(
                                                  'assets/video_off.svg')
                                              : SvgPicture.asset(
                                                  'assets/screenshareon.svg')
                                          : broadcasttype == "camera"
                                              ? SvgPicture.asset(
                                                  'assets/video.svg')
                                              : SvgPicture.asset(
                                                  'assets/screenshareoff.svg'),
                                      onTap: Platform.isIOS &&
                                              broadcasttype != "camera"
                                          ? null
                                          : participantcount >= 1
                                              ? () {
                                                  setState(() {
                                                    enableCamera =
                                                        !enableCamera;
                                                  });
                                                  signalingClient
                                                      .audioVideoState(
                                                          audioFlag: switchMute
                                                              ? 1
                                                              : 0,
                                                          videoFlag:
                                                              enableCamera
                                                                  ? 1
                                                                  : 0,
                                                          mcToken: widget
                                                                  .registerRes[
                                                              "mcToken"]);
                                                  signalingClient.enableCamera(
                                                      enableCamera);
                                                }
                                              : null),
                              SizedBox(
                                width: 10,
                              ),
                              // : SizedBox(),

                              GestureDetector(
                                child: SvgPicture.asset(
                                  'assets/end.svg',
                                ),
                                onTap: () {
                                  remoteVideoFlag = true;
                                  widget.stopCall();
                                  setState(() {
                                    isAppAudiobuttonSelected = false;
                                    iscamerabuttonSelected = false;
                                    ismicAudiobuttonSelected = false;
                                    participantcount = 0;
                                  });
                                  // inCall = false;

                                  // setState(() {
                                  //   _isCalling = false;
                                  // });
                                },
                              ),

                              // SvgPicture.asset('assets/images/end.svg'),

                              SizedBox(width: 10),
                              isMultiSession
                                  ? broadcasttype == "appaudioandcamera"
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                                child: !switchMute2
                                                    ? SvgPicture.asset(
                                                        'assets/appaudioon.svg')
                                                    : SvgPicture.asset(
                                                        'assets/appaudiooff.svg'),
                                                onTap: Platform.isIOS
                                                    ? null
                                                    : participantcount >= 1
                                                        ? () {
                                                            final bool enabled =
                                                                signalingClient
                                                                    .muteInternalMic();
                                                            print(
                                                                "this is enabled3236 $enabled");
                                                            setState(() {
                                                              switchMute2 =
                                                                  enabled;
                                                            });
                                                          }
                                                        : null),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                                child: !switchMute
                                                    ? SvgPicture.asset(
                                                        'assets/mute_microphone.svg')
                                                    : SvgPicture.asset(
                                                        'assets/microphone.svg'),
                                                onTap: participantcount >= 1
                                                    ? () {
                                                        final bool enabled =
                                                            signalingClient
                                                                .muteMic();
                                                        print(
                                                            "this is enabled7465 $enabled");
                                                        setState(() {
                                                          switchMute = enabled;
                                                        });
                                                      }
                                                    : null)
                                          ],
                                        )
                                      : GestureDetector(
                                          child: !switchMute
                                              ? SvgPicture.asset(
                                                  'assets/mute_microphone.svg')
                                              : SvgPicture.asset(
                                                  'assets/microphone.svg'),
                                          onTap: participantcount >= 1
                                              ? () {
                                                  final bool enabled =
                                                      signalingClient.muteMic();
                                                  print(
                                                      "this is enabled-000 $enabled");
                                                  setState(() {
                                                    switchMute = enabled;
                                                  });
                                                }
                                              : null)
                                  : GestureDetector(
                                      child: !switchMute
                                          ? broadcasttype == "camera" ||
                                                  broadcasttype == "micaudio"
                                              ? SvgPicture.asset(
                                                  'assets/mute_microphone.svg')
                                              : SvgPicture.asset(
                                                  'assets/appaudioon.svg')
                                          : broadcasttype == "camera" ||
                                                  broadcasttype == "micaudio"
                                              ? SvgPicture.asset(
                                                  'assets/microphone.svg')
                                              : SvgPicture.asset(
                                                  'assets/appaudiooff.svg'),
                                      onTap: Platform.isIOS &&
                                              broadcasttype != "camera"
                                          ? null
                                          : participantcount >= 1
                                              ? () {
                                                  final bool enabled =
                                                      signalingClient.muteMic();
                                                  print(
                                                      "this is enabled $enabled");
                                                  setState(() {
                                                    switchMute = enabled;
                                                  });
                                                }
                                              : null),
                            ],
                          ),
                        )
                      ]),
                    ))
            : SizedBox();
  }
}
