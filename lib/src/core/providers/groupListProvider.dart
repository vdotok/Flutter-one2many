import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/GroupListModel.dart';
import '../models/GroupModel.dart';
import '../services/server.dart';

enum ListStatus {
  Scussess,
  Failure,
  Loading,
}

enum CreateChatStatus { New, Loading }

enum DeleteGroupStatus { Success, Failure, Loading }

enum EditGroupNameStatus { Success, Failure, Loading }

class GroupListProvider with ChangeNotifier {
  ListStatus _groupListStatus = ListStatus.Loading;
  ListStatus get groupListStatus => _groupListStatus;

  CreateChatStatus _createChatStatusStatus = CreateChatStatus.New;
  CreateChatStatus get creatChatStatusStatus => _createChatStatusStatus;

  DeleteGroupStatus _deleteGroupStatus = DeleteGroupStatus.Loading;
  DeleteGroupStatus get deleteGroupStatus => _deleteGroupStatus;

  EditGroupNameStatus _editGroupNameStatus = EditGroupNameStatus.Loading;
  EditGroupNameStatus get editGroupNameStatus => _editGroupNameStatus;

  GroupListModel? _groupList;
  GroupListModel? get groupList => _groupList;

  String? _successMsg;
  String? get successMsg => _successMsg;

  bool _callProgress = false;
  bool get callprogress => _callProgress;

  double _statsValue = 0;
  double get statsvalue => _statsValue;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  int? _status;
  int? get status => _status;

  handleGroupListState(ListStatus state) {
    print("This is handle group list state $state");
    _groupListStatus = state;

    notifyListeners();
  }

  // Emitter _emitter = Emitter.instance;
  handleCreateChatState() {
    if (_createChatStatusStatus == CreateChatStatus.New) {
      print("this is loading ");
      _createChatStatusStatus = CreateChatStatus.Loading;
    } else {
      _createChatStatusStatus = CreateChatStatus.New;
      print("here in create chat status $_createChatStatusStatus");
    }

    notifyListeners();
  }

  getGroupList(authToken) async {
    var currentData = await getAPI("AllGroups", authToken);
    print(
        "Current Data: ${currentData["status"]}......${currentData["groups"]}");
    print(
        "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      print("djghfghdf");
      _groupListStatus = ListStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } else {
      _groupListStatus = ListStatus.Scussess;
      _groupList = GroupListModel.fromJson(currentData);

      // _readmodelList = [];
      notifyListeners();
    }
  }

  addGroup(GroupModel groupModel) {
    _groupList!.groups!.insert(0, groupModel);
    notifyListeners();
  }

  changeState() {
    _groupListStatus = ListStatus.Scussess;
    notifyListeners();
  }

  deleteGroup(group_id, authtoken) async {
    print("group id is $group_id");
    Map<String, dynamic> jsonData = {"group_id": group_id};
    var currentData = await callAPI(jsonData, "DeleteGroup", authtoken);
    print("Current Data: $currentData");
    print(
        "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      _deleteGroupStatus = DeleteGroupStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } else {
      //_groupListStatus = ListStatus.Scussess;
      _deleteGroupStatus = DeleteGroupStatus.Loading;
      _deleteGroupStatus = DeleteGroupStatus.Success;
      _successMsg = "Group Deleted";
      _status = currentData["status"];
      // _deleteGroupStatus = DeleteGroupStatus.Loading;

      getGroupList(authtoken);

      notifyListeners();
    }
  }

  editGroupName(grouptitle, group_id, authtoken) async {
    print("group id is $group_id");
    Map<String, dynamic> jsonData = {
      "group_title": grouptitle,
      "group_id": group_id
    };
    var currentData = await callAPI(jsonData, "RenameGroup", authtoken);
    print("Current Data: $currentData");
    print(
        "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      _editGroupNameStatus = EditGroupNameStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } else {
      //_groupListStatus = ListStatus.Scussess;
      _editGroupNameStatus = EditGroupNameStatus.Loading;
      _editGroupNameStatus = EditGroupNameStatus.Success;
      _successMsg = currentData["message"];
      _status = currentData["status"];
      // _deleteGroupStatus = DeleteGroupStatus.Loading;

      getGroupList(authtoken);

      notifyListeners();
    }
  }
}
