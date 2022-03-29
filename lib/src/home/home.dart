import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onetomany/noContactsScreen.dart';
import 'package:flutter_onetomany/src/ContactListScreen/contactList.dart';
import 'package:flutter_onetomany/src/GroupListScreen/groupListScreen.dart';
import 'package:flutter_onetomany/src/GroupListScreen/landingScreen.dart';
import 'package:flutter_onetomany/src/common/customAppBar.dart';
import 'package:flutter_onetomany/src/core/config/config.dart';
import 'package:flutter_onetomany/src/core/models/GroupModel.dart';
import 'package:flutter_onetomany/src/core/models/contact.dart';
import 'package:flutter_onetomany/src/core/providers/groupListProvider.dart';
import 'package:flutter_onetomany/src/home/CreateGroupPopUp.dart';
import 'package:flutter_onetomany/src/home/remoteStream.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

import 'dart:io' show Platform;

import '../../constant.dart';
import '../../main.dart';
import '../core/models/contactList.dart';
import '../core/providers/auth.dart';
import '../core/providers/call_provider.dart';
import '../core/providers/contact_provider.dart';

String callTo = "";
String groupName="";
bool ispublicbroadcast = false;
String broadcasttype = "";
bool isDDialer = false;
String pressDuration = "";
bool remoteVideoFlag = true;
bool isDeviceConnected = false;
SignalingClient signalingClient = SignalingClient.instance..checkConnectivity();
bool enableCamera = true;
bool switchMute = true;
bool switchSpeaker = true;
RTCVideoRenderer localRenderer = new RTCVideoRenderer();
//RTCVideoRenderer remoteRenderer = new RTCVideoRenderer();
List<Map<String, dynamic>> rendererListWithRefID = [];
MediaStream local;
MediaStream remote;
bool islogout = false;
BuildContext popupcontext;
GlobalKey forsmallView = new GlobalKey();
GlobalKey forlargView = new GlobalKey();
GlobalKey forDialView = new GlobalKey();
bool groupnotmatched = false;

List _groupfilteredList = [];
List<Contact> _selectedContacts = [];
final _GroupListsearchController = new TextEditingController();

