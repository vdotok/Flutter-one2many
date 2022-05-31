// import 'package:flutter/material.dart';
// import 'package:vdotok_vdotok/vdotok_vdotok.dart';
// import 'package:vdotok_vdotok_example/src/core/providers/call_provider.dart';
// import 'package:provider/provider.dart';

// class LocalStream extends StatefulWidget {
//   const LocalStream({Key key}) : super(key: key);

//   @override
//   _LocalStreamState createState() => _LocalStreamState();
// }

// class _LocalStreamState extends State<LocalStream> {
//   SignalingClient signalingClient = SignalingClient.instance;
//   RTCVideoRenderer _localRenderer = new RTCVideoRenderer();

//   CallProvider _callProvider;
//   // RTCVideoRenderer _remoteRenderer2 = new RTCVideoRenderer();
//   // RTCVideoRenderer _remoteRenderer3 = new RTCVideoRenderer();
//   // RTCVideoRenderer _remoteRenderer4 = new RTCVideoRenderer();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     initRenderers();
//     _callProvider = Provider.of<CallProvider>(context, listen: false);
//     signalingClient.onLocalStream = (stream) {
//       // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

// // Find the Scaffold in the widget tree and use it to show a SnackBar.
//       // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // print("this is remote stream id ${stream.id}");
//       setState(() {
//         _localRenderer.srcObject = stream;
//         // _time = DateTime.now();
//         // _updateTimer();
//         // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
//       });
//       //here
//       // _callBloc.add(CallStartEvent());
//       _callProvider.callStart();
//     };
//   }

//   initRenderers() async {
//     await _localRenderer.initialize();
//     // await _remoteRenderer2.initialize();
//     // await _remoteRenderer3.initialize();
//     // await _remoteRenderer4.initialize();
//   }

//   @override
//   dispose() {
//     // _localRenderer.dispose();
//     _localRenderer.dispose();
//     // _remoteRenderer2.dispose();
//     // _remoteRenderer3.dispose();
//     // _remoteRenderer4.dispose();
//     // _ticker.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RTCVideoView(_localRenderer,
//         mirror: false,
//         objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover);
//   }
// }
