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
        "this is index in a onremotestream1 $meidaType $remoteVideoFlag $isDialer $ispublicbroadcast $groupBroadcast $pressDuration $broadcasttype");

    return ispublicbroadcast
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: Container(
                child: Stack(children: <Widget>[
              participantcount >= 1
                  ? broadcasttype == "camera"
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
                    padding: const EdgeInsets.only(top: 50.85),
                  ),
                  Row(
                    children: [
                      //backArrow(),
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
                          : FlatButton(
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
                                        pressDuration,
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
                  ? broadcasttype == "camera"
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
                            child: FlatButton(
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
                                  onTap: participantcount >= 1
                                      ? () {
                                          setState(() {
                                            print("9586706");
                                            enableCamera2 = !enableCamera2;
                                          });
                                          signalingClient.audioVideoState(
                                              audioFlag: switchMute ? 1 : 0,
                                              videoFlag: enableCamera2 ? 1 : 0,
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
                                          print("jhdgutgyurer");
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
                            onTap: participantcount >= 1
                                ? () {
                                    setState(() {
                                      enableCamera = !enableCamera;
                                    });
                                    signalingClient.audioVideoState(
                                        audioFlag: switchMute ? 1 : 0,
                                        videoFlag: enableCamera ? 1 : 0,
                                        mcToken: widget.registerRes["mcToken"]);
                                    signalingClient.enableCamera(enableCamera);
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
                                      onTap: participantcount >= 1
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
                            onTap: participantcount >= 1
                                ? () {
                                    // print("this is enabled9797 $enabled");
                                    final bool enabled =
                                        signalingClient.muteMic();
                                    print("this is enabled9797 $enabled");
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
                ? rendererListWithRefID.length == 1
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
                                        ? RemoteStream(
                                            remoteRenderer:
                                                rendererListWithRefID[1]
                                                    ["rtcVideoRenderer"],
                                          )
                                        : rendererListWithRefID.length == 3
                                            ? RemoteStream(
                                                remoteRenderer:
                                                    rendererListWithRefID[2]
                                                        ["rtcVideoRenderer"],
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
                              padding: EdgeInsets.only(top: 55),
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
                                      // backArrow(),
                                      (session_type == "call")
                                          ? Text(
                                              (meidaType == "video")
                                                  ? 'You are video calling with'
                                                  : 'You are audio calling with',
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
                                          : Container(),
                                    ],
                                  ),
                                  (session_type == "call")
                                      ? Container(
                                          padding: EdgeInsets.only(left: 50),
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
                                      : Container(),
                                ],
                              ),
                            ),
                            !kIsWeb
                                ? Container(
                                    // color: Colors.red,
                                    child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 120.33, 20, 27),
                                          child: pressDuration == null
                                              ? Container()
                                              : Text(
                                                  '$pressDuration',
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          secondaryFontFamily,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: darkBlackColor),
                                                ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 0, 20, 0),
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
                                        ),
                                      ],
                                    ),
                                  ))
                                : SizedBox(),
                            // /////////////// this is local stream

                            rendererListWithRefID.length == 3
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
                                          child: enableCamera
                                              ? RemoteStream(
                                                  remoteRenderer:
                                                      rendererListWithRefID[1]
                                                          ["rtcVideoRenderer"])
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
                : WillPopScope(
                    onWillPop: _onWillPop,
                    child: Container(
                      child: Stack(children: <Widget>[
                        meidaType == "video"
                            ? enableCamera
                                ? RemoteStream(
                                    remoteRenderer: rendererListWithRefID[0]
                                        ["rtcVideoRenderer"],
                                  )
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
                          padding: EdgeInsets.only(
                            top: 55,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  //   backArrow(),
                                  Text(
                                    (meidaType == "video")
                                        ? 'You are video calling with'
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
                                padding: EdgeInsets.only(left: 50),
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
                                              '$pressDuration',
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
                                            onTap: participantcount >= 1
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
                                      onTap: participantcount >= 1
                                          ? () {
                                              setState(() {
                                                enableCamera = !enableCamera;
                                              });
                                              signalingClient.audioVideoState(
                                                  audioFlag: switchMute ? 1 : 0,
                                                  videoFlag:
                                                      enableCamera ? 1 : 0,
                                                  mcToken: widget
                                                      .registerRes["mcToken"]);
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
                                                onTap: participantcount >= 1
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
                                      onTap: participantcount >= 1
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
                      ]),
                    ))
            : SizedBox();
  }

  IconButton backArrow() {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        size: 24,
        color: chatRoomColor,
      ),
      onPressed: () {
        if (strArr.last == "GroupList") {
          print("here in onpress back arrow grouplist");
          widget.mainProvider.homeScreen();

          widget.mainProvider.activeCall();
          strArr.remove("GroupList");
        } else if (strArr.last == "NoChat") {
          print("here in onpress back arrow nochat");
          widget.mainProvider.homeScreen();

          widget.mainProvider.activeCall();
          strArr.remove("NoChat");
        } else if (strArr.last == "NoChatActiveBroadcast") {
          print("here in onpress back arrow nochat");
          widget.mainProvider.homeScreen();

          widget.mainProvider.activeCall();
          strArr.remove("NoChatActiveBroadcast");
        } else if (strArr.last == "ChatScreen") {
          print("here in onpress back arrow chat $listIndex");
          widget.mainProvider.chatScreen(index: listIndex);

          widget.mainProvider.activeCall();
          strArr.remove("ChatScreen");
        } else if (strArr.last == "CreateIndividualGroup") {
          print("here in onpress back arrow group");
          widget.mainProvider.createIndividualGroupScreen();

          widget.mainProvider.activeCall();
          strArr.remove("CreateIndividualGroup");
        } else if (strArr.last == "CreateGroupChat") {
          print("here in onpress back arrow");
          widget.mainProvider.createGroupChatScreen();

          widget.mainProvider.activeCall();
          strArr.remove("CreateGroupChat");
        } else if (strArr.last == "GroupListActiveCall") {
          print("here in onpress back arrow grouplist");
          widget.mainProvider.homeScreen();

          widget.mainProvider.activeCall();
          strArr.remove("GroupListActiveCall");
        } else if (strArr.last == "ChatScreenWithActiveCall") {
          print("here in onpress back arrow grouplist");
          widget.mainProvider.chatScreen(index: listIndex);

          widget.mainProvider.activeCall();
          // widget.handleSeenStatus();
          strArr.remove("ChatScreenWithActiveCall");
        } else if (strArr.last == "CreateGroupChatActiveCall") {
          print("here in onpress back arrow grouplist");
          widget.mainProvider.createGroupChatScreen();

          widget.mainProvider.activeCall();
          strArr.remove("CreateGroupChatActiveCall");
        } else if (strArr.last == "CreateIndividualGroupActiveCall") {
          print("here in onpress back arrow grouplist");
          widget.mainProvider.createIndividualGroupScreen();

          widget.mainProvider.activeCall();
          strArr.remove("CreateIndividualGroupActiveCall");
        }

        print("this is mesg scrn icon pressed");
      },
    );
  }
}
