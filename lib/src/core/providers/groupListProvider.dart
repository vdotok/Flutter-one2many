import 'package:flutter/foundation.dart';
import 'package:flutter_onetomany/src/core/models/GroupListModel.dart';
import '../models/GroupModel.dart';
import '../services/server.dart';

enum ListStatus { Scussess, Failure, Loading, CreateGroup ,SelectBroadCast}
enum DeleteGroupStatus { Success, Failure, Loading }
enum EditGroupNameStatus { Success, Failure, Loading }
class GroupListProvider with ChangeNotifier {
  ListStatus _groupListStatus = ListStatus.Loading;
  ListStatus get groupListStatus => _groupListStatus;
  EditGroupNameStatus _editGroupNameStatus = EditGroupNameStatus.Loading;
  EditGroupNameStatus get editGroupNameStatus => _editGroupNameStatus;
  GroupListModel _groupList;
  GroupListModel get groupList => _groupList;
 DeleteGroupStatus _deleteGroupStatus = DeleteGroupStatus.Loading;
  DeleteGroupStatus get deleteGroupStatus => _deleteGroupStatus;
  String _errorMsg;
  String get errorMsg => _errorMsg;

  String _successMsg;
  String get successMsg => _successMsg;
  int _status;
  int get status => _status;

  handleGroupListState(ListStatus state) {
    print("This is handle group list state");
    _groupListStatus = state;
    notifyListeners();
  }

  getGroupList(authToken) async {
    if (_groupListStatus != ListStatus.Loading) {
      _groupListStatus = ListStatus.Loading;
      notifyListeners();
    }
    var currentData = await getAPI("AllGroups", authToken);
    print(
        "Current Data: ${currentData["status"]}......${currentData["groups"]}");
    print(
        "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      _groupListStatus = ListStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } else {
     // _groupListStatus = ListStatus.Scussess;
     _groupListStatus = ListStatus.SelectBroadCast;
      _groupList = GroupListModel.fromJson(currentData);

   
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
  addGroup(dynamic groupModel) {
    print("this is add group");
    _groupList.groups.insert(0, GroupModel.fromJson(groupModel));
    notifyListeners();
  }

  Future<dynamic> createGroup(groupName, _selectedContacts, authToken) async {
    List<int> id_List = [];
    for (int i = 0; i < _selectedContacts.length; i++) {
      id_List.add(_selectedContacts[i].user_id);
      print("Here id List: $id_List");
    }
    var newtemp = {
      'group_title': groupName,
      'participants': id_List,
      'auto_created': _selectedContacts.length == 1 ? 1 : 0
    };

    print("newtemp  .... ${newtemp}");
    final response = await callAPI(newtemp, "CreateGroup", authToken);
    print("the current data is: $response");
    return response;
    //  notifyListeners();
  }
}
