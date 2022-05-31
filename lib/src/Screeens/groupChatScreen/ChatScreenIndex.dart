import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';

import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:provider/provider.dart';

import 'ChatScreen.dart';

class ChatScreenIndex extends StatefulWidget {
  final bool activeCall;
  //bool state;
  final handlePress;
  final int index;
  final publishMessage;
  // final VoidCallback  callbackfunction;
  final MainProvider mainProvider;
  final ContactProvider contactprovider;
  final funct;

  ChatScreenIndex({
    this.index,
    this.publishMessage,
    this.mainProvider,
    this.funct,
    this.contactprovider,
    this.handlePress,
    this.activeCall,
  });
  @override
  _ChatScreenIndexState createState() => _ChatScreenIndexState();
}

class _ChatScreenIndexState extends State<ChatScreenIndex> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // onPressed() {
  //   Provider.of<AuthProvider>(context).logout();
  // }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ElevatedButton(onPressed: onPressed, child: Text("logout")),
  //   );
  // }
  // Widget build(BuildContext context) {
  //   return MultiProvider(providers: [
  //     ChangeNotifierProvider<GroupListProvider>(
  //       create: (context) => GroupListProvider(),
  //     )
  //   ], child: Home(widget.state));
  // }
  Widget build(BuildContext context) {
    print("index in chat screen index ${widget.index}");
    return MultiProvider(
        providers: [
//  ChangeNotifierProvider<GroupListProvider>(
//  create: (context) => GroupListProvider()),
          ChangeNotifierProvider(create: (context) => ContactProvider()),
          ChangeNotifierProvider(create: (context) => MainProvider()),
          //ChangeNotifierProvider(create: (context) => GroupListProvider()),
          ////ChangeNotifierProvider(create: (context) => AuthProvider()),
          //ChangeNotifierProvider(create: (context) => GroupListProvider()),
        ],
        child: ChatScreen(
          activeCall: widget.activeCall,
          handlePress: widget.handlePress,
          index: widget.index,
          publishMessage: widget.publishMessage,
          mainProvider: widget.mainProvider,
          funct: widget.funct,
          contactprovider: widget.contactprovider,
        )
        //callbackfunction:widget.callbackfunction)
        );
  }
}
// class  extends StatefulWidget {
//   @override
//   _State createState() => _State();
// }

// class _State extends State<> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
