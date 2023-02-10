import 'package:flutter/material.dart';

import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';
import '../../core/providers/groupListProvider.dart';

class HomeIndex extends StatefulWidget {
  @override
  _HomeIndexState createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPermissions();
  }
   Future<bool> _getPermissions() async {
    PermissionStatus cameraStatus;
    PermissionStatus audioStatus;

   
      cameraStatus = await Permission.camera.request();
      audioStatus = await Permission.microphone.request();
      print(
          "this is camera dn microphone permission $cameraStatus $audioStatus");
      if (cameraStatus.isPermanentlyDenied || audioStatus.isPermanentlyDenied) {
        openAppSettings();
      }
      if (cameraStatus.isGranted && audioStatus.isGranted) {
        return true;
      } else
       { return false;}
    
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<GroupListProvider>(
          create: (context) => GroupListProvider()),
      ChangeNotifierProvider(create: (context) => ContactProvider()),
      ChangeNotifierProvider(create: (context) => MainProvider()),
    ], child: Home());
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
