import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/Screeens/login/SignInScreen.dart';
import 'package:flutter_one2many/src/Screeens/splash/splash.dart';
import 'package:flutter_one2many/src/core/providers/auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'src/Screeens/home/homeIndex.dart';
import 'src/constants/constant.dart';
import 'src/routing/routes.dart';


GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
     //_getPermissions();
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
  void dispose() {
    print("gejghrejgr");
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..isUserLogedIn()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            accentColor: primaryColor,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: secondaryColor),
              bodyText2: TextStyle(color: secondaryColor), //Text
            )),
        onGenerateRoute: Routers.generateRoute,
        home: Scaffold(
          body: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (auth.loggedInStatus == Status.Authenticating)
                return SplashScreen();
              else if (auth.loggedInStatus == Status.LoggedIn) {
                // return Test();
               
                return HomeIndex();
                //return Hello();
              } else
                // return Test();
                return SignInScreen();
              //   return SelecturlScreen();,
            },
          ),
        ),
      ),
    );
  }
}

class Hello extends StatefulWidget {
  @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: Container(
          height: 100,
          width: 100,
          color: Colors.amber,
          child: Text("fujhfdujf")),
      //feedback:
      // Container(),
      feedback: Container(
          height: 100,
          width: 100,
          color: Colors.amber,
          child: Text("fujhfdujf")),
      childWhenDragging: Container(
          height: 100,
          width: 100,
          color: Colors.amber,
          child: Text("fujhfdujf")),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SignalingClient signalingClient;
  MediaStream _localStream;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _screenShareRenderer = new RTCVideoRenderer();
  @override
  void initState() {
    // TODO: implement initState

    initRenderers();

    signalingClient = SignalingClient.instance;
    // signalingClient.methodInvoke();
    super.initState();
    // initRenderers();

    signalingClient?.onLocalStream = (stream) {
      print("this is local stream ${stream}");
      if (_localRenderer.srcObject == null) {
        setState(() {
          _localRenderer.srcObject = stream;
        });
      } else {
        setState(() {
          _screenShareRenderer.srcObject = stream;
        });
      }
    };
    // signalingClient.getPermissions();
  }

  Future<void> initRenderers() async {
    // if (type == "screen") {
    // await _screenShareRenderer.initialize();
    // } else {
    await _localRenderer.initialize();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: _localRenderer == null
                  ? Text("camera")
                  : _localRenderer.srcObject == null
                      ? Text("camera")
                      : RTCVideoView(_localRenderer, mirror: false),
            ),
            Container(
              width: 200,
              height: 200,
              child: _localRenderer == null
                  ? Text("camera")
                  : _screenShareRenderer.srcObject == null
                      ? Text("screen")
                      : RTCVideoView(_screenShareRenderer, mirror: false),
            ),
            ElevatedButton(
              onPressed: () {
                signalingClient?.getNumber();
              },
              child: Text("Create peerConnection"),
            ),
            ElevatedButton(
              onPressed: () {
                // signalingClient.creteOffermannual();
              },
              child: Text("createOffer"),
            ),
            ElevatedButton(
              onPressed: () {
                signalingClient?.getMedia();
              },
              child: Text("getUserMedia"),
            ),
            ElevatedButton(
              onPressed: () {
                signalingClient?.getDisplay();
              },
              child: Text("getUserDisplayMedia"),
            ),
            ElevatedButton(
              onPressed: () {
                signalingClient?.connect(
                    "176GK5IN", "wss://q-signalling.vdotok.dev:8443/call");
              },
              child: Text("connect"),
            )
          ],
        ),
      ),
    );
  }
}






