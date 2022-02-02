import 'package:flutter/material.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

class RemoteStream extends StatefulWidget {
  const RemoteStream({Key key, this.remoteRenderer}) : super(key: key);
  final RTCVideoRenderer remoteRenderer;

  @override
  _RemoteStreamState createState() => _RemoteStreamState();
}

class _RemoteStreamState extends State<RemoteStream> {
//   SignalingClient signalingClient = SignalingClient.instance;
//   // RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();

//   CallProvider _callProvider;
//   // RTCVideoRenderer _remoteRenderer2 = new RTCVideoRenderer();
//   // RTCVideoRenderer _remoteRenderer3 = new RTCVideoRenderer();
//   // RTCVideoRenderer _remoteRenderer4 = new RTCVideoRenderer();
//   String ref_ID;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _callProvider = Provider.of<CallProvider>(context, listen: false);
//     signalingClient.onRemoteStream = (stream, refID) {
//       // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
//       ref_ID = refID;

//       _callProvider.addRenderer(refID, new RTCVideoRenderer());
//       initRenderers();
//       setState(() {
//         _callProvider.remoteRendererList[ref_ID].srcObject = stream;
//         // _time = DateTime.now();
//         // _updateTimer();
//         // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
//       });
// // Find the Scaffold in the widget tree and use it to show a SnackBar.
//       // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // print("this is remote stream id ${stream.id}");

//       //here
//       // _callBloc.add(CallStartEvent());
//       _callProvider.callStart();
//     };
//   }

//   initRenderers() async {
//     await _callProvider.remoteRendererList[ref_ID].initialize();
//     // await _remoteRenderer2.initialize();
//     // await _remoteRenderer3.initialize();
//     // await _remoteRenderer4.initialize();
//   }

//   @override
//   dispose() {
//     // _localRenderer.dispose();
//     _callProvider.remoteRendererList[ref_ID].dispose();
//     // _remoteRenderer2.dispose();
//     // _remoteRenderer3.dispose();
//     // _remoteRenderer4.dispose();
//     // _ticker.cancel();
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: RTCVideoView(this.widget.remoteRenderer,
          // key: forsmallView,
          mirror: false,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
    );
  }
}
