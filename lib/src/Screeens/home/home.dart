import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_one2many/src/Screeens/CreateGroupScreen/CreateGroupChatIndex.dart';
import 'package:flutter_one2many/src/Screeens/callScreens/CallStartOnetoMany.dart';
import 'package:flutter_one2many/src/core/config/config.dart';
import 'package:flutter_one2many/src/core/models/GroupModel.dart';
import 'package:flutter_one2many/src/core/models/ParticipantsModel.dart';
import 'package:flutter_one2many/src/core/models/contact.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_one2many/src/grouplist/GroupListScreen.dart';
import 'package:flutter_one2many/src/shared_preference/shared_preference.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';
import '../../../main.dart';

import '../callScreens/CallDialScreen.dart';
import '../callScreens/CallReceiveScreen.dart';
import '../splash/splash.dart';
import '../../constants/constant.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/groupListProvider.dart';

import '../../Screeens/home/NoChatScreen.dart';
import 'landingScreen.dart';

GlobalKey<ScaffoldState> scaffoldKey;

bool enableCamera = true;
bool enableCamera2 = true;
String typeOfCall = "";
bool isDDialer = false;
bool switchMute = true;
bool switchMute2 = true;
DateTime time;
bool switchSpeaker = true;
SignalingClient signalingClient = SignalingClient.instance;
bool remoteVideoFlag = true;
String callTo = "";
bool groupBroadcast = false;
String incomingfrom;
bool onRemoteStream = false;
String publicbroadcasturl = "";
String errorcode = "";
List<String> strArr = [];
bool iscalloneto1 = false;
bool isRegisteredAlready = false;
var snackBar;
bool isGroupChatScreen = false;
bool isContactList = false;
Map<String, dynamic> forLargStream = {};
String meidaType = CallMediaType.video;
Timer _callticker;
bool isMultiSession = false;
String groupName = "";
bool isAppAudiobuttonSelected = false;
bool ismicAudiobuttonSelected = false;
bool iscamerabuttonSelected = false;
bool ispublicbroadcast = false;
String broadcasttype = "";
bool isDialer = false;
int participantcount = 0;
String pressDuration = "";
bool isInternetConnect = true;
GlobalKey forsmallView = new GlobalKey();
String session_type = "";
// bool isLocalStream=false;
//bool isPushed = false;

