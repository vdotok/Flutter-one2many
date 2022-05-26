import 'dart:io';
import 'package:flutter/material.dart';

import 'package:vdotok_stream/vdotok_stream.dart';
import 'src/core/providers/auth.dart';
import 'src/core/providers/call_provider.dart';
import 'src/core/providers/contact_provider.dart';
import 'src/core/providers/groupListProvider.dart';
import 'src/home/homeIndex.dart';
import 'src/login/SignInScreen.dart';

import 'src/routing/routes.dart';
import 'src/splash/splash.dart';
import 'package:provider/provider.dart';

import 'constant.dart';

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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..isUserLogedIn()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => GroupListProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Vdotok Video',
        theme: ThemeData(
            accentColor: primaryColor,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: secondaryColor),
              bodyText2: TextStyle(color: secondaryColor),
            )),
        onGenerateRoute: Routers.generateRoute,
        home: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if (auth.loggedInStatus == Status.Authenticating)
              return SplashScreen();
            else if (auth.loggedInStatus == Status.LoggedIn) {
              return HomeIndex();
              return Test();
            } else
               return SignInScreen();
              return Test();
          },
        ),
      ),
    );
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => AuthProvider()..isUserLogedIn()),
    //   ],
    //   child: MaterialApp(
    //     scaffoldMessengerKey: rootScaffoldMessengerKey,
    //     debugShowCheckedModeBanner: false,
    //     title: 'Vdotok Video',
    //     theme: ThemeData(
    //         colorScheme: ColorScheme.fromSwatch(
    //           primarySwatch: Colors.grey,
    //         ).copyWith(),
    //         accentColor: primaryColor,
    //         primaryColor: primaryColor,
    //         scaffoldBackgroundColor: Colors.white,
    //         textTheme: TextTheme(
    //           bodyText1: TextStyle(color: secondaryColor),
    //           bodyText2: TextStyle(color: secondaryColor), //Text
    //         )),
    //     onGenerateRoute: Routers.generateRoute,
    //     home: Consumer<AuthProvider>(
    //       builder: (context, auth, child) {
    //         if (auth.loggedInStatus == Status.Authenticating)
    //           return SplashScreen();
    //         else if (auth.loggedInStatus == Status.LoggedIn) {
    //          // return Test();
    //          return HomeIndex();
    //         } else {
    //          // return Test();
    //           return SignInScreen();
    //         }
    //       },
    //     ),
    //   ),
    // );
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
    await _screenShareRenderer.initialize();
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
            RaisedButton(
              onPressed: () {
                signalingClient?.getNumber();
              },
              child: Text("Create peerConnection"),
            ),
            RaisedButton(
              onPressed: () {
                // signalingClient.creteOffermannual();
              },
              child: Text("createOffer"),
            ),
            RaisedButton(
              onPressed: () {
                signalingClient?.getMedia();
              },
              child: Text("getUserMedia"),
            ),
            RaisedButton(
              onPressed: () {
                signalingClient?.getDisplay();
              },
              child: Text("getUserDisplayMedia"),
            ),
            RaisedButton(
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
