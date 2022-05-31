import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/core/providers/groupListProvider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:provider/provider.dart';
import '../ContactListScreen/ContactListScreen.dart';
import '../../core/providers/contact_provider.dart';

class ContactListIndex extends StatefulWidget {
  final bool activeCall;
  final mcToken;
  final handlePress;
  final funct;
  final ContactProvider state;
  final MainProvider mainProvider;
  final refreshList;
  final GroupListProvider groupListProvider;
  const ContactListIndex(
      {Key key,
      this.funct,
      this.mainProvider,
      this.handlePress,
      this.mcToken,
      this.activeCall,
      this.groupListProvider,
      this.state,
      this.refreshList})
      : super(key: key);

  @override
  _ContactListIndexState createState() => _ContactListIndexState();
}

class _ContactListIndexState extends State<ContactListIndex> {
  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(create: (context) => ContactProvider(), child: ContactListScreen());

  // }
  @override
  Widget build(BuildContext context) {
    print("this is str arr in contactlist index $strArr");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ContactProvider()),
          ChangeNotifierProvider(create: (context) => MainProvider()),
        ],
        child: ContactListScreen(
            refreshList: widget.refreshList,
            activeCall: widget.activeCall,
            handlePress: widget.handlePress,
            funct: widget.funct,
            state: widget.state,
            mainProvider: widget.mainProvider,
            mcToken: widget.mcToken,
            groupListProvider: widget.groupListProvider));
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter-combine/src/core/providers/call_provider.dart';
// import '../ContactListScreen/ContactListScreen.dart';
// import '../../core/providers/contact_provider.dart';

// class ContactListIndex extends StatefulWidget {
//   final VoidCallback callbackfunction;
//   const ContactListIndex({Key key, this.callbackfunction}) : super(key: key);

//   @override
//   _ContactListIndexState createState() => _ContactListIndexState();
// }

// class _ContactListIndexState extends State<ContactListIndex> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(providers: [
//       ChangeNotifierProvider(create: (context) => ContactProvider()),
//     //  ChangeNotifierProvider(create: (context) => CallProvider()),
//     ], child: ContactListScreen(callbackfunction:widget.callbackfunction));
//   }
// }