List<Map<String, dynamic>> rendererListWithRefID = [];
int count = 0;
bool isRinging = false;
Map<String, dynamic> customData;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  AuthProvider authProvider;
  GroupListProvider groupListProvider;
  ContactProvider contactProvider;
  MainProvider _mainProvider;
  DateTime _callTime;
  Timer _ticker;

  List<Contact> _selectedContacts = [];

  List<Uint8List> listOfChunks = [];
  Map<String, dynamic> header;
  bool scrollUp = false;

  bool istimerset = false;
  String mmtype = "";
  bool callSocket = true;
  bool isotheruser = false;
  bool isSocketregis = false;
  bool isDeviceConnected = false;
  bool chatSocket = true;

  bool iscallAcceptedbyuser = false;
  bool inInactive = false;

  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  MediaStream _localStream;

  final key1 = GlobalKey();
  int receiveMesgs;
  GlobalKey forlargView = new GlobalKey();
  GlobalKey forDialView = new GlobalKey();
  var registerRes;
  bool inCall = false;

  Map<String, dynamic> temp1;
  //String callTo = "";
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

  SharedPref sharedPref = SharedPref();
  bool remoteAudioFlag = true;

  int callDialCount;
  bool isTimer = false;
  bool isResumed = true;
  bool inPaused = false;
  List<ParticipantsModel> callingTo;

  var callDuration;
  //Map<String, dynamic> forLargStream = {};
  bool isReceive = false;
  int callReceiveCount;
  int missedCallCount;

  Future<bool> initRenderers(RTCVideoRenderer rtcRenderer) async {
    await rtcRenderer.initialize();
    return true;
    // await _localRenderer.initialize();
    //await _remoteRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print("i am here in  init state of home page ........$inCall");

  

    scaffoldKey = GlobalKey<ScaffoldState>();
   
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    _mainProvider = Provider.of<MainProvider>(context, listen: false);

    print("Hi i am parent class function");
    contactProvider.getContacts(authProvider.getUser.auth_token);
    groupListProvider.getGroupList(authProvider.getUser.auth_token);
    signalingClient.connect(
       authProvider.deviceId,
        project_id,
        authProvider.completeAddress,
        authProvider.getUser.authorization_token.toString(),
        authProvider.getUser.ref_id.toString()
        
        );
    // signalingClient.connect(project_id, authProvider.completeAddress);
    signalingClient.onConnect = (res) {
      print("onConnecttttttttttt signalining client $res");
      if (res == "connected") {
        callSocket = true;
        errorcode = "";
      }
    };
    signalingClient.onError = (code, reason) async {
      print("this is socket error $code $reason");
      if (!mounted) {
        return;
      }
      setState(() {
          errorcode = code.toString();
        callSocket = false;
      });

      if (authProvider.loggedInStatus == Status.LoggedOut) {
      } else {
        bool status = await signalingClient.getInternetStatus();

        print("this is internet status $status");

        if (callSocket == false && status == true) {
          print("here in onerrorrrrrr ");

         
        } else {
          print("else condition");
        }
      }
    };
  

     signalingClient.internetConnectivityCallBack = (mesg) {
      if (mesg == "Connected") {
        setState(() {
          if (inCall == true) {
            print("fdjhfjd");
            isTimer = true;
          }
          isInternetConnect = true;
          //  sockett = true;
        });
        // if (isResumed) {
        Fluttertoast.showToast(
            msg: "Connected to Internet.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0);
        // }
        print("khdfjhfj $isTimer");
        if (callSocket == false) {
          // signalingClient.connect(
          //     _auth.projectId,
          //     _auth.completeAddress,
          //     _auth.getUser.authorization_token.toString(),
          //     _auth.getUser.ref_id.toString());
          print("I am in Re Reregister ");
          remoteVideoFlag = true;
          print("here in init state register");
        }
      } else {
        print("onError no internet connection");
        setState(() {
          isInternetConnect = false;
          callSocket = false;
        });
        //  if (isResumed) {
        Fluttertoast.showToast(
            msg: "Waiting for Internet.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0);
        // }
        signalingClient.closeSocket();

        print("uyututuir");
      }
    };


    signalingClient.onRegister = (res) {
      print("onRegister  $res");
      setState(() {
        registerRes = res;
      });
      // signalingClient.register(user);
    };

    

    signalingClient.onLocalStream = (stream) async {
      print("this is local streammmm");
      Map<String, dynamic> temp = {
        "refID": authProvider.getUser.ref_id,
        "rtcVideoRenderer": RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
        "remoteAudioFlag": 1
      };
      await initRenderers(temp["rtcVideoRenderer"]).then((value) {
        setState(() {
          rendererListWithRefID.add(temp);
          rendererListWithRefID[0]["rtcVideoRenderer"].srcObject = stream;
        });
        print("this is onlocalstream length ${rendererListWithRefID.length}");
      });
    };

    signalingClient.onRemoteStream = (stream, refid) async {
      print("this is home page on remote stream $refid");
      Map<String, dynamic> temp = {
        "refID": refid,
        "rtcVideoRenderer": new RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == "video" ? 1 : 0,
        "remoteAudioFlag": 1
      };

      await initRenderers(temp["rtcVideoRenderer"]).then((value) {
        if (value) {
          setState(() {
            temp["rtcVideoRenderer"].srcObject = stream;
            rendererListWithRefID.add(temp);
            //print("this is remote ${stream.id}");
            if (isTimer == false) {
              time = DateTime.now();
              _callTime = DateTime.now();
            } else {
              //  _ticker.cancel();
              time = _callTime;
              isTimer = false;
            }
            print(
                "call callback on call left by participant2 ${rendererListWithRefID.length}");
           
            onRemoteStream = true;

            forLargStream = rendererListWithRefID[1];
            if (_callticker != null) {
              _callticker.cancel();
              count = 0;
              iscallAcceptedbyuser = true;
            }

            _mainProvider.callStart();
          });
        }
      });
    };
    signalingClient.onMissedCall = (mesg) {
      print("here in onmissedcall");
    };

    signalingClient.onReceiveCallFromUser = (res, isMultiSession
  

        ) async {
      print("call callback on call Received incomming ${res} ");

     

      setState(() {
        if (res["callType"] == "one_to_many") {
          groupBroadcast = true;
        }

        session_type = res["sessionType"];
        typeOfCall = res["callType"];
        inCall = true;
        Wakelock.toggle(enable: true);
        pressDuration = "";
        iscalloneto1 = typeOfCall == "one_to_one" ? true : false;
        onRemoteStream = false;
        incomingfrom = res["from"];
        meidaType = res["mediaType"];
        switchMute = true;
        switchMute2 = true;
        enableCamera = true;
        enableCamera2 = true;
        groupName =
            res["callType"] != "one_to_one" ? res["data"]["groupName"] : "";
        switchSpeaker = res["mediaType"] == "video" ? true : false;
        remoteVideoFlag = true;
        remoteAudioFlag = true;
        isReceive = true;
      });
      print("this is groupnameee $groupBroadcast");
      _mainProvider.callReceive();
      if (isMultiSession) {
        iscallAcceptedbyuser = false;
      } else {
        if (_callticker != null) {
          _callticker.cancel();
          _callticker =
              Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
        } else {
          _callticker =
              Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
        }
        
      }
    };
    signalingClient.onParticipantsLeft =
        (refID, receive, isMultisession) async {
      print(
          "call callback on call hungUpBy User2 ${refID} ${rendererListWithRefID.length} $callingTo $isDialer $receive");
     
      if (isMultisession) {
        rendererListWithRefID.length = 1;
      }

      if (refID == authProvider.getUser.ref_id) {
        print("here in user ref");
      } else {
        int index = rendererListWithRefID
            .indexWhere((element) => element["refID"] == refID);

        setState(() {
          if (typeOfCall == "one_to_many" && !receive) {
            print("jdhgdhgd");
            participantcount = participantcount - 1;
          }

          print("here in user ref2 $index");
          if (index != -1) {
            rendererListWithRefID.removeAt(index);
          }

          print(
              "call callback on call left by participant4 ${rendererListWithRefID.length} $callingTo");
          //v }
        });
      }
    };
    signalingClient.unRegisterSuccessfullyCallBack = () {
      authProvider.logout();
    };

    signalingClient.onAddparticpant = (paticipantcount, calltype) {
      print(
          "this is participant count ffffff $paticipantcount $calltype $_mainProvider");
      if (kIsWeb) {
        participantcount = paticipantcount - 1;
      } else {
        if (Platform.isIOS) {
          //   setState(() {
          participantcount = paticipantcount;

          typeOfCall = calltype;
          count = 0;
          iscallAcceptedbyuser = true;
          _callticker?.cancel();

          // _audioPlayer.stop();
          if (!ispublicbroadcast) {
            _mainProvider.callStart();
          }
          //   });
        } else {
          participantcount = paticipantcount - 1;
        }
      }
    };
    signalingClient.onCallDial = () {
      if (ispublicbroadcast == false) {
        _mainProvider.callDial();
      }
    };
    signalingClient.onTargetAlerting = () {
      setState(() {
        isRinging = true;
      });
    };
    signalingClient.onCallAcceptedByUser = () async {
      // if (reCall == false) {
      print("call callback on call Accepted $ispublicbroadcast $pressDuration");
      setState(() {
        if (typeOfCall == "one_to_many") {
          groupBroadcast = true;
        }
        if (isTimer == false) {
          time = DateTime.now();
          _callTime = DateTime.now();
        } else {
          // _ticker.cancel();
          time = _callTime;
          isTimer = false;
        }
        // _updateTimer();
        // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());

        iscallAcceptedbyuser = true;

        isReceive = false;
        inCall = true;
      });

      print("this is local renderer in if callacceptbyuser");

      if (!ispublicbroadcast) {
        print("this is before call astart in call accept");
        //  _audioPlayer.stop();
        _mainProvider.callStart();
      }

      print("this is before call astart in call accept11111111");
    };
    signalingClient.onReceiveUrlCallback = (url) {
      print("this is url from signalˆng client $url");
      publicbroadcasturl = url;

      Navigator.pop(context);
      if (isTimer == false) {
        time = DateTime.now();
        _callTime = DateTime.now();
      } else {
        // _ticker.cancel();
        time = _callTime;
        isTimer = false;
      }
      // _updateTimer();
      // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());

      _mainProvider.callStart();
    };
    signalingClient.onCallHungUpByUser = (isLocal) {
      print(
          "call callback on call hungUpBy User ${rendererListWithRefID.length} $isDialer $isReceive $inCall");

      if ((rendererListWithRefID.length == 0 ||
              rendererListWithRefID.length == 1 && isDialer) ||
          (rendererListWithRefID.length == 1 && isReceive) ||
          (rendererListWithRefID.length == 2) ||
          (rendererListWithRefID.length == 3) ||
          ((rendererListWithRefID.length == 4))) {
        print("sjgdhsjgdhgdshdsgjdhs");
        if (strArr.last == "LandingScreen") {
          print("here in oncallhungup index $listIndex");
          print("utuyy");
          _mainProvider.homeScreen();
        } else if (strArr.last == "CreateGroupChat") {
          _mainProvider.createGroupChatScreen();
        } else if (strArr.last == "GroupList") {
          _mainProvider.homeScreen();
        } else if (strArr.last == "NoChat") {
          _mainProvider.inActiveCall();
          _mainProvider.homeScreen();
          strArr.remove("NoChat");
        }
      }

      setState(() {
        Wakelock.toggle(enable: false);
        ispublicbroadcast = false;
        isDialer = false;
        isMultiSession = false;
        // isLocalStream=false;
        sharedPref.remove("inCall");
        groupBroadcast = false;
        callTo = "";
        isRinging = false;
        participantcount = 0;
        pressDuration = "";
        isAppAudiobuttonSelected = false;
        iscamerabuttonSelected = false;
        ismicAudiobuttonSelected = false;
        _ticker?.cancel();
        if (inCall) {
          if (_callticker != null) {
            _callticker.cancel();
          }
          //  _callticker?.cancel();
        }
        count = 0;
        iscallAcceptedbyuser = false;
        //   _audioPlayer.stop();
      });

      time = null;

      disposeAllRenderer();
      // if (isLocal == false) {
      print("hfgxf");
      //
      //  }

      // stopRinging();
    };
    signalingClient.insufficientBalance = (res) {
      print("here in insufficient balance");
      snackBar = SnackBar(content: Text('$res'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
    signalingClient.onCallBusyCallback = () {
      print("call callback on call busy");
      // _mainProvider.initial();
      snackBar = SnackBar(content: Text('User is busy with another call.'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    };

    signalingClient.onAudioVideoStateInfo = (audioFlag, videoFlag, refID) {
      print("call callback on call audioVideo status $audioFlag, $videoFlag");
      int index = rendererListWithRefID
          .indexWhere((element) => element["refID"] == refID);
      print("this is index $index");
      setState(() {
        if (index != -1) {
          rendererListWithRefID[index]["remoteVideoFlag"] = videoFlag;
          rendererListWithRefID[index]["remoteAudioFlag"] = audioFlag;
        } else {}
      });
    };
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

  disposeAllRenderer() async {
    print("this is listlength ${rendererListWithRefID.length}");
    for (int i = 0; i < rendererListWithRefID.length; i++) {
      if (i == 0) {
        print("here isssssssss ${rendererListWithRefID.length}");
        rendererListWithRefID[i]["rtcVideoRenderer"].srcObject = null;
       
      } else {
        await rendererListWithRefID[i]["rtcVideoRenderer"].dispose();
      }
    }

    // setState(() {
    if (rendererListWithRefID.length > 1) {
      print("yes i'm here ${rendererListWithRefID.length}");
      rendererListWithRefID.removeRange(1, (rendererListWithRefID.length));

      rendererListWithRefID.clear();
      print("yes i'm hereeeeee ${rendererListWithRefID.length}");
    }
    // });
  }

  @override
  void deactivate() {
    super.deactivate();
    print("gxhdghsgd");
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("this is changeapplifecyclestate");
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        isResumed = true;
        inPaused = false;
        inInactive = false;
        if (authProvider.loggedInStatus == Status.LoggedOut) {
        } else {
          //print("this is variable for resume $callSocket $isConnected $isResumed");
          bool connectionFlag = await signalingClient.getInternetStatus();
          // bool status=await signalingClient.checkInternetConnectivity();

          // if (connectionFlag == false) {
          //   Fluttertoast.showToast(
          //       msg: "Waiting for Internet.",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.TOP_RIGHT,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.black,
          //       textColor: Colors.white,
          //       fontSize: 14.0);
          // } else {
          //   Fluttertoast.showToast(
          //       msg: "Connected to Internet.",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.TOP_RIGHT,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.black,
          //       textColor: Colors.white,
          //       fontSize: 14.0);
          // }
          // if (connectionFlag && sockett == false) {
          //   signalingClient.connect(
          //       _auth.projectId,
          //       _auth.completeAddress,
          //       _auth.getUser.authorization_token.toString(),
          //       _auth.getUser.ref_id.toString());
          // }
        }

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
            // signalingClient.closeSocket();
          }
        }

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
          //  signalingClient.closeSocket();
        }
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
    // super.didChangeAppLifecycleState(state);
    // _isInForeground = state == AppLifecycleState.resumed;
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   print("this is changeapplifecyclestate $state");
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print("app in resumed");
  //       isResumed = true;
  //       inPaused = false;
  //       inInactive = false;
  //       if (authProvider.loggedInStatus == Status.LoggedOut) {
  //       } else {
  //         try {
  //           bool status = await signalingClient.checkInternetConnectivity();

  //           if (status == false) {
  //             Fluttertoast.showToast(
  //                 msg: "Waiting for Internet.",
  //                 toastLength: Toast.LENGTH_SHORT,
  //                 gravity: ToastGravity.TOP_RIGHT,
  //                 timeInSecForIosWeb: 1,
  //                 backgroundColor: Colors.black,
  //                 textColor: Colors.white,
  //                 fontSize: 14.0);
  //           } else {
  //             Fluttertoast.showToast(
  //                 msg: "Connected to Internet.",
  //                 toastLength: Toast.LENGTH_SHORT,
  //                 gravity: ToastGravity.TOP_RIGHT,
  //                 timeInSecForIosWeb: 1,
  //                 backgroundColor: Colors.black,
  //                 textColor: Colors.white,
  //                 fontSize: 14.0);
  //           }
  //           signalingClient.sendPing(registerRes["mcToken"]);
  //         } catch (e) {}
  //       }

  //       break;
  //     case AppLifecycleState.inactive:
  //       {
  //         print("app in inactive");
  //         inInactive = true;
  //         isResumed = false;
  //         inPaused = false;
  //         if (kIsWeb) {
  //         } else {
  //           // signalingClient.checkInternetConnectivity();
  //           // signalingClient.closeSocket();
  //           // if (Platform.isIOS) {
  //           //   if (inCall == true) {
  //           //     print("incall true");
  //           //   } else {
  //           //     // if (inCall == true) {
  //           //     //   print("incall true7");
  //           //     // } else {
  //           //     print("here in ininactive");
  //           //     signalingClient.closeSocket();
  //           //     // }
  //           //   }
  //           // }
  //         }
  //       }
  //       break;
  //     case AppLifecycleState.paused:
  //       print("app in paused");
  //       inPaused = true;
  //       isResumed = false;
  //       inInactive = false;
  //       if (inCall == true) {
  //         print("incall true");
  //       } else {
  //         print("incall false");
  //         // signalingClient.closeSocket();
  //       }
  //       break;
  //     case AppLifecycleState.detached:
  //       print("app in detached");
  //       // Navigator.pop(context);
  //       //   if(Platform.isIOS)
  //       //  { if(inCall){
  //       //     signalingClient.stopReplayKitLauncher();
  //       //   }}
  //       // signalingClient.unRegister(registerRes["mcToken"]);

  //       break;
  //   }
  //   // super.didChangeAppLifecycleState(state);
  //   // _isInForeground = state == AppLifecycleState.resumed;
  // }

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
  }

  void _updateTimer() {
    print("time value is $time ");
    final duration = time != null ? DateTime.now().difference(time) : null;
    final newDuration = duration != null ? _formatDuration(duration) : null;
    if (mounted) {
      setState(() {
        // Your state change code goes here
        pressDuration = newDuration;
        print(
            "IN SET STATE SINGNALING CLIENT>PRESS DURATIONnnnnn $pressDuration");
      });
    }
    //  setState(() {

    //   });
  }

  _startCall({
    GroupModel to,
    String mtype,
    String callType,
    String sessionType,
  }) async {
    //mmtype=mtype;
    // print(
    //     "call callback on call Received incomming2  ${to.group_title} $callType $mtype $isDialer $switchSpeaker");
    setState(() {
      Wakelock.toggle(enable: true);
      typeOfCall = callType;
      isDialer = true;
      inCall = true;
      pressDuration = "";
      meidaType = mtype;
      switchMute = true;
      switchMute2 = true;
      enableCamera = true;
      enableCamera2 = true;
      onRemoteStream = false;
      switchSpeaker = mtype == "video" ? true : false;
    });

    List<String> groupRefIDS = [];
// if(Platform.isAndroid)
//     {final file = new File('${(await getTemporaryDirectory()).path}/music.mp3');
//     await file.writeAsBytes(
//         (await rootBundle.load("assets/audio.mp3")).buffer.asUint8List());
//     // int res = await _audioPlayer.earpieceOrSpeakersToggle();
//     // print("thogh $res");
//     // if (res == 1) {
//     await _audioPlayer.play(file.path, isLocal: true);}
//     //await _audioPlayer.earpieceOrSpeakersToggle();
//     //}
    //int result=
    if (to == null) {
      if (callType == "one_to_one") {
      } else {
        print("one2many call");
        Dialogs _dialog = new Dialogs();
        _dialog.loginLoading(context, "loading", "loading...");
      }
    } else {
      if (callType == "one_to_many") {
        setState(() {
          groupBroadcast = true;
        });
      }

      callingTo = to.participants;
      print("this is tooooo list $to $callingTo");
      to.participants.forEach((element) {
        if (authProvider.getUser.ref_id != element.ref_id)
          groupRefIDS.add(element.ref_id.toString());
      });
    }

    print(
        "this is signaling client start callllllll $ispublicbroadcast $broadcasttype..... $sessionType ${registerRes["mcToken"]}");
    if (callType == "one_to_many") {
      print("here in one2many call start");
      if (to == null) {
        customData = {
          "calleName": "",
          "groupName": "",
          "groupAutoCreatedValue": ""
        };
      } else {
        customData = {
          "calleName": "",
          "groupName": groupName,
          "groupAutoCreatedValue": "",
          // "typeOfBroadcast": broadcasttype
        };
      }
print("custom data $customData");
      signalingClient.startCallOneToMany(
          customData: customData,
          from: authProvider.getUser.ref_id,
          to: groupRefIDS,
          mcToken: registerRes["mcToken"],
          mediaType: mtype,
          callType: callType,
          sessionType: sessionType,
          isPublicBroadcast: ispublicbroadcast,
          broadcastType: broadcasttype,
          authorizationToken: authProvider.getUser.authorization_token);
//  if (to != null) {
//     //  if (isLocalStream)
//     // {
//       _mainProvider.callDial();}
      // }
      if (_callticker != null) {
        _callticker.cancel();
        _callticker = Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
      } else {
        _callticker = Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
      }
    
    }
  }

  _callcheck() {
    print("i am here in call chck function $count");

    count = count + 1;

    if (count == 30 && iscallAcceptedbyuser == false) {
      print("I am here in stopcall if");

      _callticker.cancel();

      count = 0;

      signalingClient.stopCall(registerRes["mcToken"]);

      // _mainProvider.initial();

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

  // startRinging() async {
  //   if (kIsWeb) {
  //   } else {
  //     if (Platform.isAndroid) {
  //       if (await Vibration.hasVibrator()) {
  //         Vibration.vibrate(pattern: vibrationList);
  //       }
  //     }
  //   }
  //   FlutterRingtonePlayer.play(
  //     android: AndroidSounds.ringtone,
  //     ios: IosSounds.glass,
  //     looping: true, // Android only - API >= 28
  //     volume: 1.0, // Android only - API >= 28
  //     asAlarm: false, // Android only - all APIs
  //   );
  // }

  // stopRinging() {
  //   print("this is on rejected ");
  //   if (kIsWeb) {
  //   } else {
  //     vibrationList.clear();

  //     Vibration.cancel();
  //     FlutterRingtonePlayer.stop();
  //   }
  // }

  @override
  dispose() {
    // _localRenderer.dispose();
    // _remoteRenderer.dispose();
    // Connectivity().onConnectivityChanged.cancel();
    //signalingClient.appDetached();
    print("hoem dispose");
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  stopCall() {
    signalingClient.stopCall(registerRes["mcToken"]);

    print("here in stop call");
    if (_ticker != null) {
      _ticker.cancel();
    }
    setState(() {
      groupBroadcast = false;
      //isDialer = false;
      ispublicbroadcast = false;
      inCall = false;
      pressDuration = "";
      onRemoteStream = false;
    });
    if (strArr.last == "LandingScreen") {
      //  print("here in oncallhungup index $listIndex");
      print("porierio");
      _mainProvider.homeScreen();
    }
    if (strArr.last == "CreateGroupChat") {
      _mainProvider.createGroupChatScreen();
    } else if (strArr.last == "GroupList") {
      _mainProvider.homeScreen();
    } else if (strArr.last == "NoChat") {
      _mainProvider.inActiveCall();
      _mainProvider.homeScreen();
      strArr.remove("NoChat");
    }

    // if (!kIsWeb) stopRinging();
  }

  Future<Null> refreshList() async {
    setState(() {
      print("IN SET STATE EMOITER>REFRESH LIST");
      renderList();
      // rendersubscribe();
    });
    return;
  }

  handleCreateGroup(HomeStatus state) {
    print("here in handle create group $state");
    _mainProvider.handleState(state);
    // _mainProvider.inActiveCallCreateGroup(startCall: _startCall);
  }

  renderList() {
    if (groupListProvider.groupListStatus == ListStatus.Scussess) {
      groupListProvider.getGroupList(authProvider.getUser.auth_token);
    } else {
      contactProvider.getContacts(authProvider.getUser.auth_token);
      _selectedContacts.clear();
    }
    if (callSocket == false && isInternetConnect) {
      print("here in refreshlist connection");
      signalingClient.connect(
        authProvider.deviceId,
        project_id,
        authProvider.completeAddress,
        authProvider.getUser.authorization_token.toString(),
        authProvider.getUser.ref_id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    Future<bool> _onWillPop() async {}

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer4<GroupListProvider, AuthProvider, MainProvider,
                ContactProvider>(
            // ignore: missing_return
            builder: (context, listProvider, authProvider, mainProvider,
                contactProvider1, child) {
          print(
              "these are statesss ${listProvider.groupListStatus} ${mainProvider.homeStatus}");
          //When the Screen is Laoding//
          if (listProvider.groupListStatus == ListStatus.Loading) {
            print("this is strarray0 $strArr");
            return SplashScreen();
            print("xjghcxghxg");
            // return LandingScreen(

            //   grouplistprovider: groupListProvider,
            //   startCall: _startCall,
            //   authprovider: authProvider,
            //   registerRes: registerRes,
            //   isdev: isInternetConnect,
            //   sockett: callSocket,
            // );
          } else if (listProvider.groupListStatus == ListStatus.Scussess) {
            if (mainProvider.homeStatus == HomeStatus.CallReceive) {
              print(
                  "this is call resceive screen ${contactProvider.contactList}");

              return CallReceiveScreen(
                groupName: groupName,
                //  rendererListWithRefID:rendererListWithRefID,
                mediaType: meidaType,
                //localRenderer: _localRenderer,
                incomingfrom: incomingfrom,
                mainProvider: _mainProvider,
                registerRes: registerRes,
                authProvider: authProvider,
                from: authProvider.getUser.ref_id,
                //   stopRinging: stopRinging,
                signalingClient: signalingClient,
                authtoken: authProvider.getUser.auth_token,
                contactList: contactProvider1.contactList,
                groupListProvider: groupListProvider,
              );
            } else if (mainProvider.homeStatus == HomeStatus.CallStart) {
              print("this is call start screen");
              //  if (typeOfCall == "one_to_many") {
              return CallStartOnetoMany(
                //localRenderer: _localRenderer,
                mainProvider: _mainProvider,
                stopCall: stopCall,
                registerRes: registerRes,
                remoteRenderer: _remoteRenderer,
              );
              // }
            } else if (mainProvider.homeStatus == HomeStatus.CallDial) {
              print("this is call dial screen");
              return CallDialScreen(
                  callingTo: callingTo,
                  mediaType: meidaType,
                  // localRenderer: _localRenderer,
                  incomingfrom: incomingfrom,
                  mainProvider: _mainProvider,
                  registerRes: registerRes,
                  authProvider: authProvider,
                  groupListProvider: groupListProvider);
            }

            //In case of success//
            else if (_mainProvider.homeStatus == HomeStatus.Home) {
              if (strArr.contains("LandingScreen")) {
              } else {
                strArr.add("LandingScreen");
              }
              return LandingScreen(
                mainProvider: mainProvider,
                grouplistprovider: groupListProvider,
                refreshList: refreshList,
                startCall: _startCall,
                authprovider: authProvider,
                registerRes: registerRes,
                isdev: isInternetConnect,
                sockett: callSocket,
              );
            }
            // else if()
            else if (_mainProvider.homeStatus == HomeStatus.GroupListScreen) {
              //Screen when there is no group or chat in Chat Room//
              if (listProvider.groupList.groups.isEmpty) {
                if (strArr.contains("NoChat")) {
                } else {
                  strArr.add("NoChat");
                }
                print("this is strarray1 $strArr");
                print("no chat screen");
                return NoChatScreen(
                  activeCall: false,
                  chatSocket: chatSocket,
                  startCall: _startCall,
                  callSocket: callSocket,
                  registerRes: registerRes,
                  isConnect: isInternetConnect,
                  groupListProvider: groupListProvider,
                  refreshList: refreshList,
                  authProvider: authProvider,
                  handlePress: handleCreateGroup,
                  presentCheck: true,
                  mainProvider: mainProvider,
                );
              }
              // //Screen with chats in Chat Room//
              else {
                if (strArr.contains("GroupList")) {
                } else {
                  strArr.add("GroupList");
                }
                print("this is strarray2 $strArr");
                print("this is group list screen");
                return GroupListScreen(
                  // handlePublicBroadcastButton: PublicBroadCastPopUp,
                  // handleSeenStatus:handleSeenStatus,
                  activeCall: false,
                  state: groupListProvider.groupList,
                  groupListProvider: groupListProvider,
                  mainProvider: _mainProvider,
                  authProvider: authProvider,
                  contactProvider: contactProvider,
                  handlePress: handleCreateGroup,
                  refreshList: refreshList,
                  chatSocket: chatSocket,
                  callSocket: callSocket,
                  isInternet: isInternetConnect,
                  startCall: _startCall,
                  registerRes: registerRes,
                );
              }
            } else if (mainProvider.homeStatus == HomeStatus.CreateGroupChat) {
              if (strArr.contains("CreateGroupChat")) {
              } else {
                strArr.add("CreateGroupChat");
              }
              print("this is strarray6 $strArr");
              print("this is create group screen");
              return CreateGroupChatIndex(
                  refreshList: refreshList,
                  mainProvider: _mainProvider,
                  state: contactProvider,
                  activeCall: false,
                  groupListProvider: groupListProvider,
                  handlePress: handleCreateGroup);
            }
          } else {
            return LandingScreen(
              mainProvider: mainProvider,
              grouplistprovider: groupListProvider,
              startCall: _startCall,
              authprovider: authProvider,
              registerRes: registerRes,
              isdev: isInternetConnect,
              sockett: callSocket,
            );
            // return Scaffold(
            //   appBar: CustomAppBar(
            //     groupListProvider: groupListProvider,
            //     title: "",
            //     lead: false,
            //     funct: _startCall,
            //     mainProvider: _mainProvider,
            //     succeedingIcon: 'assets/plus.svg',
            //     ischatscreen: false,
            //     handlePress: handleCreateGroup,
            //     isPublicBroadcast: true,
            //   ),
            //   body: Center(
            //       child: Text(
            //     "${listProvider.errorMsg}",
            //     style:
            //         TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            //   )),
            // );
          }
        }));
  }
}

class Dialogs {
  loginLoading(BuildContext context, String type, String description) {
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
                              child: LinearProgressIndicator(
                                color: Colors.yellow,
                                backgroundColor: Colors.grey,
                              )),
                        ],
                      ),
                    ))),
          );
        });
  }
}
