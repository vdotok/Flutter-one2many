import 'package:flutter/material.dart';
import 'package:flutter_onetomany/constant.dart';
import 'package:flutter_onetomany/src/GroupListScreen/startbroadcastpopup.dart';
import 'package:flutter_onetomany/src/core/models/GroupListModel.dart';
import 'package:flutter_onetomany/src/core/providers/auth.dart';
import 'package:flutter_onetomany/src/core/providers/groupListProvider.dart';
import 'package:flutter_onetomany/src/home/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
  bool isAppAudiobuttonSelected = false;
  bool ismicAudiobuttonSelected = false;
  bool iscamerabuttonSelected = false;

class LandingScreen extends StatefulWidget {
  GroupListProvider grouplistprovider;
  final startCall;
  AuthProvider authprovider;
  var registerRes;
  bool sockett;
  bool isdev;
  LandingScreen(
      {this.grouplistprovider,
      this.startCall,
      this.authprovider,
      this.registerRes,
      this.isdev,
      this.sockett});
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int broadcast;

  Map<String, bool> broadcastObject;
  void _handleGenderChange(int value) {
    setState(() {
      broadcast = value;
    });

    print("selected gender is $value");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              children: [
                Radio<int>(
                  value: 0,
                  groupValue: broadcast,
                  onChanged: _handleGenderChange,
                ),
                Text("Public BroadCast"),
                SizedBox(width: 30),
                Radio<int>(
                  value: 1,
                  groupValue: broadcast,
                  onChanged: _handleGenderChange,
                ),
                Text("Group Broadcast"),
              ],
            ),
            SizedBox(height: 70),
            Container(
              width: 265,
              height: 70,
              decoration: BoxDecoration(
                  color:
                      isAppAudiobuttonSelected ? Colors.yellow : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: FlatButton(
                onPressed: () {
                  if (ismicAudiobuttonSelected) {
                    ismicAudiobuttonSelected = !ismicAudiobuttonSelected;
                  }
                  setState(() {
                    isAppAudiobuttonSelected = !isAppAudiobuttonSelected;
                  });
                },
                child: Text('SCREEN SHARING WITH APP AUDIO',
                    style: TextStyle(color: screensharecolor)),
                textColor: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: screensharecolor,
                        width: 3,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 265,
              height: 70,
              decoration: BoxDecoration(
                  color:
                      ismicAudiobuttonSelected ? Colors.yellow : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: FlatButton(
                onPressed: () {
                  if (isAppAudiobuttonSelected) {
                    isAppAudiobuttonSelected = !isAppAudiobuttonSelected;
                  }
                  setState(() {
                    ismicAudiobuttonSelected = !ismicAudiobuttonSelected;
                  });
                },
                child: Text('SCREEN SHARING WITH MIC AUDIO',
                    style: TextStyle(color: screensharecolor)),
                textColor: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: screensharecolor,
                        width: 3,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                  color: iscamerabuttonSelected ? Colors.yellow : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: 265,
              height: 70,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    iscamerabuttonSelected = !iscamerabuttonSelected;
                  });
                },
                child:
                    Text('CAMERA', style: TextStyle(color: screensharecolor)),
                textColor: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: screensharecolor,
                        width: 3,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 115,
              height: 35,
              decoration: BoxDecoration(
                  color: isAppAudiobuttonSelected
                      ? Colors.green
                      : ismicAudiobuttonSelected
                          ? Colors.green
                          : iscamerabuttonSelected
                              ? Colors.green
                              : Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: FlatButton(
                onPressed: isAppAudiobuttonSelected ||
                        ismicAudiobuttonSelected ||
                        iscamerabuttonSelected
                    ? () {
                        //case of public video call
                        if (!isAppAudiobuttonSelected &&
                            !ismicAudiobuttonSelected &&
                            iscamerabuttonSelected &&
                            broadcast == 0) {
                          // broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": true, "micAudio": true ,};
                          print("i am here in public camera broadcast ");
                          broadcasttype = "camera";
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StartBroadcastPopUp(
                                  startCall: widget.startCall,
                                );
                              });
                        }
                        //case of group video call
                        else if (!isAppAudiobuttonSelected &&
                            !ismicAudiobuttonSelected &&
                            iscamerabuttonSelected &&
                            broadcast == 1) {
                          broadcasttype = "camera";
                          widget.grouplistprovider
                              .handleGroupListState(ListStatus.Scussess);
                        }
                        //case of app audio with public broadcast
                        else if (isAppAudiobuttonSelected &&
                            !ismicAudiobuttonSelected &&
                            !iscamerabuttonSelected &&
                            broadcast == 0) {
                          broadcasttype = "appaudio";
                          //  broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": false, "micAudio": false,};
                          print("this is app audio with public broadcast");
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StartBroadcastPopUp(
                                  startCall: widget.startCall,
                                  // broadcastObject: broadcastObject,
                                );
                              });
                        }
                        //case of app audio with group broadcast
                        else if (isAppAudiobuttonSelected &&
                            !ismicAudiobuttonSelected &&
                            !iscamerabuttonSelected &&
                            broadcast == 1) {
                          broadcasttype = "appaudio";
                          widget.grouplistprovider
                              .handleGroupListState(ListStatus.Scussess);
                          print("this is screen share with internal audio");
                        }
                        //case of mic audio with public broadcast
                        else if (!isAppAudiobuttonSelected &&
                            ismicAudiobuttonSelected &&
                            !iscamerabuttonSelected &&
                            broadcast == 0) {
                          broadcasttype = "micaudio";
                          //  broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": false, "micAudio": false,};
                          print("this is mic audio with public broadcast");
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StartBroadcastPopUp(
                                  startCall: widget.startCall,
                                  // broadcastObject: broadcastObject,
                                );
                              });
                          print("this is screen share with internal audio");
                        }
                        //case of mic audio with group broadcast
                        else if (!isAppAudiobuttonSelected &&
                            ismicAudiobuttonSelected &&
                            !iscamerabuttonSelected &&
                            broadcast == 1) {
                          broadcasttype = "micaudio";
                          widget.grouplistprovider
                              .handleGroupListState(ListStatus.Scussess);
                          print("this is screen share with internal audio");
                         } 
                       // else if (isAppAudiobuttonSelected &&
                        //     !ismicAudiobuttonSelected &&
                        //     iscamerabuttonSelected &&
                        //     broadcast == 1) {
                        //   broadcasttype = "appaudioandcamera";
                        //   widget.grouplistprovider
                        //       .handleGroupListState(ListStatus.Scussess);
                        //   print(
                        //       "this is screen share with app audio and camera");
                        // }
                        // // else if (isAppAudiobuttonSelected &&
                        // //     !ismicAudiobuttonSelected &&
                        // //     iscamerabuttonSelected &&
                        // //     broadcast == 0) {
                        // //   broadcasttype = "appaudioandcamera";
                        // //   showDialog(
                        // //       context: context,
                        // //       builder: (BuildContext context) {
                        // //         return StartBroadcastPopUp(
                        // //           startCall: widget.startCall,
                        // //           // broadcastObject: broadcastObject,
                        // //         );
                        // //       });
                        // //   print(
                        // //       "this is screen share with app audio and camera");
                        // // }
                        // else if (!isAppAudiobuttonSelected &&
                        //     ismicAudiobuttonSelected &&
                        //     iscamerabuttonSelected &&
                        //     broadcast == 1) {
                        //   broadcasttype = "micaudioandcamera";
                        //   widget.grouplistprovider
                        //       .handleGroupListState(ListStatus.Scussess);
                        //   print(
                        //       "this is screen share with app audio and camera");
                        // } 
                        else {
                          print("i am here in else");
                        }
                      }
                    : null,
                child: Text('Continue', style: TextStyle(color: Colors.white)),

                // shape: RoundedRectangleBorder(side: BorderSide(
                //  // color: screensharecolor,
                //   width: 3,
                //   style: BorderStyle.solid
                // ), borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 19),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: FlatButton(
                              onPressed: () {
                               if (isRegisteredAlready) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        isRegisteredAlready = false;
                      }

                                signalingClient
                                    .unRegister(widget.registerRes["mcToken"]);
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
                          Container(
                            height: 25,
                            width: 25,
                            child: SvgPicture.asset(
                              'assets/call.svg',
                              color: widget.sockett && widget.isdev
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ]),
                  ),
                  Container(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Text(widget.authprovider.getUser.full_name))
                ]))
          ],
        ),
      ),
    ));
  }
}
