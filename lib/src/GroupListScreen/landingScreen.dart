import 'package:flutter/material.dart';
import 'package:flutter_onetomany/constant.dart';
import 'package:flutter_onetomany/src/GroupListScreen/startbroadcastpopup.dart';
import 'package:flutter_onetomany/src/core/models/GroupListModel.dart';
import 'package:flutter_onetomany/src/core/providers/groupListProvider.dart';


class LandingScreen extends StatefulWidget {
  GroupListProvider grouplistprovider;
    final startCall;
  LandingScreen({this.grouplistprovider, this.startCall});
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
 int broadcast;
 bool isAppAudiobuttonSelected=false;
bool ismicAudiobuttonSelected=false;
bool iscamerabuttonSelected=false;
void _handleGenderChange(int value) {
  setState(() { broadcast= value;});

  print("selected gender is $value");}


  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body:
      Container(
      child: Column(
        children: [
          SizedBox(height:50),
          Row(

children: [

Radio<int>(

value: 0,

groupValue: broadcast,

onChanged: _handleGenderChange,

),

Text("Public BroadCast"),
SizedBox(width:30),
Radio<int>(

value: 1,

groupValue: broadcast,

onChanged: _handleGenderChange,

),

Text("Group Broadcast"),
],

),
SizedBox(height:70),
Container(
  width:265,height:70,
  decoration: BoxDecoration(
        color: isAppAudiobuttonSelected?Colors.yellow:Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))
   ),
  child:   FlatButton(
            onPressed: (){
             setState(() {
               isAppAudiobuttonSelected=! isAppAudiobuttonSelected;
             });
            },
            child: Text('SCREEN SHARING WITH APP AUDIO', style: TextStyle(
                color: screensharecolor
              )
            ),
            textColor: Colors.green,
            shape: RoundedRectangleBorder(side: BorderSide(
              color: screensharecolor,
              width: 3,
              style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(5)),
          ),
),
SizedBox(height:30),
Container(
  width:265,height:70,
  decoration: BoxDecoration(
      color: ismicAudiobuttonSelected?Colors.yellow:Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))
   ),
  child:   FlatButton(
             onPressed: (){
             setState(() {
              ismicAudiobuttonSelected=!ismicAudiobuttonSelected;
             });
            },
            child: Text('SCREEN SHARING WITH MIC AUDIO', style: TextStyle(
                color: screensharecolor
              )
            ),
            textColor: Colors.green,
            shape: RoundedRectangleBorder(side: BorderSide(
              color: screensharecolor,
              width: 3,
              style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(5)),
          ),
),
SizedBox(height:30),
Container(
  decoration: BoxDecoration(
        color: iscamerabuttonSelected?Colors.yellow:Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))
   ),
  width:265,height:70,
  child:   FlatButton(
              onPressed: (){
             setState(() {
               iscamerabuttonSelected=!iscamerabuttonSelected;
             });
            },
            child: Text('CAMERA', style: TextStyle(
                color: screensharecolor
              )
            ),
            textColor: Colors.green,
            shape: RoundedRectangleBorder(side: BorderSide(
              color: screensharecolor,
              width: 3,
              style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(5)),
          ),
),
SizedBox(height:30),
Container(
   width:115,height:35,
  
  decoration: BoxDecoration(
        color:  isAppAudiobuttonSelected?Colors.green:ismicAudiobuttonSelected?Colors.green:iscamerabuttonSelected?Colors.green:Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10))
   ),
  child:   FlatButton(
       onPressed:       isAppAudiobuttonSelected ||  ismicAudiobuttonSelected   || iscamerabuttonSelected?(){
               // widget.grouplistprovider.handleGroupListState(ListStatus.Scussess);
               if(!isAppAudiobuttonSelected && !ismicAudiobuttonSelected && iscamerabuttonSelected && broadcast==0)
               {
                 print("i am here in public camera broadcast ");
                 showDialog(
            context: context,
            builder: (BuildContext context) {
              return StartBroadcastPopUp(startCall:widget.startCall);
            });
                
              //  GroupListModel model;
              //   widget.startCall(
              //                              model,
              //                                       MediaType.video,
              //                                       CAllType.one2many,
              //                                       SessionType.call
              //                               );
               }
               else if(!isAppAudiobuttonSelected && !ismicAudiobuttonSelected && iscamerabuttonSelected && broadcast==1){
                     widget.grouplistprovider.handleGroupListState(ListStatus.Scussess);
               }
               else{
                 print("i am here in else");
               }
            }:null,
            child: Text('Continue', style: TextStyle(
                color:Colors.white
              )
            ),
           
            // shape: RoundedRectangleBorder(side: BorderSide(
            //  // color: screensharecolor,
            //   width: 3,
            //   style: BorderStyle.solid
            // ), borderRadius: BorderRadius.circular(30)),
          ),
)
        ],
      ),
      )
    );
  }
  
}