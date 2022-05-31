import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/callScreens/StreamBar.dart';
import 'package:flutter_one2many/src/Screeens/home/CustomAppBar.dart';
import 'package:flutter_one2many/src/Screeens/home/NoChatScreen.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/Screeens/splash/splash.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/models/GroupModel.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../core/models/contact.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/contact_provider.dart';
import '../../core/providers/groupListProvider.dart';

bool isOneToOne = false;

class ContactListScreen extends StatefulWidget {
  final bool activeCall;
  final mcToken;
  final handlePress;
  final funct;
  final ContactProvider state;
  final MainProvider mainProvider;
  final GroupListProvider groupListProvider;
  final refreshList;
  const ContactListScreen(
      {Key key,
      this.funct,
      this.mainProvider,
      this.handlePress,
      this.mcToken,
      this.activeCall,
      this.groupListProvider,
      this.state,
      this.refreshList})
      : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}
List<Contact> selectedContacts = [];
class _ContactListScreenState extends State<ContactListScreen> {
  ContactProvider contactProvider;
  GroupListProvider groupListProvider;
  AuthProvider authProvider;
  MainProvider mainProvider;
  int count = 0;
  var changingvaalue;
  
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<Contact> _filteredList = [];
  bool notmatched = false;
  Emitter emitter;
  GlobalKey<ScaffoldState> scaffoldKey;
  bool loading = false;

  //bool isLoading = false;
  @override
  void initState() {
    // widget.callbackfunction();
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    //contactProvider.getContacts(authProvider.getUser.auth_token);
    mainProvider = Provider.of<MainProvider>(context, listen: false);
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    emitter = Emitter.instance;
  }

  onSearch(value) {
    List temp;

    temp = widget.state.contactList.users.where((element) {
      return element.full_name.toLowerCase().startsWith(value.toLowerCase());
    }).toList();

    setState(() {
      if (temp.isEmpty) {
        notmatched = true;
        print("Here in true not matched");
      } else {
        print("Here in false matched");
        notmatched = false;
        _filteredList = temp;
      }
    });
    print("this is filtered list ${_filteredList[0].full_name}  ");
  }

