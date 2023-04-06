import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/models/contactList.dart';
import 'package:flutter_one2many/src/core/providers/auth.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_one2many/src/grouplist/GroupListScreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

import '../home/home.dart';
import '../home/streams/remoteStream.dart';

class CallReceiveScreen extends StatefulWidget {
  final mediaType;
  final localRenderer;
  final incomingfrom;
  final authtoken;
  final groupName;
  final registerRes;
  final GroupListProvider groupListProvider;
  final MainProvider mainProvider;
  final AuthProvider authProvider;
 // final VoidCallback stopRinging;
  final SignalingClient signalingClient;
  final ContactList contactList;
  final from;
// final rendererListWithRefID;
  const CallReceiveScreen({
    Key key,
    this.mediaType,
    this.localRenderer,
    this.incomingfrom,
    this.registerRes,
    //this.stopRinging,
    this.signalingClient,
    this.authtoken,
    this.mainProvider,
    this.authProvider,
    this.from,
    this.contactList,
    this.groupListProvider,
    this.groupName,
  }) : super(key: key);
  @override
  _CallReceiveScreenState createState() => _CallReceiveScreenState();
}

class _CallReceiveScreenState extends State<CallReceiveScreen> {
  String callername = "";
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("authtoken ${widget.contactList}");

    // print("DNVJDNVJDNVJDNVJDVNJDVN ${widget.contactList}");
    // if (widget.contactProvider.contactState == ContactStates.Success) {
    print("here in success ${widget.contactList} ${groupName}");
    //  }
    if (iscalloneto1) {
      index = widget.contactList.users
          .indexWhere((element) => element.ref_id == widget.incomingfrom);
      callername = widget.contactList.users[index].full_name;
      print("this is caller name in receive call $callername");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("incoming isssrthrhgfgg ${widget.mainProvider}");
    // return Consumer2<AuthProvider, CallProvider>(
    //     builder: (context, authProvider, callProvider, child) {

    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Stack(children: <Widget>[
        widget.mediaType == "video"
            ? rendererListWithRefID.length == 0
                ? Container()
                : groupBroadcast
                    ? Container(
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
                        child: RemoteStream(
                        remoteRenderer: rendererListWithRefID[0]
                            ["rtcVideoRenderer"],
                      ))
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
          padding: EdgeInsets.only(top: 120),
          alignment: Alignment.center,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Incoming Call from",
                style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontFamily: secondaryFontFamily,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: darkBlackColor),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                iscalloneto1
                    ? callername
                    :
                    // callername,
                    groupName==null?"":groupName,
                style: TextStyle(
                    fontFamily: primaryFontFamily,
                    color: darkBlackColor,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 24),
              ),
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
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
               //   widget.stopRinging();
                  widget.signalingClient.declineCall(
                      widget.authProvider.getUser.ref_id,
                      widget.registerRes["mcToken"]);
                
                  //  if (strArr.last == "CreateGroupChat") {
                  //   widget.mainProvider.createGroupChatScreen();
                  // } else if (strArr.last == "GroupList") {
                  //   widget.mainProvider.homeScreen();
                  // }  else if (strArr.last == "NoChat") {
                  //   widget.mainProvider.inActiveCall();
                  //   widget.mainProvider.homeScreen();
                  //   strArr.remove("NoChat");
                  // } 
                },
              ),
              SizedBox(width: 64),
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/Accept.svg',
                ),
                onTap: () {
                 // widget.stopRinging();
                  widget.signalingClient.createAnswer(widget.incomingfrom);
                  // Navigator.pop(context);
                  // widget.mainProvider.callStart();
                  // setState(() {
                  //   _isCalling = true;
                  //   incomingfrom = null;
                  // });
                  // FlutterRingtonePlayer.stop();
                  // Vibration.cancel();
                },
              ),
            ],
          ),
        ),
      ]);
    }));
    //   floatingActionButton: Padding(
    //     padding: const EdgeInsets.only(bottom: 70),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         Container(
    //           // width: 80,
    //           // height: 80,
    //           child: FloatingActionButton(
    //             backgroundColor: redColor,
    //             onPressed: () {
    //               stopRinging();
    //               signalingClient.onDeclineCall(_auth.getUser.ref_id);
    //               // _callBloc.add(CallNewEvent());
    //               _callProvider.initial();
    //               // signalingClient.onDeclineCall(widget.registerUser);
    //               // setState(() {
    //               //   _isCalling = false;
    //               // });
    //             },
    //             child: Icon(Icons.clear),
    //           ),
    //         ),
    //         Container(
    //           // width: 80,
    //           // height: 80,
    //           child: FloatingActionButton(
    //             backgroundColor: Colors.green,
    //             onPressed: () {
    //               stopRinging();
    //               signalingClient.createAnswer(incomingfrom);
    //               // setState(() {
    //               //   _isCalling = true;
    //               //   incomingfrom = null;
    //               // });
    //               // FlutterRingtonePlayer.stop();
    //               // Vibration.cancel();
    //             },
    //             child: Icon(Icons.phone),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // );
  }
}
