import 'package:flutter/material.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

class RemoteStream extends StatefulWidget {
  const RemoteStream({Key key, this.remoteRenderer}) : super(key: key);
  final RTCVideoRenderer remoteRenderer;

  @override
  _RemoteStreamState createState() => _RemoteStreamState();
}

class _RemoteStreamState extends State<RemoteStream> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10) // green as background color
          ),
      // borderRadius: BorderRadius.circular(10.0),
      child: RTCVideoView(this.widget.remoteRenderer,
          // key: forsmallView,
          mirror: false,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
    );
  }
}
