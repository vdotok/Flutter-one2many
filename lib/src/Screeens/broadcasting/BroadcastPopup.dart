import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/broadcasting/StartBroadcastPopup.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart';

class BroadCastPopUp extends StatefulWidget {
  final startCall;
  final text;
  final to;
  const BroadCastPopUp({Key key, this.startCall, this.text, this.to})
      : super(key: key);
  @override
  _BroadCastPopUpState createState() => _BroadCastPopUpState();
}

class _BroadCastPopUpState extends State<BroadCastPopUp> {
  bool isMobileBrowser = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isMobileBrowser = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
  }

  @override
  Widget build(BuildContext context) {
    print("public broad");
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 0,
        //padding: const EdgeInsets.only(left:.0),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/close.svg',
                  ),
                  onTap: () {
                    setState(() {
                      isAppAudiobuttonSelected = false;
                      iscamerabuttonSelected = false;
                      ismicAudiobuttonSelected = false;
                    });

                    Navigator.pop(context);
                  },
                ),

                // IconButton(onPressed: (){}, icon: Icon(Icons.close)),
              ],
            ),
            Text(
              "${widget.text}",

              // textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 12,
                  color: blackColor,
                  fontFamily: primaryFontFamily,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 21),
            // this condition is for mobile browser
            isMobileBrowser
                ? Container()
                : Column(
                    children: [
                      Container(
                        width: 215,
                        height: 44,
                        //padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        decoration: BoxDecoration(
                            color: isAppAudiobuttonSelected
                                ? Colors.yellow
                                : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        //child:Text("hellp")
                        child: FlatButton(
                          onPressed: () {
                            print(
                                "here in screen share with app $isAppAudiobuttonSelected");
                            if (ismicAudiobuttonSelected) {
                              ismicAudiobuttonSelected =
                                  !ismicAudiobuttonSelected;
                            }
                            setState(() {
                              isAppAudiobuttonSelected =
                                  !isAppAudiobuttonSelected;
                            });
                          },
                          child: Text('SCREEN SHARING WITH APP AUDIO',
                              style: TextStyle(
                                  color: screensharecolor, fontSize: 10)),
                          textColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: screensharecolor,
                                  width: 3,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 215,
                        height: 44,
                        decoration: BoxDecoration(
                            color: ismicAudiobuttonSelected
                                ? Colors.yellow
                                : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: FlatButton(
                          onPressed: () {
                            if (isAppAudiobuttonSelected) {
                              isAppAudiobuttonSelected =
                                  !isAppAudiobuttonSelected;
                            }
                            setState(() {
                              ismicAudiobuttonSelected =
                                  !ismicAudiobuttonSelected;
                            });
                          },
                          child: Text('SCREEN SHARING WITH MIC AUDIO',
                              style: TextStyle(
                                  color: screensharecolor, fontSize: 10)),
                          textColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: screensharecolor,
                                  width: 3,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

            Container(
              decoration: BoxDecoration(
                  color: iscamerabuttonSelected ? Colors.yellow : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: 215,
              height: 44,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    iscamerabuttonSelected = !iscamerabuttonSelected;
                  });
                },
                child: Text('CAMERA',
                    style: TextStyle(color: screensharecolor, fontSize: 10)),
                textColor: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: screensharecolor,
                        width: 3,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            SizedBox(height: 26),
            Center(
              child: Container(
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
                                iscamerabuttonSelected) {
                              // broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": true, "micAudio": true ,};
                              print("i am here in public camera broadcast ");
                              broadcasttype = "camera";
                              isMultiSession = false;
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StartBroadcastPopUp(
                                        startCall: widget.startCall,
                                        to: widget.to != null
                                            ? widget.to
                                            : null);
                                  });
                            }

                            //case of group video call

                            //case of app audio with public broadcast
                            else if (isAppAudiobuttonSelected &&
                                !ismicAudiobuttonSelected &&
                                !iscamerabuttonSelected) {
                              broadcasttype = "appaudio";
                              isMultiSession = false;
                              //  broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": false, "micAudio": false,};
                              print("this is app audio with public broadcast");
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StartBroadcastPopUp(
                                        startCall: widget.startCall,
                                        to: widget.to != null ? widget.to : null
                                        // broadcastObject: broadcastObject,
                                        );
                                  });
                            }
                            //case of app audio with group broadcast

                            //case of mic audio with public broadcast
                            else if (!isAppAudiobuttonSelected &&
                                ismicAudiobuttonSelected &&
                                !iscamerabuttonSelected) {
                              broadcasttype = "micaudio";
                              isMultiSession = false;
                              //  broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": false, "micAudio": false,};
                              print("this is mic audio with public broadcast");
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StartBroadcastPopUp(
                                        startCall: widget.startCall,
                                        to: widget.to != null ? widget.to : null
                                        // broadcastObject: broadcastObject,
                                        );
                                  });
                              print("this is screen share with internal audio");
                            } else if (isAppAudiobuttonSelected &&
                                !ismicAudiobuttonSelected &&
                                iscamerabuttonSelected) {
                              broadcasttype = "appaudioandcamera";
                              isMultiSession = true;
                              //  broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": false, "micAudio": false,};
                              print(
                                  "this is app audio with camera public broadcast645");
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StartBroadcastPopUp(
                                        startCall: widget.startCall,
                                        to: widget.to != null ? widget.to : null
                                        // broadcastObject: broadcastObject,
                                        );
                                  });
                            } else if (!isAppAudiobuttonSelected &&
                                ismicAudiobuttonSelected &&
                                iscamerabuttonSelected) {
                              broadcasttype = "micaudioandcamera";
                              isMultiSession = true;
                              //  broadcastObject  = {"publicBroadcast": true, "sessionTypeCamera": false, "micAudio": false,};
                              print(
                                  "this is app audio with camera public broadcast888");
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StartBroadcastPopUp(
                                        startCall: widget.startCall,
                                        to: widget.to != null ? widget.to : null
                                        // broadcastObject: broadcastObject,
                                        );
                                  });
                            }
                            //case of mic audio with group broadcast

                            else {
                              print("i am here in else");
                            }
                          }
                        : null,
                    child:
                        Text('Continue', style: TextStyle(color: Colors.white)),
                  )),
            )
          ],
        ),
      );
    });
  }
}
