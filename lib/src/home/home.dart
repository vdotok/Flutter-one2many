import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
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
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:wakelock/wakelock.dart';

import 'dart:io' show Platform;

import '../../constant.dart';
import '../../main.dart';
import '../core/models/contactList.dart';
import '../core/providers/auth.dart';
import '../core/providers/call_provider.dart';
import '../core/providers/contact_provider.dart';

String callTo = "";
String groupName = "";
String typeOfCall = "";
bool ispublicbroadcast = false;
String broadcasttype = "";
bool isRegisteredAlready = false;
bool isDDialer = false;
String pressDuration = "";
bool remoteVideoFlag = true;
bool groupBroadcast = false;
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
String session_type = "";
BuildContext popupcontext;
GlobalKey forsmallView = new GlobalKey();
GlobalKey forlargView = new GlobalKey();
GlobalKey forDialView = new GlobalKey();
bool groupnotmatched = false;
var snackBar;
bool isConnected = true;

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
  AudioPlayer _audioPlayer = AudioPlayer();
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

  var registerRes;
  // bool isdev = true;
  String incomingfrom;
  // ContactBloc _contactBloc;
  // CallBloc _callBloc;
  // LoginBloc _loginBloc;
  CallProvider _callProvider;
  AuthProvider _auth;
  BuildContext dialogBoxContext;
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
    signalingClient.onAddparticpant = (paticipantcount, 
    //calltype
    ) {
      //print("this is participant count ffffff $paticipantcount $calltype ");
      // setState(() {
      if (Platform.isIOS) {
        setState(() {
          participantcount = paticipantcount;
          //typeOfCall = calltype;
          _audioPlayer.stop();
          _callProvider.callStart();
        });
      } else {
        setState(() {
          participantcount = paticipantcount - 1;
          print("hgshd $participantcount");
        });
      }
      // });
    };
    signalingClient.insufficientBalance = (res) {
      print("here in insufficient balance");
      snackBar = SnackBar(content: Text('$res'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
    signalingClient.onError = (code, res) {
      print("onError $code $res");

      if (code == 1001 || code == 1002) {
        signalingClient.sendPing(registerRes["mctoken"]);

        setState(() {
          sockett = false;

          isRegisteredAlready = false;
        });
      } else if (code == 401) {
        print("here in 401");
        setState(() {
          sockett = false;
          isRegisteredAlready = true;
          snackBar = SnackBar(
            content: Text('$res'),
            duration: Duration(days: 365),
          );
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
            if (isConnected && sockett == false && !isRegisteredAlready) {
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
          if (_ticker != null) {
            _ticker.cancel();
          }

          _time = _callTime;
          isTimer = false;
        }
        _updateTimer();
        _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
        onRemoteStream = true;
        _audioPlayer.stop();

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
      if (typeOfCall == "one_to_many" && !boolFlag) {
        participantcount = participantcount - 1;
      }
      // on participants left
      if (refID == _auth.getUser.ref_id) {
      } else {}
    };
    signalingClient.onReceiveCallFromUser = (mapData,isMultiSession) async {
      print("incomming call from user ${mapData}");
      startRinging();
      groupName = mapData["data"]["groupName"];
      setState(() {
        if (mapData["call_type"] == "one_to_many") {
          groupBroadcast = true;
        }
        session_type = mapData["session_type"];
        inCall = true;
        typeOfCall = mapData["call_type"];
        pressDuration = "";
        onRemoteStream = false;
        iscalloneto1 = false;
        Wakelock.toggle(enable: true);
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
       if (isMultiSession) {
        iscallAcceptedbyuser = false;
      } else {
        _callticker = Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
      }
    };
    signalingClient.onCallAcceptedByUser = () async {
      print("this is call accepted");
      inCall = true;
      iscallAcceptedbyuser = true;
      pressDuration = "";
      if (typeOfCall == "one_to_many") {
        groupBroadcast = true;
      }
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
        Wakelock.toggle(enable: false);
        groupBroadcast = false;
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
      snackBar = SnackBar(content: Text('User is busy with another call.'));

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
      _audioPlayer.stop();
      Navigator.pop(dialogBoxContext);
      MoveToBackground.moveTaskToBack();
      //   Navigator.pop(popupcontext);

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
      Wakelock.toggle(enable: true);
      inCall = true;
      typeOfCall = callType;
      pressDuration = "";
      onRemoteStream = false;
      switchMute = true;
      enableCamera = true;
      switchSpeaker = mtype == MediaType.audio ? true : false;
    });
    List<String> groupRefIDS = [];

    if (to == null) {
      print("one2many call");
      _showMyDialog(context);
    } else {
      if (callType == "one_to_many") {
        setState(() {
          groupBroadcast = true;
        });
      }
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
    Map<String, dynamic> customdata = {
      "calleName": "",
      "groupName": to == null ? null : to.group_title,
      "groupAutoCreatedValue": ""
    };
    signalingClient.startCallonetomany(
        customData: customdata,
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
    //await remoteRenderer.initialize();
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
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(days: 365),
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

        if (callProvider.callStatus == CallStatus.CallStart) {
          print("here in call provider status");

          return callStart();
        }
        if (callProvider.callStatus == CallStatus.CallDial)
          return callDial();
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
                              registerRes: registerRes,
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
  Container callStart() {
    //  inCall = true;
    print("this is media type $meidaType $remoteVideoFlag $enableCamera");
   
      return ispublicbroadcast
          ? Container(
              child: Stack(children: <Widget>[
            participantcount >= 1
                ? broadcasttype == "camera"
                    ? RTCVideoView(localRenderer,
                      key: forsmallView,
                      mirror: false,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                    : Container()
                : Container(),
            Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50.85),
                ),
                //backArrow(),
                participantcount < 1
                    ? SizedBox()
                    : Text(
                        "Public Broadcast",
                        style: TextStyle(
                            fontSize: 26,
                            decoration: TextDecoration.none,
                            fontFamily: secondaryFontFamily,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal,
                            color: darkBlackColor),
                      ),
                participantcount < 1 ? SizedBox() : Spacer(),
                participantcount < 1
                    ? SizedBox()
                    : FlatButton(
                        onPressed: () {
                          print(
                              "this is url for public broadcast $publicbroadcasturl");
                          Clipboard.setData(new ClipboardData(
                              text: publicbroadcasturl));
                        },
                        child: Text('Copy URL',
                            style: TextStyle(color: textTypeColor)),
                      ),
                participantcount < 1
                    ? SizedBox()
                    : Container(
                        child: Align(
                            alignment: Alignment.topRight,
                            // color: Colors.red,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      pressDuration,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 14,
                                          fontFamily: secondaryFontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          color: darkBlackColor),
                                    ),
                                  ),
                                  (broadcasttype == "camera")
                                      ? Container(
                                          // padding: EdgeInsets.zero,
                                          // height: 500,
                                          // width: 500,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 20, 0),

                                          child: GestureDetector(
                                            child: SvgPicture.asset(
                                                'assets/switch_camera.svg'),
                                            onTap: () {
                                              signalingClient.switchCamera();
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 20, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      //crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child:
                                              //SvgPicture.asset("assets/person.svg")
                                              Icon(
                                            Icons.person,
                                            color: participantcolor,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "+",
                                                style: TextStyle(
                                                    color: participantcolor),
                                              ),
                                              Text(
                                                "$participantcount",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontFamily:
                                                        secondaryFontFamily,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    fontStyle:
                                                        FontStyle.normal,
                                                    color: participantcolor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                              
                                ]))),
              ],
            ),
            // enableCamera
            //     ? RTCVideoView(widget.localRenderer,
            //         key: forsmallView,
            //         mirror: false,
            //         objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
            //
            //    : Container(),
            participantcount >= 1
                ? broadcasttype == "camera"
                    ? SizedBox()
                    : Center(
                        child: Text(
                          '''You are sharing your 
screen at the moment..''',
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.none,
                              fontFamily: searchFontFamily,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              color: screensharetextcolor),
                        ),
                      )
                : Center(
                    // padding: EdgeInsets.only(top: 55, left: 20),
                    //height: 79,
                    //width: MediaQuery.of(context).size.width,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // padding: EdgeInsets.only(top: 150, left: 50),
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
                        SizedBox(height: 20),
                        Container(
                            //padding: EdgeInsets.only(left: 65),
                            child: Image.asset(
                          'assets/broadcast.png',
                        )),
                        SizedBox(height: 40),
                        Container(
                          //  margin: EdgeInsets.only(left: 85),
                          width: 115,
                          height: 35,
                          decoration: BoxDecoration(
                              color: participantcolor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: FlatButton(
                            onPressed: () {
                              print(
                                  "this is url for public broadcast $publicbroadcasturl");
                              Clipboard.setData(new ClipboardData(
                                  text: publicbroadcasturl));
                            },
                            child: Text('Copy URL',
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
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
                  // meidaType == MediaType.video
                  //     ?
                  Row(
                    children: [
                      GestureDetector(
                          child: !enableCamera
                              ? broadcasttype == "camera"
                                  ? SvgPicture.asset('assets/video_off.svg')
                                  : SvgPicture.asset(
                                      'assets/screenshareon.svg')
                              : broadcasttype == "camera"
                                  ? SvgPicture.asset('assets/video.svg')
                                  : SvgPicture.asset(
                                      'assets/screenshareoff.svg'),
                          onTap: participantcount >= 1
                              ? () {
                                  setState(() {
                                    enableCamera = !enableCamera;
                                  });
                                  signalingClient.audioVideoState(
                                      audioFlag: switchMute ? 1 : 0,
                                      videoFlag: enableCamera ? 1 : 0,
                                      mcToken: registerRes["mcToken"]);
                                  signalingClient.enableCamera(enableCamera);
                                }
                              : null),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  // : SizedBox(),

                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/end.svg',
                    ),
                    onTap: () {
                      remoteVideoFlag = true;
                      stopCall();
                      setState(() {
                        isAppAudiobuttonSelected = false;
                        iscamerabuttonSelected = false;
                        ismicAudiobuttonSelected = false;
                        participantcount = 0;
                      });
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
                          ? broadcasttype == "camera" ||
                                  broadcasttype == "micaudio"
                              ? SvgPicture.asset('assets/mute_microphone.svg')
                              : SvgPicture.asset('assets/appaudioon.svg')
                          : broadcasttype == "camera" ||
                                  broadcasttype == "micaudio"
                              ? SvgPicture.asset('assets/microphone.svg')
                              : SvgPicture.asset('assets/appaudiooff.svg'),
                      onTap: participantcount >= 1
                          ? () {
                              final bool enabled = signalingClient.muteMic();
                              print("this is enabled $enabled");
                              setState(() {
                                switchMute = enabled;
                              });
                            }
                          : null),
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
   // });
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext dContext) {
        dialogBoxContext = dContext;
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
                            child: LinearProgressIndicator(
                              color: Colors.yellow,
                              backgroundColor: Colors.grey,
                            )),
                      ],
                    ),
                  ))),
        );
      },
    );
  }
}
