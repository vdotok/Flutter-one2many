import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:provider/provider.dart';
import '../CreateGroupScreen/CreateGroupChatScreen.dart';
import '../../core/providers/contact_provider.dart';

class CreateGroupChatIndex extends StatefulWidget {
  final MainProvider? mainProvider;
  final bool? activeCall;
  final handlePress;
  final funct;
  final refreshList;
  final ContactProvider? state;
  final GroupListProvider? groupListProvider;
  const CreateGroupChatIndex(
      {Key? key,
      this.funct,
      this.handlePress,
      this.activeCall,
      this.mainProvider,
      this.state,
      this.refreshList,
      this.groupListProvider})
      : super(key: key);

  @override
  _CreateGroupChatIndexState createState() => _CreateGroupChatIndexState();
}

class _CreateGroupChatIndexState extends State<CreateGroupChatIndex> {
  @override
  Widget build(BuildContext context) {
    print("this is str arr in createchat index $strArr");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ContactProvider()),
          ChangeNotifierProvider(create: (context) => MainProvider()),
        ],
        child: CreateGroupChatScreen(
            refreshList: widget.refreshList,
            state: widget.state!,
            mainProvider: widget.mainProvider!,
            activeCall: widget.activeCall!,
            handlePress: widget.handlePress,
            groupListProvider: widget.groupListProvider!,
            funct: widget.funct));
  }
}
