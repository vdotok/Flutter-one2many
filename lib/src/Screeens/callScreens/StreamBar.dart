import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/Screeens/home/streams/remoteStream.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_one2many/src/grouplist/GroupListScreen.dart';
import 'package:flutter_svg/svg.dart';

class StreamBar extends StatefulWidget {
  final GroupListProvider groupListProvider;
  final MainProvider mainProvider;
  final meidaType;
  final bool isActive;
  final orientation;

  const StreamBar(
      {Key key,
      this.groupListProvider,
      this.meidaType,
      this.mainProvider,
      this.isActive,
      this.orientation})
      : super(key: key);
  @override
  _StreamBarState createState() => _StreamBarState();
}

class _StreamBarState extends State<StreamBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: widget.meidaType == "video" && typeOfCall != "one_to_many"
            ? Container(
                color: widget.isActive ? backgroundAudioCallDark : null,
                padding: widget.isActive
                    ? EdgeInsets.symmetric(horizontal: 15, vertical: 19)
                    : EdgeInsets.symmetric(horizontal: 10),
                height: (widget.mainProvider.homeStatus == HomeStatus.CallStart)
                    ? widget.orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.height / 1.5
                        : widget.isActive
                            ? 138
                            : 100
                    : widget.isActive
                        ? 138
                        : 100,
                //MediaQuery.of(context).size.height,

                width: (widget.mainProvider.homeStatus == HomeStatus.CallStart)
                    ? widget.orientation == Orientation.landscape
                        ? widget.isActive
                            ? 138
                            : 100
                        : MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width,
                //,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection:
                      (widget.mainProvider.homeStatus == HomeStatus.CallStart)
                          ? widget.orientation == Orientation.landscape
                              ? Axis.vertical
                              : Axis.horizontal
                          : Axis.horizontal,
                  //shrinkWrap: true,
                  itemCount: rendererListWithRefID.length,
                  //widget.mainProvider.rendererListWithRefID.length,
                  itemBuilder: (context, index) {
                    print("THIS IS USERINDEX ${rendererListWithRefID.length}");

                    //print("THIS IS USERINDEX $userIndex");
                    return Container(
                      padding: (widget.mainProvider.homeStatus ==
                              HomeStatus.CallStart)
                          ? widget.orientation == Orientation.landscape
                              ? EdgeInsets.only(bottom: 8)
                              : EdgeInsets.only(right: 8)
                          : EdgeInsets.only(right: 8),
                      height: 100,
                      width: 80.0,
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(16.0))),
                      child: Stack(
                        children: [
                          Container(
                            child: rendererListWithRefID[index]
                                        ["remoteVideoFlag"] ==
                                    1
                                ? RemoteStream(
                                    remoteRenderer: rendererListWithRefID[index]
                                        ["rtcVideoRenderer"],
                                  )
                                : Container(
                                    width: 80.0,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(16.0)),
                                        color: backgroundAudioCallLight),
                                    child: Container(
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/userIconCall.svg',
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                forLargStream = rendererListWithRefID[index];
                              });
                              print(
                                  "Call positioned gesture detector pressed from chat screen");
                              widget.groupListProvider
                                  .handlBacktoGroupList(listIndex);
                              widget.mainProvider.callStart();
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            //      : (typeOfCall=="one_to_many")?

            //       GestureDetector(
            //           onTap: () {
            //              widget.mainProvider.callStart();
            //           },
            //           child: new Container(
            //               height: 40,
            //               alignment: Alignment.center,
            //               color: Colors.green,
            //               child: Padding(
            //                 padding: const EdgeInsets.fromLTRB(21,0,11,0),
            //                 child: Row(
            //                  // mainAxisAlignment: MainAxisAlignment.center,
            //                 // crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                        Text( ispublicbroadcast || isDDialer==true?"You are sharing you screen":"You are viewing screen currently"),
            //                        Spacer(),
            //                     Text("${widget.groupListProvider.timerDuration}"),
            //                   ],
            //                 ),
            //               )),

            // ):
            //      GestureDetector(
            //           onTap: () {
            //              widget.mainProvider.callStart();
            //           },
            //           child: new Container(
            //               height: 40,
            //               alignment: Alignment.center,
            //               color: Colors.green,
            //               child: Text("${widget.groupListProvider.timerDuration}")),

            // )
            : Container());
  }
}
