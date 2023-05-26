import 'package:flutter/foundation.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';

enum HomeStatus {
  CallReceive,
  CallStart,
  CallDial,
  ChatScreen,
  GroupListScreen,
  CreateIndividualGroup,
  CreateGroupChat,
  Home,
  NoInternet,
}

enum CallStatus {
  ActiveCall,
  InActiveCall,
}

class MainProvider with ChangeNotifier {
  CallStatus _callStatus = CallStatus.InActiveCall;
  HomeStatus _homeStatus = HomeStatus.Home;
  List<Map<String, dynamic>> _rendererListWithRefID = [
    // {
    //   "i": "k",
    //   "j": "k",
    // },
    // {
    //   "i": "k",
    //   "j": "k",
    // }
  ];

  List<Map<String, dynamic>> get rendererListWithRefID =>
      _rendererListWithRefID;
  CallStatus get callStatus => _callStatus;
  HomeStatus get homeStatus => _homeStatus;

  int _index = 0;
  int get index => _index;
  dynamic _publishMesg;
  dynamic get publishMesg => _publishMesg;
  dynamic _startCall;
  dynamic get startCall => startCall;
  GroupListProvider? _groupListProvider;
  GroupListProvider? get groupListProvider => _groupListProvider;
  ContactProvider? _contactProvider;
  ContactProvider? get contactProvider => _contactProvider;
  initial() {
    _homeStatus = HomeStatus.Home;
    print("i am here in initial  notify listener");
    notifyListeners();
  }

  handleState(HomeStatus state) {
    print("This is handle group list state $state");
    _homeStatus = state;

    notifyListeners();
  }

  addRendererList(Map<String, dynamic> rendererObject) {
    print("renderer list");
    _rendererListWithRefID.add(rendererObject);
    notifyListeners();
  }

  clearAllRendererList() {
    _rendererListWithRefID.clear();
    notifyListeners();
  }

  //  getPressure(String pp){
  //    _pressure=pp;
  //    print("SJNJSFBsjfbksjbfsj $_pressure");
  //    notifyListeners();
  //  }
  callReceive() {
    _homeStatus = HomeStatus.CallReceive;
    notifyListeners();
  }

  callStart() {
    _homeStatus = HomeStatus.CallStart;
    print("this is before call astart in call accept in call provider");
    notifyListeners();
  }

  noInternet() {
    _homeStatus = HomeStatus.NoInternet;
    notifyListeners();
  }

  callDial() {
    _homeStatus = HomeStatus.CallDial;
    print("In call provider. call dial");
    notifyListeners();
  }

  homeScreen() {
    _homeStatus = HomeStatus.Home;
    print("home screen");
    print("hghdfghfd $_homeStatus");
    notifyListeners();
  }

  chatScreen({int? index, GroupListProvider? groupListProvider}) {
    _index = index!;
    _homeStatus = HomeStatus.ChatScreen;
    print("chat screen in main provider $index");
    print("this is homeStatus $_homeStatus");
    notifyListeners();
  }

  groupListScreen() {
    _homeStatus = HomeStatus.GroupListScreen;
    print("group list screeen");
    notifyListeners();
  }

  createIndividualGroupScreen() {
    _homeStatus = HomeStatus.CreateIndividualGroup;
    print("create individual group");
    notifyListeners();
  }

  createGroupChatScreen() {
    _homeStatus = HomeStatus.CreateGroupChat;
    print("create group chat screen");
    notifyListeners();
  }

  activeCall() {
    _callStatus = CallStatus.ActiveCall;
    notifyListeners();
  }

  inActiveCall({
    dynamic startCall,
  }) {
    print("hereeeeee");
    // _startCall = startCall;
    _callStatus = CallStatus.InActiveCall;
    notifyListeners();
  }

  // callProgress(){
  //  // print("KLLLLLLLLL $isCall");
  //   _callProgress=CallStatus.CallProgress;
  //  // _callStatus=CallStatus.CallDial;
  //   notifyListeners();
  // }
}
