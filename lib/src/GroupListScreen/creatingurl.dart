import 'package:flutter/material.dart';
import 'package:flutter_onetomany/constant.dart';
import 'package:flutter_onetomany/src/core/models/GroupListModel.dart';
import 'package:flutter_onetomany/src/core/providers/groupListProvider.dart';
import 'package:flutter_onetomany/src/home/home.dart';


class CreatingUrlPopUp extends StatefulWidget {
final startCall;

  const CreatingUrlPopUp({this.startCall});

  _CreatingUrlPopUpState createState() => _CreatingUrlPopUpState();
}

class _CreatingUrlPopUpState extends State<CreatingUrlPopUp> {
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
                    child:
                      
         Column(
           children: [
             SizedBox(height:80),
              Text("Creating your URL..."),
              SizedBox(height:30),
             Padding(
               padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
               child: LinearProgressIndicator(),
             ),
            
           ],
         ),
                    //Text("Creating your url")
      //               child: FlatButton(
      //                 color:Colors.green,
      //  onPressed:  (){
         
      //    ispublicbroadcast=true;

      //      GroupListModel model;
      //      if(broadcasttype=="camera"){
      //        print(" iam here in pop up camera");
      //        widget.startCall(
      //                                      model,
      //                                               MediaType.video,
      //                                               CAllType.one2many,
      //                                               SessionType.call
      //                                       );
      //      }
      //      else{
      //         print(" iam here in pop up screen");
      //          widget.startCall(
      //                                      model,
      //                                               MediaType.video,
      //                                               CAllType.one2many,
      //                                               SessionType.screen
      //                                       );
      //      }
                
      //                                       Navigator.pop(context);
        
      //  },
      //       child: Text('START BROADCAST', style: TextStyle(
      //           color:Colors.white
      //         )
      //       ),
           
      //       shape: RoundedRectangleBorder(side: BorderSide(
      //         color: Colors.green,
      //         width: 3,
      //         style: BorderStyle.solid
      //       ), borderRadius: BorderRadius.circular(10)),
      //     ),
                  ), )
                 
            ])),
      );
    }));
  }
}