  Future buildShowDialog(
      BuildContext context, String mesg, String errorMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            Future.delayed(Duration(seconds: 2), () {
              // Navigator.of(context).pop(true);
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
    return Consumer3<ContactProvider, AuthProvider, MainProvider>(builder:
        (context, contactListProvider, authProvider, mainProvider, child) {
      if (widget.state.contactState == ContactStates.Loading)
        return SplashScreen();
      else if (widget.state.contactState == ContactStates.Success) {
        if (widget.state.contactList.users.isEmpty)
        {  return NoChatScreen(
                      emitter: emitter,
                      groupListProvider: groupListProvider,
                      presentCheck: false,
                    );}
                  else
                    return GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFous = FocusScope.of(context);
                          if (!currentFous.hasPrimaryFocus) {
                            currentFous.unfocus();
                          }
                        },
                        child: Scaffold(
                          appBar: CustomAppBar(
                              handlePress: widget.handlePress,
                              mainProvider: widget.mainProvider,
                              lead: true,
                              ischatscreen: false,
                              isPublicBroadcast: false,
                              title: "New Chat",
                              succeedingIcon: '',
                              groupListProvider: groupListProvider),
                          body: RefreshIndicator(
                            onRefresh: widget.refreshList,
                            child: SafeArea(
                                child: Column(
                              children: [
                                widget.activeCall
                                    ? meidaType == "video" && typeOfCall != "one_to_many"
                                        ? StreamBar(
                                            mainProvider: widget.mainProvider,
                                            groupListProvider: groupListProvider,
                                            isActive: true,
                                            meidaType: meidaType,
                                          )
                                        : (typeOfCall == "one_to_many")
                                            ? GestureDetector(
                                                onTap: () {
                                                  widget.mainProvider.callStart();
                                                },
                                                child: new Container(
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    color: Colors.green,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(
                                                          21, 0, 11, 0),
                                                      child: Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(ispublicbroadcast ||
                                                                  isDialer == true
                                                              ? "You are sharing you screen"
                                                              : "You are viewing screen currently"),
                                                          Spacer(),
                                                          Text(
                                                              "${groupListProvider.timerDuration}"),
                                                        ],
                                                      ),
                                                    )),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  widget.mainProvider.callStart();
                                                },
                                                child: new Container(
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    color: Colors.green,
                                                    child: Text(
                                                        "${groupListProvider.timerDuration}")),
                                              )
                                    : SizedBox(height: 0),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 21, right: 21),
                                  child: TextFormField(
          //textAlign: TextAlign.center,
                                    controller: _searchController,
                                    onChanged: (value) {
                                      onSearch(value);
                                    },
                                    validator: (value) =>
                                        value.isEmpty ? "Field cannot be empty." : null,
                                    decoration: InputDecoration(
                                      fillColor: refreshTextColor,
                                      filled: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SvgPicture.asset(
                                          'assets/SearchIcon.svg',
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: searchbarContainerColor)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: searchbarContainerColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(5)),
                                          borderSide:
                                              BorderSide(color: searchbarContainerColor)),
                                      hintText: "Search",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: searchTextColor,
                                          fontFamily: secondaryFontFamily),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    print("in gesture detector");
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 13,
                                            right: 13,
                                          ),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/GroupChatIcon.svg'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // if (!isInternetConnect) {
                                            //   widget.mainProvider.noInternet();
                                            // } else {
                                            if (strArr.last == "CreateIndividualGroup") {
                                              widget.mainProvider.createGroupChatScreen();
                                              // widget
                                              //     .handlePress(HomeStatus.CreateGroupChat);
                                              strArr.remove("CreateIndividualGroup");
                                            }
                                            if (strArr.last ==
                                                "CreateIndividualGroupActiveCall") {
                                              print(
                                                  "here in back ${widget.mainProvider}");
          
                                              widget.mainProvider.createGroupChatScreen();
                                              strArr.remove(
                                                  "CreateIndividualGroupActiveCall");
                                            }
                                            // }
                                            //else {
                                            //   widget
                                            //       .handlePress(ListStatus.CreateGroupChat);
          
                                            // }
                                            // widget.handlePress(ListStatus.CreateGroupChat);
                                            //   CreateGroupChatIndex
                                            // Navigator.pushNamed(context, '/createGroup',
                                            //     arguments: {
                                            //       "groupListProvider": groupListProvider,
                                            //       "funct": widget.funct
                                            //     });
                                          },
                                          child: SizedBox(
                                            width: 236,
                                            child: Text(
                                              "Add Group Chat",
                                              style: TextStyle(
                                                color: addGroupChatColor,
                                                fontSize: 16,
                                                fontFamily: primaryFontFamily,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 370,
                                  child: Divider(
                                    thickness: 1,
                                    color: listdividerColor,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text("Contacts",
                                        style: TextStyle(
                                            color: contactColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: secondaryFontFamily)),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Expanded(
                                  child: Scrollbar(
                                    child: notmatched == true
                                        ? Text("No data Found")
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            //  padding: const EdgeInsets.only(top: 5),
                                            itemCount: _searchController.text.isEmpty
                                                ? widget.state.contactList.users.length
                                                : _filteredList.length,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              var test = _searchController.text.isEmpty
                                                  ? widget.state.contactList.users[index]
                                                  : _filteredList[index];
                                              var groupIndex = groupListProvider
                                                  .groupList.groups
                                                  .indexWhere((element) =>
                                                      element.group_title ==
                                                      authProvider.getUser.full_name +
                                                          test.full_name);
          
                                              return Column(
                                                children: [
                                                  ListTile(
                                                      // onTap: () {
                                                      //   if (_selectedContacts.indexWhere(
                                                      //           (contact) =>
                                                      //               contact.user_id ==
                                                      //               element.user_id) !=
                                                      //       -1) {
                                                      //     setState(() {
                                                      //       _selectedContacts.remove(element);
                                                      //     });
                                                      //   } else {
                                                      //     setState(() {
                                                      //       _selectedContacts.add(element);
                                                      //     });
                                                      //   }
                                                      // },
                                                      leading: Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(8),
                                                        ),
                                                        child: SvgPicture.asset(
                                                            'assets/User.svg'),
                                                      ),
                                                      title: Text(
                                                        "${test.full_name}",
                                                        // "hello",
                                                        style: TextStyle(
                                                          color: contactNameColor,
                                                          fontSize: 16,
                                                          fontFamily: primaryFontFamily,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      trailing: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              onTap: widget
                                                                          .groupListProvider
                                                                          .callprogress ==
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
                                                                              print(
                                                                                  "onTap called.");
          
                                                                              //   .groupList.groups[widget.index];
                                                                              widget.funct(
                                                                                  toOne2One: [
                                                                                    test.ref_id
                                                                                  ],
                                                                                  mtype: CallMediaType
                                                                                      .audio,
                                                                                  callType:
                                                                                      CAllType
                                                                                          .one2one,
                                                                                  sessionType:
                                                                                      SessionType.call);
          
                                                                              // signalingClient
                                                                              //     .startCallonetoone(
                                                                              //         mcToken:
                                                                              //             widget.mcToken,
                                                                              //         from: authProvider
                                                                              //             .getUser.ref_id,
                                                                              //         to: [test.ref_id],
                                                                              //         meidaType:
                                                                              //             CallMediaType
                                                                              //                 .audio,
                                                                              //         callType: CAllType
                                                                              //             .one2one,
                                                                              //         sessionType:
                                                                              //             SessionType
                                                                              //                 .call);
                                                                              // widget.funct(
                                                                              //     [test.ref_id],
                                                                              //     CallMediaType.audio,
                                                                              //     CAllType.one2one,
                                                                              //     SessionType.call);
                                                                              setState(
                                                                                  () {
                                                                                callTo = test
                                                                                    .full_name;
                                                                                meidaType =
                                                                                    CallMediaType
                                                                                        .audio;
                                                                                isOneToOne =
                                                                                    true;
          
                                                                                print(
                                                                                    "this is callTo $callTo");
                                                                              });
                                                                              iscalloneto1 =
                                                                                  true;
                                                                              print(
                                                                                  "TJIS IS WIDGET>CALL DDFDD ${widget.mainProvider}");
                                                                              widget
                                                                                  .mainProvider
                                                                                  .callDial();
                                                                              //  callProvider.callDial();
                                                                              print(
                                                                                  "three dot icon pressed");
                                                                              callTo = test
                                                                                  .full_name
                                                                                  .toString();
                                                                              // widget.funct([test.ref_id.toString()], CallMediaType.audio,
                                                                              //       CAllType.one2one, SessionType.call);
                                                                            },
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    right: 15),
                                                                child: SvgPicture.asset(
                                                                    'assets/call.svg'),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: widget
                                                                          .groupListProvider
                                                                          .callprogress ==
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
                                                                              print(
                                                                                  "onTap called.");
          
                                                                              widget.funct(
                                                                                  toOne2One: [
                                                                                    test.ref_id
                                                                                  ],
                                                                                  mtype: CallMediaType
                                                                                      .video,
                                                                                  callType:
                                                                                      CAllType
                                                                                          .one2one,
                                                                                  sessionType:
                                                                                      SessionType.call);
          
                                                                              // signalingClient
                                                                              //     .startCallonetoone(
                                                                              //         mcToken:
                                                                              //             widget.mcToken,
                                                                              //         from: authProvider
                                                                              //             .getUser.ref_id,
                                                                              //         to: [test.ref_id],
                                                                              //         meidaType:
                                                                              //             CallMediaType
                                                                              //                 .video,
                                                                              //         callType: CAllType
                                                                              //             .one2one,
                                                                              //         sessionType:
                                                                              //             SessionType
                                                                              //                 .call);
                                                                              // _startCall(
                                                                              //     [test.ref_id],
                                                                              //     CallMediaType.video,
                                                                              //     CAllType.one2one,
                                                                              //     SessionType.call);
                                                                              // setState(() {
                                                                              //   callTo = test.full_name;
                                                                              //   meidaType =
                                                                              //       CallMediaType.video;
                                                                              //   print(
                                                                              //       "this is callTo $callTo");
                                                                              // });
                                                                              iscalloneto1 =
                                                                                  true;
                                                                              setState(
                                                                                  () {
                                                                                callTo = test
                                                                                    .full_name;
                                                                                meidaType =
                                                                                    CallMediaType
                                                                                        .video;
          
                                                                                print(
                                                                                    "this is callTo $callTo");
                                                                              });
                                                                              print(
                                                                                  "TJIS IS WIDGET>CALL DDFDD ${widget.mainProvider}");
                                                                              widget
                                                                                  .mainProvider
                                                                                  .callDial();
                                                                              print(
                                                                                  "three dot icon pressed");
                                                                              callTo = test
                                                                                  .full_name
                                                                                  .toString();
                                                                              // widget.funct([test.ref_id.toString()], CallMediaType.video,
                                                                              //       CAllType.one2one, SessionType.call);
                                                                            },
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    right: 16),
                                                                child: SvgPicture.asset(
                                                                    'assets/videocallicon.svg'),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                                onTap: !isInternetConnect
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
                                                                    : loading == false
                                                                        ? () async {
                                                                            groupListProvider
                                                                                .handleCreateChatState();
                                                                            setState(() {
                                                                              loading =
                                                                                  true;
                                                                            });
                                                                            selectedContacts
                                                                                .add(
                                                                                    test);
                                                                            print(
                                                                                "the selected contacts:${test.full_name}");
                                                                            var res = await widget.state.createGroup(
                                                                                authProvider
                                                                                        .getUser
                                                                                        .full_name +
                                                                                    selectedContacts[0]
                                                                                        .full_name,
                                                                                selectedContacts,
                                                                                authProvider
                                                                                    .getUser
                                                                                    .auth_token);
                                                                            // var getGroups=await
          
                                                                            print(
                                                                                "this is already created index ${res["is_already_created"]}");
                                                                            GroupModel
                                                                                groupModel =
                                                                                GroupModel
                                                                                    .fromJson(
                                                                                        res["group"]);
                                                                            print(
                                                                                "this is group index $groupIndex");
                                                                            print(
                                                                                "this is response of createGroup ${groupModel.participants[0].full_name}, ${groupModel.participants[1].full_name}");
          
                                                                            int channelIndex =
                                                                                0;
                                                                            if (res[
                                                                                "is_already_created"]) {
                                                                              channelIndex = groupListProvider
                                                                                  .groupList
                                                                                  .groups
                                                                                  .indexWhere((element) =>
                                                                                      element.channel_key ==
                                                                                      res["group"]["channel_key"]);
          
                                                                              print(
                                                                                  "this is already created index $channelIndex");
                                                                            } else {
                                                                              groupListProvider
                                                                                  .addGroup(
                                                                                      groupModel);
                                                                              
                                                                            }
          
                                                                            publishMessage(
                                                                                key,
                                                                                channelname,
                                                                                sendmessage) {
                                                                              print(
                                                                                  "The key:$key....$channelname...$sendmessage");
                                                                              emitter.publish(
                                                                                  key,
                                                                                  channelname,
                                                                                  sendmessage);
                                                                            }
          
                                                                            if (res[
                                                                                "is_already_created"]) {
                                                                              widget
                                                                                  .mainProvider
                                                                                  .chatScreen(
                                                                                      index:
                                                                                          channelIndex);
                                                                            } else {
                                                                              widget
                                                                                  .mainProvider
                                                                                  .chatScreen(
                                                                                      index:
                                                                                          0);
                                                                            }
          
                                                                            selectedContacts
                                                                                .clear();
                                                                            groupListProvider
                                                                                .handleCreateChatState();
                                                                            setState(() {
                                                                              loading =
                                                                                  false;
                                                                            });
                                                                          }
                                                                        : () {},
                                                                child: Container(
                                                                  margin: EdgeInsets.only(
                                                                      right: 15),
                                                                  child: SvgPicture.asset(
                                                                      'assets/messageicon.svg'),
                                                                )),
                                                          ]))
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Divider(
                                                  thickness: 1,
                                                  color: listdividerColor,
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ));
                } else {
                  return Scaffold(
                    backgroundColor: chatRoomBackgroundColor,
                    appBar: CustomAppBar(
                      mainProvider: mainProvider,
                      groupListProvider: groupListProvider,
                      title: "New Chat",
                      lead: true,
                      succeedingIcon: '',
                      ischatscreen: false,
                      isPublicBroadcast: false,
                      handlePress: widget.handlePress,
                    ),
                    body: Center(
                        child: Text(
                      "${widget.state.errorMsg}",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                  );
                }
              });
            }
          }
          
     
