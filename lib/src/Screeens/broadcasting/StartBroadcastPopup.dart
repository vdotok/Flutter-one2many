import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/models/GroupListModel.dart';
import 'package:flutter_one2many/src/core/models/GroupModel.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartBroadcastPopUp extends StatefulWidget {
  final startCall;
  final to;
  const StartBroadcastPopUp({this.startCall, this.to});

  _StartBroadcastPopUpState createState() => _StartBroadcastPopUpState();
}

class _StartBroadcastPopUpState extends State<StartBroadcastPopUp> {
  GroupListProvider _groupListProvider;
  bool loading = false;
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    print("i am here startbroadcast popup");

    return GestureDetector(onTap: () {
      FocusScopeNode currentFous = FocusScope.of(context);
      if (!currentFous.hasPrimaryFocus) {
        currentFous.unfocus();
      }
    }, child: StatefulBuilder(builder: (context, setState) {
      return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 0,
                actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 19.75, 23.99, 0.0),
                child: GestureDetector(
                  child: SvgPicture.asset(
                    'assets/close.svg',
                  ),
                  onTap: () {
                    // setState(() {
                    //   isAppAudiobuttonSelected = false;
                    //   iscamerabuttonSelected = false;
                    //   ismicAudiobuttonSelected = false;
                    // });

                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 75, 0, 111.22),
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor:Colors.green,
                       shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.green,
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)),
                    ),
                  
                    onPressed: () {
                      groupBroadcast = widget.to == null ? false : true;
                      ispublicbroadcast = widget.to == null ? true : false;
                      Navigator.pop(context);
                      GroupModel model;
                      if (broadcasttype == "camera") {
                        print(" iam here in pop up camera");
                        widget.to == null
                            ? widget.startCall(
                                to: model,
                                mtype: MediaType.videocall,
                                callType: CAllType.one2many,
                                sessionType: SessionType.call)
                            : widget.startCall(
                                to: widget.to,
                                mtype: MediaType.videocall,
                                callType: CAllType.one2many,
                                sessionType: SessionType.call);
                      } else {
                        print("i am here in pop up screen $model ${widget.to}");
                        widget.to == null
                            ? widget.startCall(
                                to: model,
                                mtype: MediaType.videocall,
                                callType: CAllType.one2many,
                                sessionType: SessionType.screen)
                            : widget.startCall(
                                to: widget.to,
                                mtype: MediaType.videocall,
                                callType: CAllType.one2many,
                                sessionType: SessionType.screen);
                      }

                      // showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return CreatingUrlPopUp(
                      //                   startCall: widget.startCall,
                      //                  // broadcastObject: broadcastObject,
                      //                   );
                      //            });
                      //
                    },
                    child: Text('START BROADCAST',
                        style: TextStyle(color: Colors.white)),
                 
                  ),
                ),
              )
            ])),
      );
    }));
  }
}
