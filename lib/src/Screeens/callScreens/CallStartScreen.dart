import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_one2many/src/Screeens/callScreens/StreamBar.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/models/contactList.dart';
import 'package:flutter_one2many/src/core/providers/auth.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_one2many/src/grouplist/GroupListScreen.dart';
import 'package:flutter_one2many/src/shared_preference/shared_preference.dart';
import 'package:flutter_svg/svg.dart';
import '../home/home.dart';
import '../home/streams/remoteStream.dart';

class CallStartScreen extends StatefulWidget {
  final mediaType;
  final remoteRenderer;
  final callTo;
  final incomingfrom;
  final groupName;
  final callingTo;
  final handlePress;
  // final onRemoteStream;
  //final pressDuration;
  final MainProvider mainProvider;
  final AuthProvider authProvider;
  final ContactProvider contactProvider;
  final GroupListProvider groupListprovider;
  final localRenderer;
  final VoidCallback stopCall;
  // final SignalingClient signalingClient;
  final registerRes;

  final handleSeenStatus;
  final ContactList contactList;
  final callType;

  //final statsvalue;
  // final rendererListWithRefID;
  // final remoteVideoFlag;

  const CallStartScreen({
    Key key,
    this.mediaType,
    this.remoteRenderer,
    this.callTo,
    this.incomingfrom,

    // this.pressDuration,

    this.localRenderer,
    this.stopCall,
    // this.signalingClient,
    this.registerRes,
    this.mainProvider,
    this.authProvider,
    this.contactProvider,
    this.contactList,
    this.groupListprovider,
    this.groupName,
    this.callingTo,
    this.handlePress,
    this.handleSeenStatus,
    this.callType,
    //this.statsvalue,
    // this.onRemoteStream,
    // this.rendererListWithRefID,
    // this.remoteVideoFlag,
  }) : super(key: key);

  @override
  _CallStartScreenState createState() => _CallStartScreenState();
}

class _CallStartScreenState extends State<CallStartScreen> {
  DateTime _time;
  Timer _ticker;
  int index = 0;
  bool isSmallScreen = false;
  SharedPref sharedPref = SharedPref();
  String _pressDuration = "00:00";
  String callername = "";
  var number;
  var number1;
  double upstream;
  double downstream;
  double statsval = 0;

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
    print("IS A INDEX ${widget.incomingfrom}");
    if (widget.incomingfrom != null) {
      index = widget.contactList.users
          .indexWhere((element) => element.ref_id == widget.incomingfrom);
      print("IS A INDEX $index");
      callername = widget.contactList.users[index].full_name;
      print("this is caller name in accept screen ${callername}");
    }
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

  handleSeenStatus(index) {
    if (widget.groupListprovider.groupList.groups[index].chatList != null) {
      widget.groupListprovider.groupList.groups[index].chatList
          .forEach((element) {
        if (element.status != ReceiptType.delivered &&
            widget.authProvider.getUser.ref_id != element.from) {
          // ChatModel notseenMsg = element;
          // notseenMsg.type = "RECEIPTS";
          // notseenMsg.receiptType = 3;

          Map<String, dynamic> tempData = {
            "date": ((new DateTime.now()).millisecondsSinceEpoch).round(),
            "from": widget.authProvider.getUser.ref_id,
            "key": element.key,
            "messageId": element.id,
            "receiptType": ReceiptType.seen,
            "to": widget.groupListprovider.groupList.groups[index].channel_name
          };
          emitter.publish(
              widget.groupListprovider.groupList.groups[index].channel_key,
              widget.groupListprovider.groupList.groups[index].channel_name,
              tempData);
        }
      });
    }
  }

