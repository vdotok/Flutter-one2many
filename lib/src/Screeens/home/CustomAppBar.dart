import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/broadcasting/BroadcastPopup.dart';
import 'package:flutter_one2many/src/core/models/GroupModel.dart';
import 'package:flutter_one2many/src/core/providers/auth.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/constant.dart';
import '../../core/providers/groupListProvider.dart';
import 'home.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final title;
  final isPublicBroadcast;
  final bool? lead;
  final succeedingIcon;
  final bool? ischatscreen;
  final index;
  final GroupListProvider? groupListProvider;
  final AuthProvider? authProvider;
  final MainProvider? mainProvider;
  final funct;
  final handlePress;
  final handlePublicBroadcastButton;

  CustomAppBar(
      {Key? key,
      this.groupListProvider,
      this.title,
      @required this.lead,
      this.succeedingIcon,
      this.ischatscreen,
      this.index,
      this.authProvider,
      this.mainProvider,
      this.funct,
      this.handlePress,
      this.isPublicBroadcast,
      this.handlePublicBroadcastButton})
      : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize {
    return ischatscreen!
        ? Size.fromHeight(80)
        : Size.fromHeight(kToolbarHeight);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Size get preferredSize {
    return widget.ischatscreen!
        ? Size.fromHeight(80)
        : Size.fromHeight(kToolbarHeight);
  }

  int _count = 0;
  Future buildShowDialog(
      BuildContext context, String mesg, String errorMessage) {
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
                  "${mesg}",
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
  Widget build(BuildContext context) {
    print("this is index in chat screen ${widget.mainProvider}");

    return AppBar(
      backgroundColor: widget.ischatscreen!
          ? appbarBackgroundColor
          : chatRoomBackgroundColor,
      elevation: 0.0,
      centerTitle: false,
      leading: widget.lead == true
          ? Padding(
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: chatRoomColor,
                ),
                onPressed: () {
                  isAppAudiobuttonSelected = false;
                  ismicAudiobuttonSelected = false;
                  iscamerabuttonSelected = false;
                  if (strArr.last == "GroupList") {
                    print("this is grpriiot");
                    widget.mainProvider!.homeScreen();
                  }
                },
              ),
            )
          : null,
      title: Text("${widget.title}",
          style: TextStyle(
            color: chatRoomColor,
            fontSize: 20,
            fontFamily: primaryFontFamily,
            fontWeight: FontWeight.w500,
          )),
      actions: [
        //If we are on chat screen//

        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: widget.succeedingIcon == ""
              ? Container()
              : IconButton(
                  icon: SvgPicture.asset(widget.succeedingIcon),
                  onPressed: widget.succeedingIcon == 'assets/plus.svg'
                      ? () {
                          print(
                              "THSI IS DFFVDFJCJDFBKJD ${widget.mainProvider}");
                          widget.mainProvider!.createGroupChatScreen();
                        }
                      : () {},
                ),
        ),
      ],
    );
  }
}