class Home extends StatefulWidget {
  // User user;
  // Home({this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool notmatched = false;
  bool isConnect = false;
  DateTime _time;
  DateTime _callTime;
  Timer _ticker;
  Timer _callticker;
  int count = 0;
  bool iscallAcceptedbyuser = false;
  var number;
  var nummm;
  double upstream;
  double downstream;
  bool sockett = true;
  bool isSocketregis = false;
  bool isTimer = false;
  bool isResumed = true;
  bool inPaused = false;
  bool isRinging = false;
  //bool isPushed = false;
  bool isInternetConnected = false;
  int participantcount = 0;
  String publicbroadcasturl = "";
  final _groupNameController = TextEditingController();
  GroupListProvider _groupListProvider;
  void _updateTimer() {
    final duration = DateTime.now().difference(_time);
    final newDuration = _formatDuration(duration);
    setState(() {
      pressDuration = newDuration;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (twoDigitHours == "00")
      return "$twoDigitMinutes:$twoDigitSeconds";
    else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    ;
  }

  // SignalingClient signalingClient = SignalingClient.instance;
  RTCPeerConnection _peerConnection;
  RTCPeerConnection _answerPeerConnection;
  MediaStream _localStream;
  bool isConnected = true;
  var registerRes;
  // bool isdev = true;
  String incomingfrom;
  // ContactBloc _contactBloc;
  // CallBloc _callBloc;
  // LoginBloc _loginBloc;
  CallProvider _callProvider;
  AuthProvider _auth;

  // String callTo = "";
  List _filteredList = [];
  bool iscalloneto1 = false;
  bool inCall = false;
  bool inInactive = false;
  bool onRemoteStream = false;
  final _searchController = new TextEditingController();
  List<int> vibrationList = [
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000
  ];
  String meidaType = MediaType.video;

  bool remoteAudioFlag = true;
  ContactProvider _contactProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // print('this is local $s');
  }

  @override
  void initState() {
    print("here in home init");
    // TODO: implement initState
    initRenderers();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // checkConnectivity();

    print("initilization");
    _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);

    _auth = Provider.of<AuthProvider>(context, listen: false);
    _contactProvider = Provider.of<ContactProvider>(context, listen: false);
    print("this is user data auth ${_auth.getUser}");
    _callProvider = Provider.of<CallProvider>(context, listen: false);

    _contactProvider.getContacts(_auth.getUser.auth_token);
    _groupListProvider.getGroupList(_auth.getUser.auth_token);
    // signalingClient.closeSocket();
    signalingClient.connect(project_id, _auth.completeAddress);

    //if(widget.state==true)
    signalingClient.onConnect = (res) {
      print("onConnect $res");
      setState(() {
        sockett = true;
      });
      print("here in init state register0");
      signalingClient.register(_auth.getUser.toJson(), project_id);
      // signalingClient.register(user);
    };

    signalingClient.unRegisterSuccessfullyCallBack = () {
      _auth.logout();
    };
    signalingClient.onAddparticpant = (paticipantcount) {
      print("this is participant count ffffff $paticipantcount");
      setState(() {
        participantcount = paticipantcount - 1;
      });
    };
    signalingClient.onError = (code, res) {
      print("onError $code $res");
      // if (isConnected == false) {
      //   setState(() {
      //     isConnected = false;
      //     //sockett = false;
      //   });
      // }
      // else{
      //   setState(() {
      //     isConnected = true;
      //     //sockett = false;
      //   });
      // }
      if (code == 1001 || code == 1002) {
        signalingClient.sendPing(registerRes["mctoken"]);

// if (isConnected && !isRegisteredAlready) {

// print("internet is connected $sockett");

// signalingClient.connect(project_id, _auth.completeAddress);

// } else {

setState(() {

sockett = false;





});
        setState(() {
          sockett = false;
          isConnected = false;
        });
      } else if (code == 401) {
        print("here in 401");
        setState(() {
          sockett = false;
          isConnected = false;
          final snackBar = SnackBar(content: Text('$res'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        if (_auth.loggedInStatus == Status.LoggedOut) {
        } else {
          setState(() {
            sockett = false;
          });
          if (isResumed) {
            // if (_auth.loggedInStatus == Status.LoggedOut) {
            // } else {
            if (isConnected && sockett == false) {
              print("i am in connect in 1005");
              signalingClient.connect(project_id, _auth.completeAddress);

              // signalingClient.register(_auth.getUser.toJson(), project_id);

              // sockett = true;
            } else {
              //  sockett = false;
            }
            //}
          } else {}
        }
      }
      // print(
      //     "hey i am here, this is localStream on Error ${local.id} remotestream ${remote.id}");
      // if (code == 1001 || code == 1002) {
      //   setState(() {
      //     sockett = false;
      //     isConnected = false;
      //     print("disconnected socket");
      //   });
      // } else {
      //   setState(() {
      //     sockett = false;
      //   });

      //   if (_auth.loggedInStatus == Status.LoggedOut) {
      //   } else {
      //     if (isConnected == true && sockett == false) {
      //       print("here in");
      //       signalingClient.connect(project_id, _auth.completeAddress);
      //       print("i am in connect in 1005");
      //       signalingClient.register(_auth.getUser.toJson(), project_id);
      //     }
      //   }
      // }
    };


    signalingClient.internetConnectivityCallBack = (mesg) {
      if (mesg == "Connected") {
        setState(() {
          isConnected = true;
          //  sockett = true;
        });

        showSnackbar("Internet Connected", whiteColor, Colors.green, false);
        //signalingClient.sendPing(registerRes["mcToken"]);

        if (sockett == false) {
          signalingClient.connect(project_id, _auth.completeAddress);
          print("I am in Re Reregister");
          remoteVideoFlag = true;
          print("here in init state register");
          // signalingClient.register(_auth.getUser.toJson(), project_id);
        }
        if (inCall == true) {
          isTimer = true;
        }
      } else {
        print("onError no internet connection");
        setState(() {
          isConnected = false;
          sockett = false;
        });

        showSnackbar("No Internet Connection", whiteColor, primaryColor, true);

        signalingClient.closeSocket();
      }
    };

    signalingClient.onRegister = (res) {
      print("onregister  $res");
      setState(() {
        registerRes = res;
        print("this is mc token in register ${registerRes["mcToken"]}");
      });
    };

    signalingClient.onLocalStream = (stream) async {
      print("i am here in local stream call");
      // initRenderers();
      print("this is local stream id ${stream.id}");
      setState(() {
        localRenderer.srcObject = stream;
        local = stream;
        print("this is after rendering local stream objectttt $local");
      });

      //   Map<String, dynamic> temp = {
      //   "rtcVideoRenderer": new RTCVideoRenderer(),
      //   "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
      //   "remoteAudioFlag": 1
      // };
      // await initRenderersRemote(temp["rtcVideoRenderer"]);
      // setState(() {
      //   temp["rtcVideoRenderer"].srcObject = stream;
      //    rendererListWithRefID.add(temp);
      // });
      //  print("i am here in local stream list length ....${rendererListWithRefID.length}");
    };
    signalingClient.onRemoteStream = (stream, refid) async {
      print("this is home page on remote stream ${stream.id} $refid");
      print("HI1 i am here in remote stream");
      Map<String, dynamic> temp = {
        "refID": refid,
        "rtcVideoRenderer": new RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
        "remoteAudioFlag": 1
      };
      await initRenderersRemote(temp["rtcVideoRenderer"]);
      setState(() {
        temp["rtcVideoRenderer"].srcObject = stream;
        rendererListWithRefID.add(temp);
      });
      // Map<String, dynamic> temp = {
      //   "refID": refid,
      //   "rtcVideoRenderer": new RTCVideoRenderer(),
      //   "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
      //   "remoteAudioFlag": 1
      // };
      //   await initRenderersRemote(temp["rtcVideoRenderer"]);
      //     rendererListWithRefID.add(temp);

      print("this is renderer list length ${rendererListWithRefID.length}");
      setState(() {
        // temp["rtcVideoRenderer"].srcObject = stream;
        //remoteRenderer.srcObject = stream;
        remote = stream;
        print("this is remote ${stream.id}");
        if (isTimer == false) {
          _time = DateTime.now();
          _callTime = DateTime.now();
        } else {
            if(_ticker!=null){
          _ticker.cancel();
             }

          _time = _callTime;
          isTimer = false;
        }
        _updateTimer();
        _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
        onRemoteStream = true;

        _callProvider.callStart();
      });
    };

    signalingClient.onTargetAlerting = () {
      setState(() {
        isRinging = true;
      });
    };

    signalingClient.onParticipantsLeft = (refID, boolFlag) async {
      print("call callback on call left by participant");

      // on participants left
      if (refID == _auth.getUser.ref_id) {
      } else {}
    };
    signalingClient.onReceiveCallFromUser = (
     mapData
    ) async {
      print("incomming call from user ${mapData["from"]}");
      startRinging();
    groupName=mapData["data"]["groupName"];
      setState(() {
        inCall = true;
        pressDuration = "";
        onRemoteStream = false;
        iscalloneto1 = false;
        incomingfrom = mapData["from"];
        meidaType = mapData["media_type"];
        switchMute = true;
        enableCamera = true;
        switchSpeaker = mapData["media_type"] == MediaType.audio ? true : false;
        remoteVideoFlag = true;
        remoteAudioFlag = true;
      });
      //here
      // _callBloc.add(CallReceiveEvent());
      _callProvider.callReceive();
    };
    signalingClient.onCallAcceptedByUser = () async {
      print("this is call accepted");
      inCall = true;
      iscallAcceptedbyuser = true;
      pressDuration = "";
      signalingClient.onCallStatsuploads = (uploadstats) {
        var nummm = uploadstats;
      };
      signalingClient.onCallstats = (timeStatsdownloads, timeStatsuploads) {
        print("NOT NULL  $timeStatsdownloads");
        number = timeStatsdownloads;
      };
      if (!ispublicbroadcast) {
        _callProvider.callStart();
      }
    };
    signalingClient.onCallHungUpByUser = (isLocal) {
      print("call decliend by other user");

      if (inPaused) {
        print("here in paused");
        signalingClient.closeSocket();
      }
      if (Platform.isIOS) {
        if (inInactive) {
          print("here in paused");
          signalingClient.closeSocket();
        }
      }
      if (_callticker != null) {
        _callticker.cancel();
      }
      //here
      // _callBloc.add(CallNewEvent());
      _callProvider.initial();
      disposeAllRenderer();
      setState(() {
        inCall = false;
        isRinging = false;
        iscallAcceptedbyuser = false;
        pressDuration = "";
        if (isDDialer == true) {
          localRenderer.srcObject = null;
        }
        isDDialer = false;
        // remoteRenderer.srcObject = null;
        // Navigator.pop(context);
      });
      stopRinging();
    };
    signalingClient.onCallDeclineByYou = () {
      print("this is oncalldeclinebyyou");
      //here
      // _callBloc.add(CallNewEvent());
      _callProvider.initial();
      setState(() {
        if (isDDialer == true) {
          localRenderer.srcObject = null;
        }
        //  remoteRenderer.srcObject = null;
      });
      stopRinging();
    };
    signalingClient.onCallBusyCallback = () {
      print("hey i am here");
      _callProvider.initial();
      final snackBar =
          SnackBar(content: Text('User is busy with another call.'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        if (isDDialer == true) {
          localRenderer.srcObject = null;
        }
        //  remoteRenderer.srcObject = null;
      });
    };
    signalingClient.onCallRejectedByUser = () {
      print("call decliend by other user");
      //here
      // _callBloc.add(CallNewEvent());
      stopRinging();
      _callProvider.initial();

      setState(() {
        if (isDDialer == true) {
          localRenderer.srcObject = null;
        }
        //  remoteRenderer.srcObject = null;
      });
    };
    signalingClient.onReceiveUrlCallback = (url) {
      print("this is url from signalˆng client $url");
      publicbroadcasturl = url;
      //   Navigator.pop(popupcontext);
      Navigator.pop(context);
      _callProvider.callStart();
    };
    signalingClient.onAudioVideoStateInfo = (audioFlag, videoFlag, refID) {
      setState(() {
        remoteVideoFlag = videoFlag == 0 ? false : true;
        remoteAudioFlag = audioFlag == 0 ? false : true;
      });
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("this is changeapplifecyclestate");
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        isResumed = true;
        inPaused = false;
        inInactive = false;
        if (_auth.loggedInStatus == Status.LoggedOut) {
        } else {
          print("this is variable for resume $sockett $isConnected");
          //     //signalingClient.sendPing();
          signalingClient.sendPing(registerRes["mcToken"]);
        }
        //   if (_auth.loggedInStatus == Status.LoggedOut) {
        //   } else {
        //     //signalingClient.sendPing();

        // print("here in resume");
        //       signalingClient.connect(project_id, _auth.completeAddress);
        //       signalingClient.register(_auth.getUser.toJson(), project_id);

        //   }

        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        inInactive = true;
        isResumed = false;
        inPaused = false;
        if (Platform.isIOS) {
          if (inCall == true) {
            print("incall true");
          } else {
            print("here in ininactive");
            signalingClient.closeSocket();
          }
        }
        //  isResumed = false;
        //  signalingClient.closeSocket();
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        inPaused = true;
        isResumed = false;
        inInactive = false;
        if (inCall == true) {
          print("incall true");
        } else {
          print("incall false");
          signalingClient.closeSocket();
        }
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        //signalingClient.appDetached();
        break;
    }
    // super.didChangeAppLifecycleState(state);
    // _isInForeground = state == AppLifecycleState.resumed;
  }

//  showAlertDialog() {
//     // flutter defined function
//     showDialog(
//       context: context,
//       builder: (popupcontext) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: new Text("dgdfgfg"),
//           content: new Text("vbdfgbfgbgb"),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

  _callcheck() {
    print("i am here in call chck function $count");

    count = count + 1;

    if (count == 30 && iscallAcceptedbyuser == false) {
      print("I am here in stopcall if");

      _callticker.cancel();

      count = 0;

      signalingClient.onCancelbytheCaller(registerRes["mcToken"]);

      _callProvider.initial();

      iscallAcceptedbyuser = false;
    } else if (count == 30 && iscallAcceptedbyuser == true) {
      _callticker.cancel();

      count = 0;

      print("I am here in stopcall call accept true");

      iscallAcceptedbyuser = false;
    } else if (iscallAcceptedbyuser == true) {
      _callticker.cancel();

      print("I am here in emptyyyyyyyyyy stopcall call accept true");

      count = 0;

      iscallAcceptedbyuser = false;
    } else {}
  }

  _startCall(GroupModel to, String mtype, String callType, String sessionType) {
    setState(() {
      isDDialer = true;
      inCall = true;
      pressDuration = "";
      onRemoteStream = false;
      switchMute = true;
      enableCamera = true;
      switchSpeaker = mtype == MediaType.audio ? true : false;
    });
    List<String> groupRefIDS = [];

    if (to == null) {
      Dialogs _dialog = new Dialogs();
      _dialog.loginLoading(context, "loading", "loading...");
    }

    if (to != null) {
      print("this is tooooo list $to");
      to.participants.forEach((element) {
        if (_auth.getUser.ref_id != element.ref_id)
          groupRefIDS.add(element.ref_id.toString());
      });
    }
    print(
        "this is signaling client start callllllll $broadcasttype..... $sessionType");
    signalingClient.startCallonetomany(
       groupName: to == null? null:to.group_title,
        from: _auth.getUser.ref_id,
        to: groupRefIDS,
        mcToken: registerRes["mcToken"],
        meidaType: mtype,
        callType: callType,
        sessionType: sessionType,
        ispublicbroadcast: ispublicbroadcast,
        broadcastype: broadcasttype,
        authorizationToken: _auth.getUser.authorization_token);
    // if (_localStream != null) {
    //here
    // _callBloc.add(CallDialEvent());
    _callticker = Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
    print("here in start call");
    if (to != null) {
      _callProvider.callDial();
    }

    // }
  }

  initRenderers() async {
    print("this is localRenderer $localRenderer");
    await localRenderer
        .initialize()
        .then((value) => null)
        .catchError((onError) {
      print("this is error on initialize $onError");
    });
    print("after initialixxation");
    // await remoteRenderer.initialize();
  }

  initRenderersRemote(RTCVideoRenderer rtcRenderer) async {
    await rtcRenderer.initialize();
  }

  startRinging() async {
    if (Platform.isAndroid) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: vibrationList);
      }
    }
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 1.0, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
  }

  disposeAllRenderer() async {
    // for (int i = 0; i < rendererListWithRefID.length; i++) {

    for (int i = 0; i < rendererListWithRefID.length; i++) {
      // if (i == 0) {
      print("this is list length $i....${rendererListWithRefID.length}");
      rendererListWithRefID[i]["rtcVideoRenderer"].srcObject = null;
      // } else
      // await rendererListWithRefID[i]["rtcVideoRenderer"].dispose();

    }
    if (rendererListWithRefID.length > 0) {
      print("this is list length ....${rendererListWithRefID.length}");
      rendererListWithRefID.removeRange(0, (rendererListWithRefID.length));
    }
    print("this is list length....dddd${rendererListWithRefID.length}");

    //  print(" i am here in dispose renderer  ");
    //  if(rendererListWithRefID.length!=0){

    //    await rendererListWithRefID[0]["rtcVideoRenderer"].dispose();
    //    await rendererListWithRefID[1]["rtcVideoRenderer"].dispose();
    //    rendererListWithRefID.removeAt(1);
    //    rendererListWithRefID.removeAt(0);
    //     print("this is renderlist length    ${rendererListWithRefID.length}");
    //    rendererListWithRefID=[];
    //  }

    //   if (i == 0) {
    //     rendererListWithRefID[i]["rtcVideoRenderer"].srcObject = null;
    //   } else
    //     await rendererListWithRefID[i]["rtcVideoRenderer"].dispose();
    // }
    // if (rendererListWithRefID.length > 1) {
    //   rendererListWithRefID.removeRange(1, (rendererListWithRefID.length));
    //  }
  }

  stopRinging() {
    print("this is on rejected ");
    // startRinging();                                         \
    vibrationList.clear();
    // });
    Vibration.cancel();
    FlutterRingtonePlayer.stop();

    // setState(() {
  }

  showSnackbar(text, Color color, Color backgroundColor, bool check) {
    if (check == false) {
      rootScaffoldMessengerKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(seconds: 2),
        ));
    } else if (check == true) {
      rootScaffoldMessengerKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(seconds: 2),
        ));
    }
  }

  backHandler() {
    setState(() {
      print("here in back handler set state");
      _selectedContacts = [];
      _groupListProvider.handleGroupListState(ListStatus.Scussess);
      _groupNameController.clear();
    });
  }

  renderList() {
    if (_groupListProvider.groupListStatus == ListStatus.Scussess)
      _groupListProvider.getGroupList(_auth.getUser.auth_token);
    else {
      print("i am here in renderer list else");
      _contactProvider.getContacts(_auth.getUser.auth_token);
      _selectedContacts.clear();
    }
  }

  handleGroupState() {
    _groupListProvider.handleGroupListState(ListStatus.CreateGroup);
  }

  handleCreateGroup(ListStatus state) {
    if (state == ListStatus.CreateGroup) {
      if (_selectedContacts.length == 0)
        buildShowDialog(
            context, "Please Select At least one contact to proceed!!!");
      else if (_selectedContacts.length <= 4) {
        print("Here in greater than 1");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateGroupPopUp(
                  editGroupName: false,
                  backHandler: backHandler,
                  groupNameController: _groupNameController,
                  selectedContacts: _selectedContacts,
                  authProvider: _auth);
            });
      } else {
        buildShowDialog(context, "Maximum limit is 4!!!");
      }
    } else
      handleGroupState();
  }

  Future buildShowDialog(BuildContext context, String errorMessage) {
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
                  "Error Message",
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
  dispose() {
    // localRenderer.dispose();
    // remoteRenderer.dispose();
    if (_ticker != null) {
      _ticker.cancel();
    }
    // FlutterRingtonePlayer.stop();
    // Vibration.cancel();
    // sdpController.dispose();
    print("i am here in disposeeeeeee ");
    //signalingClient.appDetached();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<Null> refreshList() async {
    setState(() {
      renderList();
      // rendersubscribe();
    });
    return;
  }

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

  // renderList() {
  //   _contactProvider.getContacts(_auth.getUser.auth_token);
  // }
  void _showDialogDeletegroup(group_id, index) {
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
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('CANCEL',
                          style: TextStyle(color: chatRoomColor))),
                  FlatButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _groupListProvider.deleteGroup(
                          group_id,
                          _auth.getUser.auth_token,
                        );
                        if (_groupListProvider.deleteGroupStatus ==
                            DeleteGroupStatus.Success) {
                          showSnakbar(_groupListProvider.successMsg);
                        } else if (_groupListProvider.deleteGroupStatus ==
                            DeleteGroupStatus.Failure) {
                          showSnakbar(_groupListProvider.errorMsg);
                        } else {}
                      },
                      child: Text('DELETE',
                          style: TextStyle(color: chatRoomColor)))
                ],
              )
            ],
          );
        });
  }

  stopCall() {
    print("this is mc token in stop call home ${registerRes["mcToken"]}");
    signalingClient.stopCall(registerRes["mcToken"]);

    //here
    // _callBloc.add(CallNewEvent());
    _callProvider.initial();
    if (_ticker != null) {
      _ticker.cancel();
    }

    //disposeAllRenderer();
    setState(() {
      ispublicbroadcast = false;

      inCall = false;
      pressDuration = "";
      if (isDDialer == true) {
        localRenderer.srcObject = null;
      }
      isDDialer = false;
      // remoteRenderer.srcObject = null;
    });
    if (!kIsWeb) stopRinging();
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));

    return Consumer3<CallProvider, AuthProvider, ContactProvider>(
      builder: (context, callProvider, authProvider, contactProvider, child) {
        print("this is callStatus ${callProvider.callStatus} $inCall");
        if (callProvider.callStatus == CallStatus.CallReceive)
          return callReceive();
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => MultiProvider(
        //         providers: [
        //           ChangeNotifierProvider<AuthProvider>(
        //               create: (context) => AuthProvider()),
        //           ChangeNotifierProvider(
        //               create: (context) => ContactProvider()),
        //           ChangeNotifierProvider(create: (context) => CallProvider()),
        //         ],
        //         child: CallReceiveScreen(
        //           //  rendererListWithRefID:rendererListWithRefID,
        //           mediaType: meidaType,

        //           incomingfrom: incomingfrom,
        //           callProvider: _callProvider,
        //           registerRes: registerRes,
        //           authProvider: authProvider,
        //           from: authProvider.getUser.ref_id,
        //           stopRinging: stopRinging,
        //           authtoken: authProvider.getUser.auth_token,
        //           contactList: contactProvider.contactList,
        //         )),
        //   ),
        // );

        if (callProvider.callStatus == CallStatus.CallStart) {
          print("here in call provider status");
          // if (isPushed == false) {
          //   isPushed = true;
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) => MultiProvider(
          //             providers: [
          //               ChangeNotifierProvider<AuthProvider>(
          //                   create: (context) => AuthProvider()),
          //               ChangeNotifierProvider(
          //                   create: (context) => ContactProvider()),
          //               ChangeNotifierProvider(
          //                   create: (context) => CallProvider()),
          //             ],
          //             child: CallStartScreen(
          //               // onSpeakerCallBack: onSpeakerCallBack,
          //               // onCameraCallBack: onCameraCallBack,
          //               // onMicCallBack: onMicCallBack,
          //               //  rendererListWithRefID:rendererListWithRefID,
          //               //  onRemoteStream:onRemoteStream,
          //               mediaType: meidaType,
          //               localRenderer: localRenderer,
          //               remoteRenderer: remoteRenderer,
          //               incomingfrom: incomingfrom,
          //               registerRes: registerRes,
          //               stopCall: stopCall,
          //               callTo: callTo,
          //               // signalingClient: signalingClient,
          //               callProvider: _callProvider,
          //               authProvider: _auth,
          //               contactProvider: _contactProvider,
          //               mcToken: registerRes["mcToken"],

          //               contactList: _contactProvider.contactList,
          //               //  popCallBAck: screenPopCallBack
          //             )),
          //       ),
          //     );
          //   });
          // }
          return callStart();
        }
        if (callProvider.callStatus == CallStatus.CallDial)
          return callDial();
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => MultiProvider(
        //         providers: [
        //           ChangeNotifierProvider<AuthProvider>(
        //               create: (context) => AuthProvider()),
        //           ChangeNotifierProvider(
        //               create: (context) => ContactProvider()),
        //           ChangeNotifierProvider(create: (context) => CallProvider()),
        //         ],
        //         child: CallDialScreen(
        //           //  rendererListWithRefID:rendererListWithRefID,

        //           mediaType: meidaType,
        //           callTo: callTo,
        //           //  incomingfrom: incomingfrom,
        //           callProvider: _callProvider,
        //           registerRes: registerRes,
        //           // authProvider: authProvider,
        //           // stopRinging: stopRinging,

        //           // authtoken: authProvider.getUser.auth_token,
        //           // contactList: contactProvider.contactList,
        //         )),
        //   ),
        // );
        else if (callProvider.callStatus == CallStatus.Initial)
          return SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFous = FocusScope.of(context);
                if (!currentFous.hasPrimaryFocus) {
                  return currentFous.unfocus();
                }
              },
              child: Scaffold(
                  backgroundColor: chatRoomBackgroundColor,
                  appBar: CustomAppBar(
                    handlePress: handleCreateGroup,
                  ),
                  body: Consumer2<ContactProvider, GroupListProvider>(
                    builder: (context, contact, groupProvider, child) {
                      if (groupProvider.groupListStatus == ListStatus.Loading)
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(chatRoomColor),
                        ));
                      else if (groupProvider.groupListStatus ==
                          ListStatus.SelectBroadCast) {
                        return LandingScreen(
                          grouplistprovider: _groupListProvider,
                          startCall: _startCall,
                          authprovider: _auth,
                          registerRes: registerRes,
                          isdev: isConnected,
                          sockett: sockett,
                        );
                      } else if (groupProvider.groupListStatus ==
                          ListStatus.Scussess) {
                        if (groupProvider.groupList.groups.length == 0) {
                          return NoContactsScreen(
                              isConnect: isConnected,
                              state: sockett,
                              refreshList: renderList,
                              groupListProvider: groupProvider,
                              authProvider: _auth,
                              newChatHandler: handleGroupState);
                        } else {
                          // return     LandingScreen();
                          return GroupListScreen(
                              authprovider: _auth,
                              registerRes: registerRes,
                              isdev: isConnected,
                              sockett: sockett,
                              state: groupProvider.groupList,
                              startCall: _startCall,
                              showdialogdeletegroup: _showDialogDeletegroup,
                              mediatype: meidaType,
                              grouplistprovider: _groupListProvider,
                              groupNameController: _groupNameController,
                              refreshList: refreshList);
                        }
                      }
                      //Create group Screen
                      else {
                        return ContactListScreen(
                          refreshcontactList: refreshList,
                          searchController: _searchController,
                          selectedContact: _selectedContacts,
                          state: contact,
                        );
                      }
                      // if (contact.contactState == ContactStates.Loading)
                      //   return Center(
                      //       child: CircularProgressIndicator(
                      //     valueColor:
                      //         AlwaysStoppedAnimation<Color>(chatRoomColor),
                      //   ));
                      // else if (contact.contactState == ContactStates.Success) {
                      //   if (contact.contactList.users == null)
                      //     return NoContactsScreen(
                      //       state: isConnected,
                      //       isSocketConnect: sockett,
                      //       refreshList: renderList,
                      //       authProvider: _auth,
                      //     );
                      //   else
                      //     return contactList(contact.contactList);
                      // } else
                      //   return Container(
                      //     child: Text("no contacts found"),
                      //   );
                    },
                  )),
            ),
          );
        return Container(
          child: Text("test"),
        );
      },
    );
  }

  Scaffold callReceive() {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Stack(children: <Widget>[
        kIsWeb
            ? Container()
            : meidaType == MediaType.video
                ? Container(
                    /////////////////////////////this is code comment for screen
                    // child: RTCVideoView(localRenderer,
                    //     key: forlargView,
                    //     mirror: false,
                    //     objectFit:
                    //         RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                    )
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        backgroundAudioCallDark,
                        backgroundAudioCallLight,
                        backgroundAudioCallLight,
                        backgroundAudioCallLight,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment(0.0, 0.0),
                    )),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/userIconCall.svg',
                      ),
                    ),
                  ),
        kIsWeb
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    backgroundAudioCallDark,
                    backgroundAudioCallLight,
                    backgroundAudioCallLight,
                    backgroundAudioCallLight,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 0.0),
                )),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/userIconCall.svg',
                  ),
                ),
              )
            : SizedBox(),
        Container(
          padding: EdgeInsets.only(top: 120),
          alignment: Alignment.center,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Incoming Call from",
                style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontFamily: secondaryFontFamily,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: darkBlackColor),
              ),
              SizedBox(
                height: 8,
              ),
              // Consumer<ContactProvider>(
              //   builder: (context, contact, child) {
                  // if (contact.contactState == ContactStates.Success) {
                  //   int index = contact.contactList.users.indexWhere(
                  //       (element) => element.ref_id == incomingfrom);
                  //   print("callto is $callTo");
                  //   print(
                  //       "incoming ${index == -1 ? incomingfrom : contact.contactList.users[index].full_name}");
                  //   return 
                    Text(
                      "$groupName",
                      // index == -1
                      //     ? incomingfrom
                      //     : contact.contactList.users[index].full_name,
                      style: TextStyle(
                          fontFamily: primaryFontFamily,
                          color: darkBlackColor,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 24),
                   // );
                //   } else
                //     return Container();
                // },
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: 56,
          ),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
                  stopRinging();
                  signalingClient.onDeclineCall(
                      _auth.getUser.ref_id, registerRes["mcToken"]);

                  // _callBloc.add(CallNewEvent());
                  _callProvider.initial();
                  //  inCall = false;
                  // signalingClient.onDeclineCall(widget.registerUser);
                  // setState(() {
                  //   _isCalling = false;
                  // });
                },
              ),
              SizedBox(width: 64),
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/Accept.svg',
                ),
                onTap: () {
                  print("this is pressed accept");
                  stopRinging();
                  signalingClient.createAnswer(incomingfrom);

                  // setState(() {
                  //   inCall = true;
                  // });

                  // setState(() {
                  //   _isCalling = true;
                  //   incomingfrom = null;
                  // });
                  // FlutterRingtonePlayer.stop();
                  // Vibration.cancel();
                },
              ),
            ],
          ),
        ),
      ]);
    }));
  }

  Scaffold callDial() {
    // return Scaffold(
    //       body: Container(height: 70,
    //       width:70,
    //     child: Text("hello")),
    // );
    print("remoteVideoFlag is $localRenderer");
    print("this is call to in call dial111111 $callTo");
    print("ths is width cjvddddddvv $meidaType");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: [
            !kIsWeb
                ? meidaType == MediaType.video
                    ?
                    //     ?   rendererListWithRefID.length==1? Column(
                    //   children: [
                    //     Container(height: 300,width:300,
                    //     child: RemoteStream(
                    //                 remoteRenderer:  rendererListWithRefID[0]
                    //                     ["rtcVideoRenderer"],)
                    //     // RTCVideoView(rendererListWithRefID[0]
                    //     //                  ["rtcVideoRenderer"],)
                    //     ),
                    //     ],
                    // ): rendererListWithRefID.length==2?
                    // Column(
                    //   children: [
                    //     Container(height: 300,width:300,
                    //     color:Colors.yellow,
                    //     child:
                    //     //  RemoteStream(
                    //     //             remoteRenderer:  rendererListWithRefID[0]
                    //     //                 ["rtcVideoRenderer"],)
                    //     RTCVideoView(rendererListWithRefID[0]
                    //                      ["rtcVideoRenderer"],)
                    //     ),
                    //       Container(height: 300,width:300,
                    //       color:Colors.red,
                    //       child:
                    //       //  RemoteStream(
                    //       //           remoteRenderer:  rendererListWithRefID[1]
                    //       //               ["rtcVideoRenderer"],)
                    //       RTCVideoView(rendererListWithRefID[1]
                    //                      ["rtcVideoRenderer"],)
                    //      )
                    //     ],
                    // ):Container()
                    Container(
                        // color: Colors.red,
                        //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        //////////////////////////////////////////////this is code comment in for camera
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        // child: RTCVideoView(localRenderer,
                        //     key: forDialView,
                        //     mirror: false,
                        //     objectFit: RTCVideoViewObjectFit
                        //         .RTCVideoViewObjectFitCover)
                        )
                    : Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            backgroundAudioCallDark,
                            backgroundAudioCallLight,
                            backgroundAudioCallLight,
                            backgroundAudioCallLight,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment(0.0, 0.0),
                        )),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/userIconCall.svg',
                          ),
                        ),
                      )
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        backgroundAudioCallDark,
                        backgroundAudioCallLight,
                        backgroundAudioCallLight,
                        backgroundAudioCallLight,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment(0.0, 0.0),
                    )),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/userIconCall.svg',
                      ),
                    ),
                  ),
            Container(
                padding: EdgeInsets.only(top: 120),
                alignment: Alignment.center,
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isRinging == false ? "Calling..." : "Ringing...",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontFamily: secondaryFontFamily,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: darkBlackColor),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        groupName,
                        style: TextStyle(
                            fontFamily: primaryFontFamily,
                            color: darkBlackColor,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 24),
                      )
                    ])),
            Container(
              padding: EdgeInsets.only(bottom: 56),
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
                  signalingClient.onCancelbytheCaller(registerRes["mcToken"]);
                  _callProvider.initial();
                  // inCall = false;
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  ///.........................
  ///./////////////////////
  ///.///////////////////////////
  ///.//////////////////
  Scaffold callStart() {
    //  inCall = true;
    print("this is media type $meidaType $remoteVideoFlag $localRenderer");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return ispublicbroadcast
            ? Container(
                child: Stack(children: <Widget>[
                enableCamera
                    ? RTCVideoView(localRenderer,
                        key: forsmallView,
                        mirror: false,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                    : Container(),
                Container(
                  padding: EdgeInsets.only(top: 55, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 150,
                          ),
                          child: Text(
                            "Initiating Public Broadcast",
                            style: TextStyle(
                                fontSize: 22,
                                decoration: TextDecoration.none,
                                fontFamily: secondaryFontFamily,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                color: darkBlackColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                            // padding: EdgeInsets.only(left: 65),
                            child: Image.asset(
                          'assets/broadcast.png',
                        )),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Container(
                          // margin: EdgeInsets.only(left: 85),
                          width: 115,
                          height: 35,
                          decoration: BoxDecoration(
                              color: participantcolor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: FlatButton(
                            onPressed: () {
                              Clipboard.setData(
                                  new ClipboardData(text: publicbroadcasturl));
                            },
                            child: Text('Copy URL',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                !kIsWeb
                    ? meidaType == MediaType.video
                        ? Container(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 120.33, 20, 27),
                                    child: GestureDetector(
                                      child: SvgPicture.asset(
                                        'assets/switch_camera.svg',
                                      ),
                                      onTap: () {
                                        signalingClient.switchCamera();
                                      },
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.person_add_alt_1_outlined,
                                          color: participantcolor,
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          "$participantcount",
                                          style: TextStyle(
                                              fontSize: 14,
                                              decoration: TextDecoration.none,
                                              fontFamily: secondaryFontFamily,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: participantcolor),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            // color: Colors.red,
                            child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 120.33, 20, 27),
                                  child: GestureDetector(
                                    child: !switchSpeaker
                                        ? SvgPicture.asset(
                                            'assets/VolumnOn.svg')
                                        : SvgPicture.asset(
                                            'assets/VolumeOff.svg'),
                                    onTap: () {
                                      signalingClient
                                          .switchSpeaker(switchSpeaker);
                                      setState(() {
                                        switchSpeaker = !switchSpeaker;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ))
                    : SizedBox(),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 56,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      meidaType == MediaType.video
                          ? Row(
                              children: [
                                GestureDetector(
                                  child: !enableCamera
                                      ? SvgPicture.asset('assets/video_off.svg')
                                      : SvgPicture.asset('assets/video.svg'),
                                  onTap: () {
                                    setState(() {
                                      enableCamera = !enableCamera;
                                    });
                                    signalingClient.audioVideoState(
                                        audioFlag: switchMute ? 1 : 0,
                                        videoFlag: enableCamera ? 1 : 0,
                                        mcToken: registerRes["mcToken"]);
                                    signalingClient.enableCamera(enableCamera);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                )
                              ],
                            )
                          : SizedBox(),
                      GestureDetector(
                        child: SvgPicture.asset(
                          'assets/end.svg',
                        ),
                        onTap: () {
                          remoteVideoFlag = true;
                          stopCall();
                        },
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        child: !switchMute
                            ? SvgPicture.asset('assets/mute_microphone.svg')
                            : SvgPicture.asset('assets/microphone.svg'),
                        onTap: () {
                          final bool enabled = signalingClient.muteMic();
                          print("this is enabled $enabled");
                          setState(() {
                            switchMute = enabled;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ]))
            //public broad cast case enddddd
            : isDDialer == false
                ? Container(
                    child: Stack(children: <Widget>[
                      meidaType == MediaType.video
                          ? remoteVideoFlag
                              ? rendererListWithRefID.length == 1
                                  ? RemoteStream(
                                      remoteRenderer: rendererListWithRefID[0]
                                          ["rtcVideoRenderer"])
                                  : rendererListWithRefID.length == 2
                                      ? RemoteStream(
                                          remoteRenderer:
                                              rendererListWithRefID[1]
                                                  ["rtcVideoRenderer"])
                                      : Container()
                              : Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [
                                      backgroundAudioCallDark,
                                      backgroundAudioCallLight,
                                      backgroundAudioCallLight,
                                      backgroundAudioCallLight,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment(0.0, 0.0),
                                  )),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/userIconCall.svg',
                                    ),
                                  ),
                                )
                          : Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  backgroundAudioCallDark,
                                  backgroundAudioCallLight,
                                  backgroundAudioCallLight,
                                  backgroundAudioCallLight,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment(0.0, 0.0),
                              )),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/userIconCall.svg',
                                ),
                              ),
                            ),

                      Container(
                          // color: Colors.red,
                          child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 120.33, 20, 27),
                              child: GestureDetector(
                                child: !switchSpeaker
                                    ? SvgPicture.asset('assets/VolumnOn.svg')
                                    : SvgPicture.asset('assets/VolumeOff.svg'),
                                onTap: () {
                                  signalingClient.switchSpeaker(switchSpeaker);
                                  setState(() {
                                    switchSpeaker = !switchSpeaker;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )),

                      //),

                      // /////////////// this is local stream

                      rendererListWithRefID.length == 2
                          ? Positioned(
                              left: 225.0,
                              bottom: 145.0,
                              right: 20,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 170,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: enableCamera
                                        ? RemoteStream(
                                            remoteRenderer:
                                                rendererListWithRefID[0]
                                                    ["rtcVideoRenderer"])
                                        : Container(color: Colors.pink),
                                  ),
                                ),
                              ),
                            )
                          : Container(),

                      Container(
                        padding: EdgeInsets.only(
                          bottom: 56,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: SvgPicture.asset(
                                'assets/end.svg',
                              ),
                              onTap: () {
                                remoteVideoFlag = true;
                                stopCall();
                              },
                            ),
                          ],
                        ),
                      )
                    ]),
                  )

                ////////////////////////
                ///........................
                //Container(color:Colors.pink)
                //receiver side starts
                // Container(
                //     child: Stack(children: <Widget>[
                //     meidaType == MediaType.video
                //         ? remoteVideoFlag
                //             ? rendererListWithRefID.length == 1
                //                 ? Column(
                //                     children: [
                //                       Expanded(
                //                         child: Container(

                //                             child: RemoteStream(
                //                           remoteRenderer:
                //                               rendererListWithRefID[0]
                //                                   ["rtcVideoRenderer"],
                //                         )

                //                             ),
                //                       ),
                //                     ],
                //                   )
                //                 : rendererListWithRefID.length == 2
                //                     ? Column(
                //                         children: [
                //                           Container(
                //                               height: MediaQuery.of(context)
                //                                       .size
                //                                       .height /
                //                                   2,
                //                               width: MediaQuery.of(context)
                //                                   .size
                //                                   .width,

                //                               child:

                //                                   RTCVideoView(
                //                                 rendererListWithRefID[0]
                //                                     ["rtcVideoRenderer"],
                //                               )),
                //                           Expanded(
                //                             child: Container(
                //                                 width: MediaQuery.of(context)
                //                                     .size
                //                                     .width,

                //                                 child:

                //                                     RTCVideoView(
                //                                   rendererListWithRefID[1]
                //                                       ["rtcVideoRenderer"],
                //                                 )),
                //                           )
                //                         ],
                //                       )
                //                     : Container()
                //             : Container(
                //                 decoration: BoxDecoration(
                //                     gradient: LinearGradient(
                //                   colors: [
                //                     backgroundAudioCallDark,
                //                     backgroundAudioCallLight,
                //                     backgroundAudioCallLight,
                //                     backgroundAudioCallLight,
                //                   ],
                //                   begin: Alignment.topCenter,
                //                   end: Alignment(0.0, 0.0),
                //                 )),
                //                 child: Center(
                //                   child: SvgPicture.asset(
                //                     'assets/userIconCall.svg',
                //                   ),
                //                 ),
                //               )
                //         : Container(
                //             padding: EdgeInsets.only(top: 55, left: 20),
                //             //height: 79,
                //             //width: MediaQuery.of(context).size.width,

                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Container(
                //                   padding: EdgeInsets.only(top: 150, left: 50),
                //                   child: Text(
                //                     "Initiating Public Broadcast",
                //                     style: TextStyle(
                //                         fontSize: 22,
                //                         decoration: TextDecoration.none,
                //                         fontFamily: secondaryFontFamily,
                //                         fontWeight: FontWeight.w400,
                //                         fontStyle: FontStyle.normal,
                //                         color: darkBlackColor),
                //                   ),
                //                 ),
                //                 SizedBox(height: 20),
                //                 Container(
                //                     padding: EdgeInsets.only(left: 65),
                //                     child: Image.asset(
                //                       'assets/broadcast.png',
                //                     )),
                //                 SizedBox(height: 40),
                //                 Container(
                //                   margin: EdgeInsets.only(left: 85),
                //                   width: 115,
                //                   height: 35,
                //                   decoration: BoxDecoration(
                //                       color: participantcolor,
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular(10))),
                //                   child: FlatButton(
                //                     onPressed: () {
                //                       Clipboard.setData(new ClipboardData(
                //                           text: publicbroadcasturl));
                //                     },
                //                     child: Text('Copy URL',
                //                         style: TextStyle(color: Colors.white)),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //     !kIsWeb
                //          ?
                //              Container(
                //                 child: Align(
                //                 alignment: Alignment.topRight,
                //                 child: Column(
                //                   children: [
                //                     Container(
                //                       padding: const EdgeInsets.fromLTRB(
                //                           0.0, 120.33, 20, 27),
                //                       child: GestureDetector(
                //                         child: !switchSpeaker
                //                             ? SvgPicture.asset(
                //                                 'assets/VolumnOn.svg')
                //                             : SvgPicture.asset(
                //                                 'assets/VolumeOff.svg'),
                //                         onTap: () {
                //                           signalingClient
                //                               .switchSpeaker(switchSpeaker);
                //                           setState(() {
                //                             switchSpeaker = !switchSpeaker;
                //                           });
                //                         },
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ))
                //         : SizedBox(),
                //     Container(
                //       padding: EdgeInsets.only(
                //         bottom: 56,
                //       ),
                //       alignment: Alignment.bottomCenter,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           GestureDetector(
                //             child: SvgPicture.asset(
                //               'assets/end.svg',
                //             ),
                //             onTap: () {
                //               remoteVideoFlag = true;
                //               stopCall();
                //             },
                //           ),
                //         ],
                //       ),
                //     )
                //   ]))
                : Container(
                    child: Stack(children: <Widget>[
                      meidaType == MediaType.video
                          ? enableCamera
                              ? RTCVideoView(localRenderer,
                                  key: forsmallView,
                                  mirror: false,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover)
                              : Container(color: Colors.red)
                          : Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  backgroundAudioCallDark,
                                  backgroundAudioCallLight,
                                  backgroundAudioCallLight,
                                  backgroundAudioCallLight,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment(0.0, 0.0),
                              )),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/userIconCall.svg',
                                ),
                              ),
                            ),
                      Container(
                        padding: EdgeInsets.only(top: 55, left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (meidaType == MediaType.video)
                                  ? 'You are video calling with'
                                  : 'You are audio calling with',
                              style: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                  fontFamily: secondaryFontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: darkBlackColor),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: 25,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Text(
                                  //     callTo,
                                  //     style: TextStyle(
                                  //         fontFamily: primaryFontFamily,
                                  //         // background: Paint()..color = yellowColor,
                                  //         color: darkBlackColor,
                                  //         decoration: TextDecoration.none,
                                  //         fontWeight: FontWeight.w700,
                                  //         fontStyle: FontStyle.normal,
                                  //         fontSize: 24),
                                  //   ),
                                  Text(
                                    pressDuration,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 14,
                                        fontFamily: secondaryFontFamily,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: darkBlackColor),
                                  ),
                                ],
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     //SizedBox(width: 10),
                            //     number != null
                            //         ? Text(
                            //             "DownStream $number UpStream $nummm",
                            //             style: TextStyle(
                            //                 decoration: TextDecoration.none,
                            //                 fontSize: 14,
                            //                 fontFamily: secondaryFontFamily,
                            //                 fontWeight: FontWeight.w400,
                            //                 fontStyle: FontStyle.normal,
                            //                 color: darkBlackColor),
                            //           )
                            //         : Text(
                            //             "DownStream 0   UpStream 0",
                            //             style: TextStyle(
                            //                 decoration: TextDecoration.none,
                            //                 fontSize: 14,
                            //                 fontFamily: secondaryFontFamily,
                            //                 fontWeight: FontWeight.w400,
                            //                 fontStyle: FontStyle.normal,
                            //                 color: darkBlackColor),
                            //           ),
                            //   ],
                            //),
                          ],
                        ),
                      ),
                      !kIsWeb
                          ? meidaType == MediaType.video
                              ? Container(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 120.33, 20, 27),
                                          child: GestureDetector(
                                            child: SvgPicture.asset(
                                              'assets/switch_camera.svg',
                                            ),
                                            onTap: () {
                                              signalingClient.switchCamera();
                                            },
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.person_add_alt_1_outlined,
                                                color: participantcolor,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: Text(
                                                "$participantcount",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontFamily:
                                                        secondaryFontFamily,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    color: participantcolor),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  // color: Colors.red,
                                  child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 120.33, 20, 27),
                                        child: GestureDetector(
                                          child: !switchSpeaker
                                              ? SvgPicture.asset(
                                                  'assets/VolumnOn.svg')
                                              : SvgPicture.asset(
                                                  'assets/VolumeOff.svg'),
                                          onTap: () {
                                            signalingClient
                                                .switchSpeaker(switchSpeaker);
                                            setState(() {
                                              switchSpeaker = !switchSpeaker;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          : SizedBox(),
                      //),

                      // /////////////// this is local stream
                      // meidaType == MediaType.video
                      //     ? Positioned(
                      //         left: 225.0,
                      //         bottom: 145.0,
                      //         right: 20,
                      //         child: Align(
                      //           alignment: Alignment.bottomRight,
                      //           child: Container(
                      //             height: 170,
                      //             width: 130,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //             ),
                      //             child: ClipRRect(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //               child: enableCamera
                      //                   ? RTCVideoView(localRenderer,
                      //                       key: forsmallView,
                      //                       mirror: false,
                      //                       objectFit: RTCVideoViewObjectFit
                      //                           .RTCVideoViewObjectFitCover)
                      //                   : Container(),
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     : Container(),

                      Container(
                        padding: EdgeInsets.only(
                          bottom: 56,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            meidaType == MediaType.video
                                ? Row(
                                    children: [
                                      GestureDetector(
                                        child: !enableCamera
                                            ? SvgPicture.asset(
                                                'assets/video_off.svg')
                                            : SvgPicture.asset(
                                                'assets/video.svg'),
                                        onTap: () {
                                          setState(() {
                                            enableCamera = !enableCamera;
                                          });
                                          signalingClient.audioVideoState(
                                              audioFlag: switchMute ? 1 : 0,
                                              videoFlag: enableCamera ? 1 : 0,
                                              mcToken: registerRes["mcToken"]);
                                          signalingClient
                                              .enableCamera(enableCamera);
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  )
                                : SizedBox(),

                            GestureDetector(
                              child: SvgPicture.asset(
                                'assets/end.svg',
                              ),
                              onTap: () {
                                remoteVideoFlag = true;
                                stopCall();
                                // inCall = false;

                                // setState(() {
                                //   _isCalling = false;
                                // });
                              },
                            ),

                            // SvgPicture.asset('assets/images/end.svg'),

                            SizedBox(width: 20),
                            GestureDetector(
                              child: !switchMute
                                  ? SvgPicture.asset(
                                      'assets/mute_microphone.svg')
                                  : SvgPicture.asset('assets/microphone.svg'),
                              onTap: () {
                                final bool enabled = signalingClient.muteMic();
                                print("this is enabled $enabled");
                                setState(() {
                                  switchMute = enabled;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ]),
                  );
      }),
    );
  }
  // Scaffold groupList(){
  //     onSearch(value) {
  //     print("this is here $value");
  //     List temp;
  //     temp = widget.state.groups
  //         .where((element) =>
  //             element.group_title.toLowerCase().startsWith(value.toLowerCase()))
  //         .toList();
  //     print("this is filtered list $_groupfilteredList");
  //     setState(() {
  //       if (temp.isEmpty) {
  //         groupnotmatched = true;
  //         print("Here in true not matched");
  //       } else {
  //         print("Here in false matched");
  //         groupnotmatched = false;
  //         _groupfilteredList = temp;
  //       }
  //     });
  //   }
  // return Scaffold(
  //     body: RefreshIndicator(
  //       onRefresh: refreshList,
  //       child: Container(
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 50,
  //               padding: EdgeInsets.only(left: 21, right: 21),
  //               child: TextFormField(
  //                 controller: _GroupListsearchController,
  //                 onChanged: (value) {
  //                   onSearch(value);
  //                 },
  //                 validator: (value) =>
  //                     value.isEmpty ? "Field cannot be empty." : null,
  //                 decoration: InputDecoration(
  //                   fillColor: refreshTextColor,
  //                   filled: true,
  //                   prefixIcon: Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: SvgPicture.asset(
  //                       'assets/SearchIcon.svg',
  //                       width: 20,
  //                       height: 20,
  //                       fit: BoxFit.fill,
  //                     ),
  //                   ),
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(5),
  //                       borderSide: BorderSide(color: searchbarContainerColor)),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(5.0),
  //                     borderSide: BorderSide(
  //                       color: searchbarContainerColor,
  //                     ),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(5)),
  //                       borderSide: BorderSide(color: searchbarContainerColor)),
  //                   hintText: "Search",
  //                   hintStyle: TextStyle(
  //                       fontSize: 14.0,
  //                       fontWeight: FontWeight.w400,
  //                       color: searchTextColor,
  //                       fontFamily: secondaryFontFamily),
  //                 ),
  //               ),
  //               //),
  //             ),
  //             SizedBox(height: 30),
  //             Expanded(
  //               child: Scrollbar(
  //                 child: groupnotmatched == true
  //                     ? Text("No data Found")
  //                     : ListView.separated(
  //                         shrinkWrap: true,
  //                         padding: const EdgeInsets.all(8),
  //                         cacheExtent: 9999,
  //                         scrollDirection: Axis.vertical,
  //                         itemCount: _GroupListsearchController.text.isEmpty
  //                             ? state.groups.length
  //                             : _groupfilteredList.length,
  //                         itemBuilder: (context, position) {
  //                           GroupModel element =
  //                               _GroupListsearchController.text.isEmpty
  //                                   ? widget.state.groups[position]
  //                                   : _groupfilteredList[position];
  //                           return Container(
  //                             height: 50,
  //                             child: Row(
  //                               children: [
  //                                 Container(
  //                                   padding: const EdgeInsets.only(
  //                                       left: 11.5, right: 13.5),
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(8),
  //                                   ),
  //                                   child: SvgPicture.asset('assets/User.svg'),
  //                                 ),
  //                                 Expanded(
  //                                   child: Text(
  //                                     "${element.group_title}",
  //                                     style: TextStyle(
  //                                       color: contactNameColor,
  //                                       fontSize: 16,
  //                                       fontFamily: primaryFontFamily,
  //                                       fontWeight: FontWeight.w500,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   child: IconButton(
  //                                     icon: SvgPicture.asset('assets/call.svg'),
  //                                     onPressed: () {
  //                                       widget.startCall(
  //                                           element,
  //                                           MediaType.audio,
  //                                           CAllType.many2many,
  //                                           SessionType.call);
  //                                       setState(() {
  //                                         callTo = element.group_title;
  //                                         widget.mediatype = MediaType.audio;

  //                                       });
  //                                       print("three dot icon pressed");
  //                                     },
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   padding: EdgeInsets.only(right: 5.9),

  //                                   child: IconButton(
  //                                     icon: SvgPicture.asset(
  //                                         'assets/videocallicon.svg'),
  //                                     onPressed: () {
  //                                       startCall(
  //                                           element,
  //                                           MediaType.video,
  //                                           CAllType.many2many,
  //                                           SessionType.call);
  //                                       setState(() {

  //                                         callTo = element.group_title;

  //                                         widget.mediatype = MediaType.video;

  //                                       });
  //                                       print("three dot icon pressed");
  //                                     },
  //                                   ),
  //                                 )
  //                                 ,
  //                                    Consumer<GroupListProvider>(
  //      builder: (context, listProvider, child) {
  //                                       return    Container(
  //                                           height: 24,
  //                                           width: 24,
  //                                           margin: EdgeInsets.only(right: 19,bottom: 15),
  //                                           child: PopupMenuButton(
  //                                               offset: Offset(8, 30),
  //                                               shape: RoundedRectangleBorder(
  //                                                   borderRadius:
  //                                                       BorderRadius.all(
  //                                                           Radius.circular(
  //                                                               20.0))),
  //                                               icon: const Icon(
  //                                                 Icons.more_horiz,
  //                                                 size: 24,
  //                                                 color: horizontalDotIconColor,
  //                                               ),
  //                                               itemBuilder:
  //                                                   (BuildContext context) => [
  //                                                         PopupMenuItem(
  //                                                           enabled: (
  //                                                                        listProvider.groupList
  //                                                                           .groups[
  //                                                                               position]
  //                                                                           .participants
  //                                                                           .length ==
  //                                                                       1 ||
  //                                                                   listProvider
  //                                                                           .groupList
  //                                                                           .groups[
  //                                                                               position]
  //                                                                           .participants
  //                                                                           .length ==
  //                                                                       2)
  //                                                               ? false
  //                                                               : true,
  //                                                           padding:
  //                                                               EdgeInsets.only(
  //                                                                 right: 12,
  //                                                                   left: 12),
  //                                                           value: 1,

  //                                                           child: Container(
  //                                                             padding:
  //                                                                 EdgeInsets.only(
  //                                                                     top: 14,
  //                                                                     left: 16,
  //                                                                     right: 50),
  //                                                             width: 200,
  //                                                             height: 44,
  //                                                             decoration: BoxDecoration(
  //                                                                 color:
  //                                                                     chatRoomBackgroundColor,
  //                                                                 borderRadius:
  //                                                                     BorderRadius
  //                                                                         .circular(
  //                                                                             8)),
  //                                                             child: Text(
  //                                                               "Edit Group Name",
  //                                                               style: TextStyle(
  //                                                                 fontSize: 14,
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w600,
  //                                                                 fontFamily:
  //                                                                     font_Family,
  //                                                                 fontStyle:
  //                                                                     FontStyle
  //                                                                         .normal,
  //                                                                 color:
  //                                                                     personNameColor,
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         ),

  //                                                         PopupMenuItem(
  //                                                             padding:
  //                                                                 EdgeInsets.only(
  //                                                                     right: 12,
  //                                                                     left: 12),
  //                                                             value: 2,
  //                                                             child: Column(
  //                                                               children: [
  //                                                                 SizedBox(
  //                                                                   height: 8,
  //                                                                 ),
  //                                                                 Container(
  //                                                                   padding:
  //                                                                       EdgeInsets
  //                                                                           .only(
  //                                                                     top: 14,
  //                                                                     left: 16,
  //                                                                   ),
  //                                                                   width: 200,
  //                                                                   height: 44,
  //                                                                   decoration: BoxDecoration(
  //                                                                       color:
  //                                                                           chatRoomBackgroundColor,
  //                                                                       borderRadius:
  //                                                                           BorderRadius.circular(
  //                                                                               8)),
  //                                                                   //  color:popupGreyColor,
  //                                                                   child: Text(
  //                                                                     "Delete",
  //                                                                     style:
  //                                                                         TextStyle(
  //                                                                       //decoration: TextDecoration.underline,
  //                                                                       fontSize:
  //                                                                           14,
  //                                                                       fontWeight:
  //                                                                           FontWeight
  //                                                                               .w600,
  //                                                                       fontFamily:
  //                                                                           font_Family,
  //                                                                       fontStyle:
  //                                                                           FontStyle
  //                                                                               .normal,
  //                                                                       color:
  //                                                                           Colors.red[700],
  //                                                                     ),
  //                                                                   ),
  //                                                                 )
  //                                                               ],
  //                                                             )),
  //                                                       ],
  //                                               onSelected: (menu) {
  //                                                 if (menu == 1) {
  //                                                   print("i am in edit group name press");
  //                                                   showDialog(
  //                                                       context: context,
  //                                                       builder: (BuildContext
  //                                                           context) {
  //                                                         return ListenableProvider<
  //                                                                 GroupListProvider>.value(
  //                                                             value:
  //                                                                 widget.grouplistprovider,
  //                                                             child:
  //                                                                 CreateGroupPopUp(
  //                                                               editGroupName:
  //                                                                   true,
  //                                                               groupid:
  //                                                                   listProvider
  //                                                                       .groupList
  //                                                                       .groups[
  //                                                                           position]
  //                                                                       .id,
  //                                                               controllerText:
  //                                                                   listProvider
  //                                                                       .groupList
  //                                                                       .groups[
  //                                                                           position]
  //                                                                       .group_title,
  //                                                               groupNameController:
  //                                                                   widget.groupNameController,
  //                                                              // publishMessage:
  //                                                                //   publishMessage,
  //                                                               authProvider:
  //                                                                   widget.authprovider,
  //                                                             ));
  //                                                       });
  //                                                   print("i am after here");

  //                                                 } else if (menu == 2) {
  //                                                widget.showdialogdeletegroup(
  //                                                       listProvider.groupList
  //                                                           .groups[position].id,
  //                                                       listProvider.groupList
  //                                                           .groups[position]);

  //                                                 }
  //                                               }),

  //                                         );

  //      })
  //                               ],
  //                             ),
  //                           );
  //                           //});
  //                         },
  //                         separatorBuilder: (BuildContext context, int index) {
  //                           return Padding(
  //                             padding:
  //                                 const EdgeInsets.only(left: 14.33, right: 19),
  //                             child: Divider(
  //                               thickness: 1,
  //                               color: listdividerColor,
  //                             ),
  //                           );
  //                         },
  //                       ),
  //               ),
  //             ),
  //             Align(
  //                 alignment: Alignment.bottomCenter,
  //                 child: Column(children: [
  //                   Container(
  //                     padding: const EdgeInsets.only(top: 20),
  //                     child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             child: FlatButton(
  //                               onPressed: () {
  //                                 widget.authprovider.logout();

  //                                 signalingClient
  //                                     .unRegister(widget.registerRes["mcToken"]);
  //                               },
  //                               child: Text(
  //                                 "LOG OUT",
  //                                 style: TextStyle(
  //                                     fontSize: 14.0,
  //                                     fontFamily: primaryFontFamily,
  //                                     fontStyle: FontStyle.normal,
  //                                     fontWeight: FontWeight.w700,
  //                                     color: logoutButtonColor,
  //                                     letterSpacing: 0.90),
  //                               ),
  //                             ),
  //                           ),
  //                           Container(
  //                             height: 25,
  //                             width: 25,
  //                             child: SvgPicture.asset(
  //                               'assets/call.svg',
  //                               color: widget.sockett && widget.isdev
  //                                   ? Colors.green
  //                                   : Colors.red,
  //                             ),
  //                           ),
  //                         ]),
  //                   ),
  //                   Container(
  //                       padding: const EdgeInsets.only(bottom: 60),
  //                       child: Text(widget.authprovider.getUser.full_name))
  //                 ]))
  //           ],
  //         ),
  //       ),
  //     ),
  //      );
  //  }
  Scaffold contactList(ContactList state) {
    onSearch(value) {
      print("this is here $value");
      List temp;
      temp = state.users
          .where((element) =>
              element.full_name.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
      print("this is filtered list $_filteredList");
      setState(() {
        if (temp.isEmpty) {
          notmatched = true;
          print("Here in true not matched");
        } else {
          print("Here in false matched");
          notmatched = false;
          _filteredList = temp;
        }
        //_filteredList = temp;
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Container(
          child: Column(
            children: [
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
                        borderSide: BorderSide(color: searchbarContainerColor)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: searchbarContainerColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(color: searchbarContainerColor)),
                    // border: InputBorder.none,
                    // focusedBorder: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // errorBorder: InputBorder.none,
                    // disabledBorder: InputBorder.none,
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                    // contentPadding: EdgeInsets.only(
                    //   top: 15,
                    // ),
                    // contentPadding:
                    //   EdgeInsets.symmetric(vertical: 20, horizontal: 20),

                    // isDense: true,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: searchTextColor,
                        fontFamily: secondaryFontFamily),
                  ),
                ),
                //),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Scrollbar(
                  child: notmatched == true
                      ? Text("No data Found")
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          cacheExtent: 9999,
                          scrollDirection: Axis.vertical,
                          itemCount: _searchController.text.isEmpty
                              ? state.users.length
                              : _filteredList.length,
                          itemBuilder: (context, position) {
                            var element = _searchController.text.isEmpty
                                ? state.users[position]
                                : _filteredList[position];

                            return Container(
                              //width: screenwidth,
                              height: 50,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 11.5, right: 13.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset('assets/User.svg'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${element.full_name}",
                                      style: TextStyle(
                                        color: contactNameColor,
                                        fontSize: 16,
                                        fontFamily: primaryFontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: 32,
                                    // height: 32,
                                    child: IconButton(
                                        icon:
                                            SvgPicture.asset('assets/call.svg'),
                                        onPressed: isConnected && sockett
                                            ? () {
                                                print(
                                                    "here in connected start call $isConnected");
                                                // _startCall(
                                                //     [element.ref_id],
                                                //     MediaType.audio,
                                                //     CAllType.one2one,
                                                //     SessionType.call);
                                                setState(() {
                                                  callTo = element.full_name;
                                                  meidaType = MediaType.audio;
                                                  print(
                                                      "this is callTo $callTo");
                                                });
                                                print("three dot icon pressed");
                                              }
                                            : () {
                                                print(
                                                    "here in connected start call");

                                                final snackBar = SnackBar(
                                                    content: Text(
                                                        'Make sure your device has internet connection'));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 5.9),
                                    // width: 35,
                                    // height: 35,
                                    child: IconButton(
                                        icon: SvgPicture.asset(
                                            'assets/videocallicon.svg'),
                                        onPressed: isConnected && sockett
                                            ? () {
                                                // _startCall(
                                                //     [element.ref_id],
                                                //     MediaType.video,
                                                //     CAllType.one2many,
                                                //     SessionType.call);
                                                setState(() {
                                                  callTo = element.full_name;
                                                  meidaType = MediaType.video;
                                                  print(
                                                      "this is callTo $callTo");
                                                });
                                                print("three dot icon pressed");
                                              }
                                            : () {
                                                final snackBar = SnackBar(
                                                    content: Text(
                                                        'Make sure your device has internet connection'));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 14.33, right: 19),
                              child: Divider(
                                thickness: 1,
                                color: listdividerColor,
                              ),
                            );
                          },
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextButton(
                      onPressed: () {
                        islogout = true;

                        signalingClient.unRegister(registerRes["mcToken"]);
                        // _auth.logout();
                      },
                      child: Text(
                        "LOG OUT",
                      ),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: primaryFontFamily,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.90),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: isConnected && sockett == true
                            ? Colors.green
                            : Colors.red,
                        shape: BoxShape.circle),
                  )
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Text(_auth.getUser.full_name))
            ],
          ),
        ),
      ),
    );
  }
}

class Dialogs {
  loginLoading(BuildContext context, String type, String description) {
    // var descriptionBody;

    // if(type == "error"){
    //   descriptionBody = CircleAvatar(
    //     radius: 100.0,
    //     maxRadius: 100.0,
    //     child: new Icon(Icons.warning),
    //     backgroundColor: Colors.redAccent,
    //   );
    // } else {
    //   descriptionBody = new Center(
    //     child: new CircularProgressIndicator(),
    //   );
    // }

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: descriptionBody,
            content: SingleChildScrollView(
                child: Container(
                    height: 278,
                    width: 319,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 80),
                          Text("Creating your URL..."),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: LinearProgressIndicator(),
                          ),
                        ],
                      ),
                    ))),
          );
        });
  }
}
