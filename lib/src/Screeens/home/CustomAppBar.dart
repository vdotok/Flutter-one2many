import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/ContactListScreen/ContactListScreen.dart';
import 'package:flutter_one2many/src/Screeens/broadcasting/BroadcastPopup.dart';
import 'package:flutter_one2many/src/Screeens/home/landingScreen.dart';
import 'package:flutter_one2many/src/core/models/GroupModel.dart';

import 'package:flutter_one2many/src/core/providers/auth.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../constants/constant.dart';
import '../../core/providers/groupListProvider.dart';
import 'home.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final title;
  final isPublicBroadcast;
  final bool lead;
  final succeedingIcon;
  final bool ischatscreen;
  final index;
  final GroupListProvider groupListProvider;
  final AuthProvider authProvider;
  final MainProvider mainProvider;
  final funct;
  final handlePress;
  final handlePublicBroadcastButton;

  CustomAppBar(
      {Key key,
      this.groupListProvider,
      this.title,
      @required this.lead,
      this.succeedingIcon,
      this.ischatscreen,
      this.index,
      this.authProvider,
      this.mainProvider,
      this.funct,
      this.handlePress,
      this.isPublicBroadcast,
      this.handlePublicBroadcastButton})
      : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize {
    return ischatscreen ? Size.fromHeight(80) : Size.fromHeight(kToolbarHeight);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Size get preferredSize {
    return widget.ischatscreen
        ? Size.fromHeight(80)
        : Size.fromHeight(kToolbarHeight);
  }

  Emitter emitter;

  String _presenceStatus = "";

  int _count = 0;
  Future buildShowDialog(
      BuildContext context, String mesg, String errorMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
                title: Center(
                    child: Text(
                  "${mesg}",
                  style: TextStyle(color: counterColor),
                )),
                content: Text("$errorMessage"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 0,
                actions: <Widget>[
                  Container(
                    height: 50,
                    width: 319,
                  )
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    print("this is index in chat screen ${widget.mainProvider}");

    return AppBar(
      backgroundColor:
          widget.ischatscreen ? appbarBackgroundColor : chatRoomBackgroundColor,
      elevation: 0.0,
      centerTitle: false,
      leading: widget.lead == true
          ? Padding(
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: chatRoomColor,
                ),
                onPressed: () {
                  isAppAudiobuttonSelected = false;
                  ismicAudiobuttonSelected = false;
                  iscamerabuttonSelected = false;
                  if (strArr.last == "GroupList") {
                    print("this is grpriiot");
                    widget.mainProvider.homeScreen();
                  } 
                  // else {
                  //   print("ieyueu");
                  //   widget.mainProvider.groupListScreen();
                   
                  // }
                },
              ),
            )
          : null,
      title: Text("${widget.title}",
          style: TextStyle(
            color: chatRoomColor,
            fontSize: 20,
            fontFamily: primaryFontFamily,
            fontWeight: FontWeight.w500,
          )),
      actions: [
        //If we are on chat screen//

        widget.ischatscreen == true
            ?
            //Container()
            Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Container(
                          width: 35,
                          height: 35,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/group_broadcast.svg'),
                              onPressed: widget
                                          .groupListProvider.callprogress ==
                                      true
                                  ? () {}
                                  : !isInternetConnect
                                      ? (!isRegisteredAlready)
                                          ? () {
                                              // buildShowDialog(
                                              //     context,
                                              //     "No Internet Connection",
                                              //     "Make sure your device has internet.");
                                            }
                                          : () {}
                                      : isRegisteredAlready
                                          ? () {}
                                          : () {
                                              groupName = widget
                                                  .groupListProvider
                                                  .groupList
                                                  .groups[widget.index]
                                                  .group_title;
                                              GroupModel model = widget
                                                  .groupListProvider
                                                  .groupList
                                                  .groups[widget.index];
                                              print(
                                                  "groupbroadcast popup $model");
                                              isAppAudiobuttonSelected = false;
                                              ismicAudiobuttonSelected = false;

                                              iscamerabuttonSelected = false;
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return BroadCastPopUp(
                                                        text: "Group BroadCast",
                                                        startCall: widget.funct,
                                                        to: model);
                                                  });
                                            }))),
                  Padding(
                    padding: const EdgeInsets.only(top: 21.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      child: IconButton(
                        icon: SvgPicture.asset('assets/call.svg'),
                        onPressed: widget.groupListProvider.callprogress == true
                            ? () {}
                            : !isInternetConnect
                                ? (!isRegisteredAlready)
                                    ? () {
                                        // buildShowDialog(
                                        //     context,
                                        //     "No Internet Connection",
                                        //     "Make sure your device has internet.");
                                      }
                                    : () {}
                                : isRegisteredAlready
                                    ? () {}
                                    : () {
                                        print("I am in audiocall press");
                                        setState(() {
                                          iscalloneto1 = false;
                                        });
                                        //  widget.callProvider.callDial();

                                        //  print("DJNVJDBVJDBVJDBVJDBVHDHBBJLLLLL ${widget.groupListProvider.groupList.groups[widget.index].participants[widget.groupListProvider.groupList.groups[widget.index].participants.indexWhere((element) => element.ref_id != widget.authProvider.getUser.ref_id)].full_name.toString()}");
                                        callTo = widget
                                            .groupListProvider
                                            .groupList
                                            .groups[widget.index]
                                            .participants[0]
                                            .full_name
                                            .toString();
                                        groupName = widget
                                            .groupListProvider
                                            .groupList
                                            .groups[widget.index]
                                            .group_title;
                                        print(
                                            "AMMMMMMMMMMMM $callTo $groupName");
                                        GroupModel model = widget
                                            .groupListProvider
                                            .groupList
                                            .groups[widget.index];
                                        print("this is groupmodel $model");
                                        widget.funct(
                                            to: model,
                                            mtype: CallMediaType.audio,
                                            callType: CAllType.many2many,
                                            sessionType: SessionType.call);
                                        // _startCall([test.ref_id], CallMediaType.audio,
                                        //     CAllType.one2one, SessionType.call);
                                        // setState(() {
                                        //  callTo = widget.groupListProvider.groupList.groups[widget.index].participants[0].full_name;
                                        //   meidaType = CallMediaType.audio;
                                        //   print("this is callTo $callTo");
                                        // });
                                        // print("three dot icon pressed");
                                      },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 21.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: SvgPicture.asset('assets/videocallicon.svg'),
                        onPressed: widget.groupListProvider.callprogress == true
                            ? () {}
                            : !isInternetConnect
                                ? (!isRegisteredAlready)
                                    ? () {
                                        // buildShowDialog(
                                        //     context,
                                        //     "No Internet Connection",
                                        //     "Make sure your device has internet.");
                                      }
                                    : () {}
                                : isRegisteredAlready
                                    ? () {}
                                    : () {
                                        setState(() {
                                          iscalloneto1 = false;
                                        });
                                        // print("I am in audiocall press");
                                        callTo = widget
                                            .groupListProvider
                                            .groupList
                                            .groups[widget.index]
                                            .participants[0]
                                            .full_name
                                            .toString();
                                        groupName = widget
                                            .groupListProvider
                                            .groupList
                                            .groups[widget.index]
                                            .group_title;
                                        print(
                                            "THIS IS VIDEO CALL $callTo $groupName");
                                        GroupModel model = widget
                                            .groupListProvider
                                            .groupList
                                            .groups[widget.index];
                                        widget.funct(
                                            to: model,
                                            mtype: CallMediaType.video,
                                            callType: CAllType.many2many,
                                            sessionType: SessionType.call);
                                        //   widget.callProvider.callDial();
                                        // _startCall([test.ref_id], CallMediaType.video,
                                        //     CAllType.one2one, SessionType.call);
                                        // setState(() {
                                        //   callTo = test.full_name;
                                        //   meidaType = CallMediaType.video;
                                        // });
                                        // print("three dot icon pressed");
                                      },
                      ),
                    ),
                  ),
                  SizedBox(width: 14)
                ],
              )
            :
            //If we are on other screens//
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: widget.succeedingIcon == ""
                    ? Container()
                    : IconButton(
                        icon: SvgPicture.asset(widget.succeedingIcon),
                        onPressed: widget.succeedingIcon == 'assets/plus.svg'
                            ? () {
                                print(
                                    "THSI IS DFFVDFJCJDFBKJD ${widget.mainProvider}");
                                widget.mainProvider.createGroupChatScreen();

                                //   widget.handlePress(
                                //       ListStatus.CreateIndividualGroup);
                                //   widget.mainProvider
                                //       .inActiveCallCreateIndividualGroup(
                                //     startCall: widget.funct,
                                //   );
                                // }
                              }
                            //ContactListIndex();
                            //   Navigator.pushNamed(context, '/contactlist',
                            //       arguments: {
                            //         "groupListProvider":
                            //             widget.groupListProvider,
                            //         "funct": widget.funct,
                            //         "callProvider": widget.mainProvider
                            //       });
                            // }
                            : () {},
                      ),
              ),
      ],
    );
  }
}