  void _updateTimer() {
    //_time = DateTime.now();
    final duration = DateTime.now().difference(_time);
    final newDuration = _formatDuration(duration);
    //if (mounted) {

    setState(() {
      // Your state change code goes here
      _pressDuration = newDuration;
      //number=  double.parse((statsval).toStringAsFixed(2));
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
    //  _groupListProvider.handlBacktoGroupList(index);
    //  Navigator.pop(context);
    if (strArr.last == "GroupList") {
      print("here in onpress back arrow grouplist");
      widget.mainProvider.homeScreen();

      widget.mainProvider.activeCall();
      strArr.remove("GroupList");
    } else if (strArr.last == "ChatScreen") {
      print("here in onpress back arrow chat $listIndex");
      widget.groupListprovider.setCountZero(listIndex);
      handleSeenStatus(listIndex);
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
      widget.groupListprovider.setCountZero(listIndex);
      handleSeenStatus(listIndex);
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
    // else if(strArr.last == "GroupList" ||strArr.last =="GroupListActiveCall"){
    //   Navigator.of(context).pop(true);
    // }
    //widget.groupListprovider.duration("");

    //widget.groupListprovider.callProgress(true);
    // pressDuration=_pressDuration;
    //time = _time;
    // timee=_time;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    print(
        "this is caller $callTo $callername $iscalloneto1 ${forLargStream["rtcVideoRenderer"]}");

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: OrientationBuilder(builder: (context, orientation) {
            return
                //
                Container(
                    child: Stack(
              children: [
                onRemoteStream
                    ?
                    // widget.mediaType=="audio"
                    forLargStream["remoteVideoFlag"] == 0
                        ? Center(
                            child: ListView.builder(
                                //scrollDirection: Axis.,
                                shrinkWrap: true,
                                itemCount: rendererListWithRefID.length,
                                //widget.mainProvider.rendererListWithRefID.length,
                                itemBuilder: (context, index) {
                                  print(
                                      "THIS IS USERINDEX ${rendererListWithRefID.length}");
                                  return (rendererListWithRefID[index]
                                              ["refID"] ==
                                          widget.authProvider.getUser.ref_id)
                                      ? SizedBox()
                                      :
                                      // widget
                                      //                     .callingTo[index].ref_id==rendererListWithRefID[index]["refID"]?

                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/userIconCall.svg',
                                            ),
                                            Text(widget
                                                .contactProvider
                                                .contactList
                                                .users[widget.contactProvider
                                                    .contactList.users
                                                    .indexWhere((element) =>
                                                        element.ref_id ==
                                                        rendererListWithRefID[
                                                            index]["refID"])]
                                                .full_name),
                                          ],
                                        );
                                }),
                          )
                        // Container(
                        //     decoration:
                        //         BoxDecoration(color: backgroundAudioCallLight),
                        //     child: Center(
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           SvgPicture.asset(
                        //             'assets/userIconCall.svg',
                        //           ),
                        //           Text(widget
                        //               .contactProvider
                        //               .contactList
                        //               .users[widget
                        //                   .contactProvider.contactList.users
                        //                   .indexWhere((element) =>
                        //                       element.ref_id ==
                        //                       forLargStream["refID"])]
                        //               .full_name)
                        //         ],
                        //       ),
                        //     ),
                        //   )
                        : rendererListWithRefID.length == 1
                            ? Container(
                                decoration: BoxDecoration(
                                    color: backgroundAudioCallLight),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/userIconCall.svg',
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : RemoteStream(
                                remoteRenderer:
                                    forLargStream["rtcVideoRenderer"],
                              )
                    : Container(
                        decoration:
                            BoxDecoration(color: backgroundAudioCallLight),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/userIconCall.svg',
                              ),
                            ],
                          ),
                        ),
                      ),

                Container(
                  padding: EdgeInsets.only(
                    top: 55,
                  ),
                  //height: 79,
                  //width: MediaQuery.of(context).size.width,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
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
                              } else if (strArr.last == "ChatScreen") {
                                print(
                                    "here in onpress back arrow chat $listIndex");
                                widget.groupListprovider
                                    .setCountZero(listIndex);
                                handleSeenStatus(listIndex);
                                widget.mainProvider
                                    .chatScreen(index: listIndex);

                                widget.mainProvider.activeCall();
                                strArr.remove("ChatScreen");
                              } else if (strArr.last ==
                                  "CreateIndividualGroup") {
                                print("here in onpress back arrow group");
                                widget.mainProvider
                                    .createIndividualGroupScreen();

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
                              } else if (strArr.last ==
                                  "ChatScreenWithActiveCall") {
                                print("here in onpress back arrow grouplist");
                                widget.mainProvider
                                    .chatScreen(index: listIndex);
                                widget.groupListprovider
                                    .setCountZero(listIndex);
                                handleSeenStatus(listIndex);
                                widget.mainProvider.activeCall();
                                // widget.handleSeenStatus();
                                strArr.remove("ChatScreenWithActiveCall");
                              } else if (strArr.last ==
                                  "CreateGroupChatActiveCall") {
                                print("here in onpress back arrow grouplist");
                                widget.mainProvider.createGroupChatScreen();

                                widget.mainProvider.activeCall();
                                strArr.remove("CreateGroupChatActiveCall");
                              } else if (strArr.last ==
                                  "CreateIndividualGroupActiveCall") {
                                print("here in onpress back arrow grouplist");
                                widget.mainProvider
                                    .createIndividualGroupScreen();

                                widget.mainProvider.activeCall();
                                strArr
                                    .remove("CreateIndividualGroupActiveCall");
                              }

                              print("this is mesg scrn icon pressed");
                            },
                          ),
                          Text(
                            widget.mediaType == "video"
                                ? 'You are video calling with'
                                : "You are audio calling with",
                            style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.none,
                                fontFamily: secondaryFontFamily,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                color: darkBlackColor),
                          ),
                          Spacer(),
                          //  padding: EdgeInsets.only(left: 90),
                          Container(
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
                        ],
                      ),
                    ],
                  ),
                ),
                callTo != "" && iscalloneto1 == true
                    ? Container(
                        padding: EdgeInsets.only(top: 85, left: 50),
                        child: Text(
                          '${callTo}',
                          //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                          style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: darkBlackColor),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 85, left: 50),
                        child: Text(
                          '${groupName}',
                          //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                          style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: darkBlackColor),
                        ),
                      ),

                //     : callTo != "" &&
                //             iscalloneto1 == false &&
                //             widget.callingTo.length > 2
                //         ? Container(
                //             padding: EdgeInsets.only(top: 85, left: 50),
                //             child: Text(
                //               '${widget.groupName}',
                //               //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                //               style: TextStyle(
                //                   fontSize: 24,
                //                   decoration: TextDecoration.none,
                //                   fontFamily: primaryFontFamily,
                //                   fontWeight: FontWeight.w700,
                //                   fontStyle: FontStyle.normal,
                //                   color: darkBlackColor),
                //             ),
                //           )
                //         : callTo != "" &&
                //                 iscalloneto1 == false &&
                //                 widget.callingTo.length > 1
                //             ? Container(
                //                 padding: EdgeInsets.only(top: 85, left: 50),
                //                 child: Text(
                //                   '${callTo}',
                //                   //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                //                   style: TextStyle(
                //                       fontSize: 24,
                //                       decoration: TextDecoration.none,
                //                       fontFamily: primaryFontFamily,
                //                       fontWeight: FontWeight.w700,
                //                       fontStyle: FontStyle.normal,
                //                       color: darkBlackColor),
                //                 ),
                //               )
                //             : callTo != "" && iscalloneto1 == false
                //                 ? Container(
                //                     padding: EdgeInsets.only(top: 85, left: 50),
                //                     child: Text(
                //                       '${callTo}',
                //                       //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                //                       style: TextStyle(
                //                           fontSize: 24,
                //                           decoration: TextDecoration.none,
                //                           fontFamily: primaryFontFamily,
                //                           fontWeight: FontWeight.w700,
                //                           fontStyle: FontStyle.normal,
                //                           color: darkBlackColor),
                //                     ),
                //                   )
                //                 : callTo == ""
                //                     ? Container(
                //                         padding:
                //                             EdgeInsets.only(top: 85, left: 50),
                //                         child: Text(
                //                           '$callername',
                //                           //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                //                           style: TextStyle(
                //                               fontSize: 24,
                //                               decoration: TextDecoration.none,
                //                               fontFamily: primaryFontFamily,
                //                               fontWeight: FontWeight.w700,
                //                               fontStyle: FontStyle.normal,
                //                               color: darkBlackColor),
                //                         ),
                //                       )
                //                     : Container(),
                //*
                widget.mediaType == "video"
                    ? Container(
                        child: Align(
                        alignment: Alignment.topRight,
                        // color: Colors.red,
                        child: Column(
                          children: [
                            Container(
                              // height: 500,
                              // width: 500,
                              // padding: EdgeInsets.zero,
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 244.33, 20, 27),

                              child: GestureDetector(
                                child: SvgPicture.asset(
                                    'assets/switch_camera.svg'),
                                onTap: () {
                                  signalingClient.switchCamera();
                                },
                              ),
                            ),
                            Container(
                              // padding: EdgeInsets.zero,
                              // height: 500,
                              // width: 500,
                              padding: const EdgeInsets.only(right: 20),

                              child: GestureDetector(
                                child: switchSpeaker
                                    ? SvgPicture.asset('assets/VolumnOn.svg')
                                    : SvgPicture.asset('assets/VolumeOff.svg'),
                                onTap: () {
                                  print("hehehehehe $switchSpeaker");
                                  setState(() {
                                    switchSpeaker = !switchSpeaker;
                                  });

                                  signalingClient.switchSpeaker(switchSpeaker);
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                    : Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 120.0, 20.0, 8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  child: switchSpeaker
                                      ? SvgPicture.asset('assets/VolumnOn.svg')
                                      : SvgPicture.asset(
                                          'assets/VolumeOff.svg'),
                                  onTap: () {
                                    print(
                                        "here in onpress switch speaker $switchSpeaker");
                                    setState(() {
                                      switchSpeaker = !switchSpeaker;
                                    });
                                    signalingClient
                                        .switchSpeaker(switchSpeaker);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                widget.mediaType == "video"
                    // && typeOfCall!="one_to_many"
                    ? Positioned(
                        top: 135,
                        left: 8,

                        // bottom: 145.0,
                        // right: 20,
                        child: StreamBar(
                            orientation: orientation,
                            groupListProvider: widget.groupListprovider,
                            mainProvider: widget.mainProvider,
                            meidaType: widget.mediaType,
                            isActive: false))
                    : Container(),

                Container(
                  padding: EdgeInsets.only(
                    bottom: 56,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.mediaType == "video"
                          ? Row(
                              children: [
                                GestureDetector(
                                  child: !enableCamera
                                      ? SvgPicture.asset('assets/video_off.svg')
                                      : SvgPicture.asset('assets/video.svg'),
                                  onTap: () {
                                    setState(() {
                                      enableCamera = !enableCamera;
                                    });
                                    signalingClient.audioVideoState(
                                        audioFlag: switchMute ? 1 : 0,
                                        videoFlag: enableCamera ? 1 : 0,
                                        mcToken: widget.registerRes["mcToken"]);
                                    signalingClient.enableCamera(enableCamera);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                )
                              ],
                            )
                          : SizedBox(),

                      GestureDetector(
                        child: SvgPicture.asset(
                          'assets/end.svg',
                        ),
                        onTap: () {
                          widget.stopCall();
                          widget.groupListprovider.callProgress(false);
                          // setState(() {
                          //   switchMute = true;
                          //   enableCamera = true;
                          //   switchSpeaker = true;
                          // });
                        },
                      ),

                      // SvgPicture.asset('assets/images/end.svg'),

                      SizedBox(width: 20),
                      GestureDetector(
                        child: !switchMute
                            ? SvgPicture.asset('assets/mute_microphone.svg')
                            : SvgPicture.asset('assets/microphone.svg'),
                        onTap: () {
                          final bool enabled = signalingClient.muteMic();
                          print("this is enabled $enabled $switchMute");
                          setState(() {
                            switchMute = enabled;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                )
              ],
            ));
          }),
        ));
  }
}
