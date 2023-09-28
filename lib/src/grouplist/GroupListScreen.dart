import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/CreateGroupScreen/CreateGroupPopUp.dart';
import 'package:flutter_one2many/src/Screeens/home/CustomAppBar.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/models/GroupListModel.dart';
import 'package:flutter_one2many/src/core/models/GroupModel.dart';
import 'package:flutter_one2many/src/core/providers/auth.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

int listIndex = 0;
TextEditingController _groupNameController = TextEditingController();

class GroupListScreen extends StatefulWidget {
  final bool? activeCall;
  final GroupListModel? state;
  final GroupListProvider? groupListProvider;
  final AuthProvider? authProvider;
  final MainProvider? mainProvider;
  final ContactProvider? contactProvider;
  final handlePress;
  //final handleSeenStatus;

  final refreshList;
  final chatSocket;
  final callSocket;
  final isInternet;
  final registerRes;
  final publishMesg;
  final startCall;
  final handlePublicBroadcastButton;

  const GroupListScreen({
    Key? key,
    this.groupListProvider,
    this.state,
    this.authProvider,
    this.mainProvider,
    this.refreshList,
    this.contactProvider,
    this.chatSocket,
    this.callSocket,
    this.isInternet,
    this.registerRes,
    this.publishMesg,
    this.startCall,
    this.handlePress,
    this.activeCall,
    this.handlePublicBroadcastButton,
    //this.handleSeenStatus
  }) : super(key: key);

  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  showSnakbar(msg) {
    final snackBar = SnackBar(
      content: Text(
        "$msg",
        style: TextStyle(color: whiteColor),
      ),
      backgroundColor: primaryColor,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _showDialog(group_id, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: Text('Alert Dialog Example'),
            content: Text('Are you sure you want to delete this chatroom?'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('CANCEL',
                          style: TextStyle(color: chatRoomColor))),
                  // Consumer2<GroupListProvider, AuthProvider>(builder:
                  //     (context, listProvider, authProvider, child) {
                  //   return
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await widget.groupListProvider!.deleteGroup(
                          group_id,
                          widget.authProvider!.getUser!.auth_token,
                        );
                        // (groupListProvider.deleteGroupStatus ==
                        //         DeleteGroupStatus.Loading)
                        //     ? SplashScreen():

                        if (widget.groupListProvider!.deleteGroupStatus ==
                            DeleteGroupStatus.Success) {
                          // groupListProvider.groupList.groups.

                          showSnakbar(widget.groupListProvider!.successMsg);
                        } else if (widget
                                .groupListProvider!.deleteGroupStatus ==
                            DeleteGroupStatus.Failure) {
                          showSnakbar(widget.groupListProvider!.errorMsg);
                        } else {}
                        // if (groupListProvider.status == 200) {
                        //   print(
                        //       "this is status ${groupListProvider.status}");
                        //   groupListProvider.getGroupList(
                        //       authProvider.getUser.auth_token);
                        // }
                      },
                      child: Text('DELETE',
                          style: TextStyle(color: chatRoomColor)))
                  //;
                  // }),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: chatRoomBackgroundColor,
      appBar: CustomAppBar(
        //  handlePublicBroadcastButton:widget.handlePublicBroadcastButton,
        handlePress: widget.handlePress,
        funct: widget.startCall,
        ischatscreen: false,
        groupListProvider: widget.groupListProvider!,
        mainProvider: widget.mainProvider!,
        title: "Group List",
        isPublicBroadcast: true,
        lead: true,
        succeedingIcon: 'assets/plus.svg',
      ),

      body: RefreshIndicator(
        onRefresh: widget.refreshList,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.groupListProvider!.groupList!.groups!.length,
                itemBuilder: (context, index) {
                  GroupModel element = widget.state!.groups![index];
                  print("thisssss ${element}");

                  //The Container returned that will show the Group Name, notification counter and availability status//
                  return
                      // InkWell(
                      //   onTap: () {
                      //     listProvider.setCountZero(index);
                      //     Navigator.pushNamed(context, "/chatScreen",
                      //         arguments: {
                      //           "index": index,
                      //           "publishMessage": publishMessage,
                      //           "groupListProvider": groupListProvider
                      //         });

                      //     handleSeenStatus(index);
                      //   },
                      //child:g
                      Container(
                    // width: 375,
                    // height: 80,
                    child: Column(
                      children: [
                        SizedBox(height: 22),
                        InkWell(
                            onTap: () {
                              print("hfghgfhdf $broadcasttype");
                              groupName = widget.groupListProvider!.groupList!
                                  .groups![index].group_title;
                              if (broadcasttype == "camera") {
                                widget.startCall(
                                    to: element,
                                    mtype: CallMediaType.video,
                                    callType: CAllType.one2many,
                                    sessionType: SessionType.call);
                              } else {
                                widget.startCall(
                                    to: element,
                                    mtype: CallMediaType.video,
                                    callType: CAllType.one2many,
                                    sessionType: SessionType.screen);
                              }

                              setState(() {
                                callTo = element.group_title;

                                meidaType = CallMediaType.video;
                              });
                              print("three dot icon pressed");
                              widget.mainProvider!.callDial();
                              print("this is call to in call dial $callTo");
                            },
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(children: [
                                  //The Group Title Shows Here
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: widget
                                                  .groupListProvider!
                                                  .groupList!
                                                  .groups![index]
                                                  .participants!
                                                  .length ==
                                              1
                                          ? Text(
                                              "${widget.groupListProvider!.groupList!.groups![index].participants![0].full_name}",
                                              //  maxLines: 2,

                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: personNameColor,
                                                fontSize: 20,
                                                fontFamily: primaryFontFamily,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : widget
                                                      .groupListProvider!
                                                      .groupList!
                                                      .groups![index]
                                                      .participants!
                                                      .length ==
                                                  2
                                              ? Text(
                                                  "${widget.groupListProvider!.groupList!.groups![index].participants![widget.groupListProvider!.groupList!.groups![index].participants!.indexWhere((element) => element.ref_id != widget.authProvider!.getUser!.ref_id)].full_name}",
                                                  //maxLines: 2,

                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: personNameColor,
                                                    fontSize: 20,
                                                    fontFamily:
                                                        primaryFontFamily,
                                                    fontWeight: FontWeight.w500,
                                                  ))
                                              : Text(
                                                  "${widget.groupListProvider!.groupList!.groups![index].group_title}",
                                                  //  maxLines: 2,

                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: personNameColor,
                                                    fontSize: 20,
                                                    fontFamily:
                                                        primaryFontFamily,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                    ),
                                  ),
                                ])),
                                Container(
                                  height: 24,
                                  width: 24,
                                  margin: EdgeInsets.only(right: 29),

//                                         child: Column(children:
// [

                                  child: PopupMenuButton(
                                      offset: Offset(8, 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      icon: const Icon(
                                        Icons.more_horiz,
                                        size: 24,
                                        color: horizontalDotIconColor,
                                      ),
                                      itemBuilder: (BuildContext context) => [
                                            PopupMenuItem(
                                              enabled: (widget
                                                              .groupListProvider!
                                                              .groupList!
                                                              .groups![index]
                                                              .participants!
                                                              .length ==
                                                          1 ||
                                                      widget
                                                              .groupListProvider!
                                                              .groupList!
                                                              .groups![index]
                                                              .participants!
                                                              .length ==
                                                          2)
                                                  ? false
                                                  : true,
                                              padding: EdgeInsets.only(
                                                  right: 12, left: 12),
                                              value: 1,

                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 14,
                                                    left: 16,
                                                    right: 70),
                                                width: 200,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                    color: backgroundChatColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                //  color:popupGreyColor,
                                                child: Text(
                                                  "Edit Group Name",
                                                  //textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    //decoration: TextDecoration.underline,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: font_Family,
                                                    fontStyle: FontStyle.normal,
                                                    color: personNameColor,
                                                  ),
                                                ),
                                              ),
                                              //)
                                            ),
                                            //SizedBox(height: 8,),

                                            PopupMenuItem(
                                                padding: EdgeInsets.only(
                                                    right: 12, left: 12),
                                                value: 2,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                        top: 14,
                                                        left: 16,
                                                      ),
                                                      width: 200,
                                                      height: 44,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundChatColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      //  color:popupGreyColor,
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            //decoration: TextDecoration.underline,
                                                            fontSize: font_size,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                font_Family,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color:
                                                                popupDeleteButtonColor),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                      onSelected: (menu) {
                                        if (menu == 1) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ListenableProvider<
                                                        GroupListProvider>.value(
                                                    value: widget
                                                        .groupListProvider!,
                                                    child: CreateGroupPopUp(
                                                      editGroupName: true,
                                                      groupid: widget
                                                          .groupListProvider!
                                                          .groupList!
                                                          .groups![index]
                                                          .id,
                                                      controllerText: widget
                                                          .groupListProvider!
                                                          .groupList!
                                                          .groups![index]
                                                          .group_title,
                                                      groupNameController:
                                                          _groupNameController,
                                                      publishMessage:
                                                          widget.publishMesg,
                                                      authProvider:
                                                          widget.authProvider!,
                                                    ));
                                              });
                                          print("i am after here");
                                          // if (groupListProvider
                                          //         .editGroupNameStatus ==
                                          //     EditGroupNameStatus
                                          //         .Success) {
                                          //   showSnakbar(groupListProvider
                                          //       .successMsg);
                                          // } else if (groupListProvider
                                          //         .editGroupNameStatus ==
                                          //     EditGroupNameStatus
                                          //         .Failure) {
                                          //   showSnakbar(groupListProvider
                                          //       .errorMsg);
                                          // } else {}
                                          //  if(groupListProvider.editGroupNameStatus)
                                        } else if (menu == 2) {
                                          _showDialog(
                                              widget.groupListProvider!
                                                  .groupList!.groups![index].id,
                                              widget.groupListProvider!
                                                  .groupList!.groups![index]);
                                          // groupListProvider.deleteGroup(
                                          //     listProvider.groupList
                                          //         .groups[index].id);
                                        }
                                      }),
//]),
                                ),
                              ],
                            )),
                      ],
                    ),
                    //),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 24),
                    child: Divider(
                      thickness: 1,
                      color: listdividerColor,
                    ),
                  );
                },
              )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // padding: const EdgeInsets.only(bottom: 60),
                            child: TextButton(
                              onPressed: () {
                                if (isRegisteredAlready) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  isRegisteredAlready = false;
                                }
                                isAppAudiobuttonSelected = false;
                                iscamerabuttonSelected = false;
                                ismicAudiobuttonSelected = false;
                                signalingClient.unRegister();
                              },
                              child: Text(
                                "LOG OUT",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: primaryFontFamily,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                    color: logoutButtonColor,
                                    letterSpacing: 0.90),
                              ),
                            ),
                          ),

                          // Container(
                          //   height: 10,
                          //   width: 10,
                          //   decoration: BoxDecoration(
                          //       color: isConnect && widget.state
                          //           ? Colors.green
                          //           : Colors.red,
                          //       shape: BoxShape.circle),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          //   height: 10,
                          //   width: 10,
                          //   decoration: BoxDecoration(
                          //       color: sockett && widget.state
                          //           ? Colors.green
                          //           : Colors.red,
                          //       shape: BoxShape.circle),
                          // )
                          SizedBox(width: 13),
                          Container(
                            height: 18,
                            width: 18,
                            child: SvgPicture.asset(
                              'assets/call.svg',
                              color: widget.callSocket && widget.isInternet
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          errorcode != ""
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  child: Text('$errorcode'))
                              : Container()
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Text(widget.authProvider!.getUser!.full_name!))
                    ],
                  )),
            ],
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(bottom: 40),
      //   child: FloatingActionButton(
      //       heroTag: Text("btn2"),
      //       mini: true,
      //       child: Icon(Icons.add),
      //       onPressed: () async {
      //         Navigator.pushNamed(context, '/creategroup',
      //             arguments: groupListProvider);
      //       }),
      // ),
    );
  }
}
