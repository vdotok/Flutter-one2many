import 'package:flutter/material.dart';
import 'package:flutter_onetomany/constant.dart';
import 'package:flutter_onetomany/src/core/providers/groupListProvider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../core/models/contact.dart';
import '../core/providers/auth.dart';

class CreateGroupPopUp extends StatefulWidget {
  const CreateGroupPopUp({
    Key key,
    @required TextEditingController groupNameController,
    List<Contact> selectedContacts,
    @required this.authProvider,
    this.controllerText,
    this.backHandler,
    this.editGroupName,
    this.groupid,
  // @required this.publishMessage,
  })  : _groupNameController = groupNameController,
        _selectedContacts = selectedContacts,
        super(key: key);

  final TextEditingController _groupNameController;
  // final ContactProvider contactProvider;
  // final GroupListProvider groupListProvider;
  final List<Contact> _selectedContacts;
  final AuthProvider authProvider;
  final String controllerText;
  //final publishMessage;
  final bool editGroupName;
  final backHandler;

  final int groupid;

  @override
  _CreateGroupPopUpState createState() => _CreateGroupPopUpState();
}

class _CreateGroupPopUpState extends State<CreateGroupPopUp> {
  GroupListProvider _groupListProvider;
  bool loading = false;
  @override
  void initState() {
    if (widget.controllerText != "" || widget.controllerText != null) {
      widget._groupNameController.text = widget.controllerText;
    }
    _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    showSnakbar(
      msg,
    ) {
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

    return GestureDetector(onTap: () {
      FocusScopeNode currentFous = FocusScope.of(context);
      if (!currentFous.hasPrimaryFocus) {
        currentFous.unfocus();
      }
    }, child: StatefulBuilder(builder: (context, setState) {
      var searchFontFamily;
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
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Create a group ",
                                style: TextStyle(
                                  color: norgicTalkColor,
                                  fontSize: 14,
                                  fontFamily: searchFontFamily,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              child: IconButton(
                                icon: SvgPicture.asset('assets/close.svg'),
                                onPressed: () {
                                  widget._groupNameController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24, top: 40.7, right: 24),
                        width: 271.36,
                        child: Text(
                          "Name your group chat",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: groupChtnmeColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 23, top: 9),
                        child: TextFormField(
                          controller: widget._groupNameController,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: (widget.controllerText == "" ||
                                    widget.controllerText == null)
                                ? "ex:Deeper Time"
                                : null,
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: textfieldhint,
                                fontFamily: secondaryFontFamily),
                          ),
                        ),
                      ),
                      Container(
                        width: 271.36,
                        height: 0.50,
                        color: Color(0xffd1d9df),
                      ),
                      SizedBox(height: 38),
                      Consumer<GroupListProvider>(
                        builder: (context, grouplistp, child) {
                          if (loading == false) {
                            return FlatButton(
                                color: doneButtonColor,
                                onPressed: () async {
                                  if (widget.editGroupName) {
                                          print("here");
 if (widget._groupNameController.text.isEmpty ||
                                      widget._groupNameController == null ) {
                                   
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });
                                          await grouplistp.editGroupName(
                                              widget._groupNameController.text,
                                              widget.groupid,
                                              widget.authProvider.getUser
                                                  .auth_token);
                                          if (grouplistp.editGroupNameStatus ==
                                              EditGroupNameStatus.Success) {
                                            showSnakbar(grouplistp.successMsg);
                                            widget._groupNameController.clear();
                                          } else if (grouplistp
                                                  .editGroupNameStatus ==
                                              EditGroupNameStatus.Failure) {
                                            showSnakbar(grouplistp.errorMsg);
                                          } else {}
                                          Navigator.of(context).pop();
                                             widget._groupNameController.clear();
                                        } }
                                        else{
                                  if (widget
                                          ._groupNameController.text.isEmpty ||
                                      widget._groupNameController == null ||
                                      widget._selectedContacts.length > 20) {
                                    return null;
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });
                                    var res =
                                        await _groupListProvider.createGroup(
                                            widget._groupNameController.text,
                                            widget._selectedContacts,
                                            widget.authProvider.getUser
                                                .auth_token);
                                    var groupModel = res["group"];
// grouplistp.addGroup(groupModel)
                                    if (res["is_already_created"] == true) {
                                      showSnakbar(
                                          "Group with same participants already creatd with \"${groupModel["group_title"]}\" name.");
setState(() {
                                      loading = false;
                                    });
                                    } else {
                                      print("here in back handler");
                                      _groupListProvider.addGroup(groupModel);
                                      
                                      this.widget.backHandler();
                                      Navigator.pop(context);
                                      setState(() {
                                      loading = false;
                                    });
                                    }

                                    
                                  }
                                }},
                                child: Container(
                                    width: 144,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: doneButtonColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "DONE",
                                      style: TextStyle(
                                        color: doneButtontextColor,
                                        fontSize: 14,
                                        fontFamily: primaryFontFamily,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.90,
                                      ),
                                    )));
                          } else
                            return Container(
                                width: 144,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // color: doneButtonColor,
                                ),
                                alignment: Alignment.center,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      chatRoomColor),
                                )));
                        },
                      )
                    ],
                  ))
            ])),
      );
    }));
  }
}
