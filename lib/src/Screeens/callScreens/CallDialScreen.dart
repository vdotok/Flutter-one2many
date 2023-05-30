import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/providers/auth.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_one2many/src/grouplist/GroupListScreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

import '../home/home.dart';
import '../home/streams/remoteStream.dart';

class CallDialScreen extends StatefulWidget {
  final mediaType;
  final remoteRenderer;
  final callTo;
  final incomingfrom;
  final callingTo;
  //final pressDuration;
  final MainProvider? mainProvider;
  final AuthProvider? authProvider;
  final ContactProvider? contactProvider;
  final localRenderer;
  final VoidCallback? stopCall;
  final GroupListProvider? groupListProvider;
  final registerRes;
//  final rendererListWithRefID;
  // final remoteVideoFlag;

  const CallDialScreen({
    Key? key,
    this.mediaType,
    this.remoteRenderer,
    this.callTo,
    this.incomingfrom,
    // this.pressDuration,

    this.localRenderer,
    this.stopCall,
    this.registerRes,
    this.mainProvider,
    this.authProvider,
    this.contactProvider,
    // this.rendererListWithRefID,
    this.callingTo,
    this.groupListProvider,
    // this.remoteVideoFlag,
  }) : super(key: key);

  @override
  _CallDialScreenState createState() => _CallDialScreenState();
}

class _CallDialScreenState extends State<CallDialScreen> {
  // String _pressDuration = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.mainProvider.rendererListWithRefID.length);
  }

  @override
  Widget build(BuildContext context) {
    print("DNJDNJDGNJDHGJDHGJ ${widget.mediaType}");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: [
//             widget.mediaType == "video"
//                 ? Container(
//                     // color: Colors.red,
//                     //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     child: rendererListWithRefID.length == 0
//                         ? Container()
//                         :
//                         RemoteStream(
//                             remoteRenderer: rendererListWithRefID[0]
//                                 ["rtcVideoRenderer"],
//                             // remoteRenderer: rendererListWithRefID[0]
//                             //     ["rtcVideoRenderer"],
//                           )
// // RemoteStream(
// //                       remoteRenderer: rendererListWithRefID[0]
// //                           ["rtcVideoRenderer"],
// //                     )
//                     // RTCVideoView(
//                     //     rendererListWithRefID[0]["rtcVideoRenderer"],
//                     //     key: forDialView,
//                     //     mirror: false,
//                     //     objectFit: RTCVideoViewObjectFit
//                     //         .RTCVideoViewObjectFitCover),
//                     )
//                 : Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                       colors: [
//                         backgroundAudioCallDark,
//                         backgroundAudioCallLight,
//                         backgroundAudioCallLight,
//                         backgroundAudioCallLight,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment(0.0, 0.0),
//                     )),
//                     child: Center(
//                       child: SvgPicture.asset(
//                         'assets/userIconCall.svg',
//                       ),
//                     ),
//                   ),
            Container(
                padding: EdgeInsets.only(top: 120),
                alignment: Alignment.center,
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isRinging ? "Ringing" : "Calling",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontFamily: secondaryFontFamily,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: darkBlackColor),
                      ),
                      callTo != "" && iscalloneto1 == true
                          ? Text(
                              "$callTo",
                              style: TextStyle(
                                  fontFamily: primaryFontFamily,
                                  color: darkBlackColor,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 24),
                            )
                          : Text(
                              "$groupName",
                              style: TextStyle(
                                  fontFamily: primaryFontFamily,
                                  color: darkBlackColor,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 24),
                              // callTo != "" && iscalloneto1 == true
                              //     ? Text(
                              //         "$callTo",
                              //         style: TextStyle(
                              //             fontFamily: primaryFontFamily,
                              //             color: darkBlackColor,
                              //             decoration: TextDecoration.none,
                              //             fontWeight: FontWeight.w700,
                              //             fontStyle: FontStyle.normal,
                              //             fontSize: 24),
                              //       )
                              //     : callTo != ""
                              //         ? Expanded(
                              //             child: ListView.builder(
                              //               itemCount: widget.callingTo.length,
                              //               itemBuilder: (context, index) {
                              //                 print(
                              //                     "this is calling to length ${widget.callingTo.length}");
                              //                 return Container(
                              //                   alignment: Alignment.center,
                              //                   child: (widget.callingTo[index]
                              //                               .full_name ==
                              //                           widget.authProvider.getUser
                              //                               .full_name)
                              //                       ? SizedBox(
                              //                           height: 0,
                              //                         )
                              //                       : Text(
                              //                           //'hgddg',
                              //                           widget
                              //                               .callingTo[index].full_name,
                              //                           //  widget.callingTo[index].full_name,
                              //                           // widget.callingTo[index].full_name==widget.
                              //                           style: TextStyle(
                              //                               fontFamily:
                              //                                   primaryFontFamily,
                              //                               color: darkBlackColor,
                              //                               decoration:
                              //                                   TextDecoration.none,
                              //                               fontWeight: FontWeight.w700,
                              //                               fontStyle: FontStyle.normal,
                              //                               fontSize: 24),
                              //                         ),
                              //                 );
                              //               },
                              //             ),
                              //           )
                              //   : Container(),
                            )
                    ])),
            Container(
              padding: EdgeInsets.only(bottom: 56),
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
                  signalingClient.stopCall(widget.registerRes["mcToken"]);
                  // if (strArr.last == "CreateGroupChat") {
                  //   widget.mainProvider.createGroupChatScreen();
                  // } else if (strArr.last == "GroupList") {
                  //   widget.mainProvider.homeScreen();
                  // } else if (strArr.last == "NoChat") {
                  //   widget.mainProvider.inActiveCall();
                  //   widget.mainProvider.homeScreen();
                  //   strArr.remove("NoChat");
                  // }
                  isAppAudiobuttonSelected = false;
                  iscamerabuttonSelected = false;
                  ismicAudiobuttonSelected = false;
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
