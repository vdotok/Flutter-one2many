import 'package:flutter/material.dart';
import 'package:flutter_onetomany/constant.dart';
import 'package:flutter_onetomany/src/GroupListScreen/creatingurl.dart';
import 'package:flutter_onetomany/src/core/models/GroupListModel.dart';
import 'package:flutter_onetomany/src/core/providers/groupListProvider.dart';
import 'package:flutter_onetomany/src/home/home.dart';


class StartBroadcastPopUp extends StatefulWidget {
final startCall;

  const StartBroadcastPopUp({this.startCall});

  _StartBroadcastPopUpState createState() => _StartBroadcastPopUpState();
}

class _StartBroadcastPopUpState extends State<StartBroadcastPopUp> {
  GroupListProvider _groupListProvider;
  bool loading = false;
  @override
  void initState() {
   
  }

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
              Container(
                  height: 278,
                  width: 319,
                  child: 
                  Center(
                    child: FlatButton(
                      color:Colors.green,
       onPressed:  (){

         ispublicbroadcast=true;
  Navigator.pop(context);
           GroupListModel model;
           if(broadcasttype=="camera"){
             print(" iam here in pop up camera");
             widget.startCall(
                                           model,
                                                    MediaType.video,
                                                    CAllType.one2many,
                                                    SessionType.call
                                            );
           }
           else{
              print(" iam here in pop up screen");
               widget.startCall(
                                           model,
                                                    MediaType.video,
                                                    CAllType.one2many,
                                                    SessionType.screen
                                            );
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
            child: Text('START BROADCAST', style: TextStyle(
                color:Colors.white
              )
            ),
           
            shape: RoundedRectangleBorder(side: BorderSide(
              color: Colors.green,
              width: 3,
              style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(10)),
          ),
                  ), )
                 
            ])),
      );
    }));
  }
}