import 'package:flutter/foundation.dart';

enum CallStatus { Initial, CallReceive, CallStart, CallDial }

class CallProvider with ChangeNotifier {
  CallStatus _callStatus = CallStatus.Initial;
List<Map<String, dynamic>> _rendererListWithRefID = [

// {

// "i": "k",

// "j": "k",

// },

// {

// "i": "k",

// "j": "k",

// }

];



List<Map<String, dynamic>> get rendererListWithRefID =>

_rendererListWithRefID;
  CallStatus get callStatus => _callStatus;
  initial() {
    _callStatus = CallStatus.Initial;
    notifyListeners();
  }

  callReceive() {
    _callStatus = CallStatus.CallReceive;
    notifyListeners();
  }

  callStart() {
    _callStatus = CallStatus.CallStart;
    notifyListeners();
  }

  callDial() {
    print("i am here in call dial call provider");
    _callStatus = CallStatus.CallDial;
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
}
