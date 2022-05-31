import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_one2many/src/Screeens/callScreens/StreamBar.dart';
import 'package:flutter_one2many/src/Screeens/home/home.dart';
import 'package:flutter_one2many/src/core/providers/contact_provider.dart';
import 'package:flutter_one2many/src/core/providers/main_provider.dart';
import 'package:flutter_one2many/src/shared_preference/shared_preference.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:intl/intl.dart';
import '../groupChatScreen/AddAttachmentsPopUp.dart';
import '../home/CustomAppBar.dart';
import '../../constants/constant.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/groupListProvider.dart';
import '../groupChatScreen/AudioWidget.dart';

bool isCallinProgress1 = false;

//  DateTime timee;
class ChatScreen extends StatefulWidget {
  final bool activeCall;
  final int index;
  final publishMessage;
  final funct;
  final handlePress;
  final int receiveMesgs;
  //final VoidCallback  callbackfunction;
  final MainProvider mainProvider;
  final ContactProvider contactprovider;

  const ChatScreen({
    Key key,
    this.index,
    this.publishMessage,
    this.mainProvider,
    this.funct,
    this.contactprovider,
    this.receiveMesgs,
    this.handlePress,
    this.activeCall,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int get index => widget.index;
  AuthProvider authProvider;
  GroupListProvider _groupListProvider;
  ScrollController secondcontroller;
//ContactProvider contactprovider;
  //AutoScrollController controller;
  ScrollController controller = ScrollController();
  final TextEditingController messageController = TextEditingController();
  final picker = ImagePicker();
  Uint8List _fromChunks;
  bool scrollUp = false;
  var date = "";
  bool _isPlaying = false;
  var _completedPercentage = 0.0;
  var _totalDuration;
  var _currentDuration;
  File image;
  //Timer _tickerr;
  String pressDurationn = "";
  int mesgSent;
  int get mesgReceived => widget.receiveMesgs;
  SharedPref sharedPref = SharedPref();

  isValuePresent(String key, int value) async {
    // final prefs = await SharedPreferences.getInstance();
    final counter = await sharedPref.readInteger(key);
    print("this is sent messages $counter");
    if (counter != null) {
      print("This is my if111");
    } else {
      print("This is my else111");
      sharedPref.saveInteger(key, 0);
      value = 0;
    }
  }

  isSentMessages(String key, int value) async {
    //  final prefs = await SharedPreferences.getInstance();
    final counter = await sharedPref.readInteger(key);
    print("this is sent messages q $counter");
    value = counter;
    sharedPref.saveInteger(key, value + 1);
    final counter1 = await sharedPref.readInteger(key);
    print("this is sent messages www $counter1");
  }
  // isSentMessages() async {
  //   int sent = await sharedPref.readInteger("sentMessages");
  //   print("this is sent messages q $sent");

  //   if (sent != null) {
  //     print("This is my if222");
  //     sharedPref.saveInteger("sentMessages", sent);
  //     mesgSent = sent;
  //     print("this is sent messages w $mesgSent");
  //   } else {
  //     print("This is my else222");
  //     sharedPref.saveInteger("sentMessages", 0);
  //     mesgSent = 0;
  //   }
  // }

  @override
  void initState() {
    super.initState();

    isValuePresent("sentMessagesCounter", mesgSent);
    isValuePresent("receiveMessagesCounter", mesgSent);
    // isSentMessages();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    controller.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  Future getImage(String src) async {
    print('yes im here');

    PickedFile pickedFile;
    if (src == "Gallery") {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
      //Navigator.pop(context);
    }
    if (src == "Camera") {
      pickedFile = await picker.getImage(source: ImageSource.camera);
      // Navigator.pop(context);
    }

    if (pickedFile != null) {
      image = File(pickedFile.path);

      Uint8List bytes = await pickedFile.readAsBytes();
      print("bytes are $bytes");
      if (bytes.length > 6000000) {
        buildShowDialog(
            context, "Error Message", "File size should be less than 6 MB!!");
        return;
      }

      Map<String, dynamic> filePacket = {
        "id":
            generateMd5(_groupListProvider.groupList.groups[index].channel_key),
        "to": _groupListProvider.groupList.groups[index].channel_name,
        "key": _groupListProvider.groupList.groups[index].channel_key,
        "from": authProvider.getUser.ref_id,
        "type": MediaType.image,
        "content": base64.encode(bytes),
        "fileExtension": (pickedFile.path.split('.').last),
        "isGroupMessage": false,
        "size": 0,
        "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
        "status": ReceiptType.sent,
      };
      // mesgSent = mesgSent + 1;
      //                     sharedPref.saveInteger("sentMessages", mesgSent);
      isSentMessages("sentMessagesCounter", mesgSent);
      widget.publishMessage(
          _groupListProvider.groupList.groups[index].channel_key,
          _groupListProvider.groupList.groups[index].channel_name,
          filePacket);
      filePacket["content"] = kIsWeb ? pickedFile.path : File(pickedFile.path);
      _groupListProvider.sendMsg(index, filePacket);
    } else {
      print('No image selected.');
    }
  }

  filePIcker(String fileType) async {
    print("here in file picker");
    FilePickerResult result;
    if (fileType == "file")
      result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.any);
    else
      result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.audio);
    List<String> videoExtensions = [
      "webm",
      "mkv",
      "flv",
      "vob",
      "ogv",
      "ogg",
      "rrc",
      "gifv",
      "mng",
      "mov",
      "avi",
      "qt",
      "wmv",
      "yuv",
      "rm",
      "asf",
      "amv",
      "mp4",
      "m4p",
      "m4v",
      "mpg",
      "mp2",
      "mpeg",
      "mpe",
      "mpv",
      "m4v",
      "svi",
      "3gp",
      "3g2",
      "mxf",
      "roq",
      "nsv",
      "flv",
      "f4v",
      "f4p",
      "f4a",
      "f4b]",
    ];
    bool isVideo = videoExtensions.contains(result.files.single.extension);

    List<String> audioExtensions = [
      "aac",
      "aiff",
      "ape",
      "au",
      "flac",
      "gsm",
      "it",
      "m3u",
      "m4a",
      "mid",
      "mod",
      "mp3",
      "mpa",
      "pls",
      "ra",
      "s3m",
      "sid",
      "wav",
      "wma",
      "xm"
    ];
    bool isAudio = audioExtensions.contains(result.files.single.extension);

    List<String> imageExtensions = [
      "3dm",
      "3ds",
      "max",
      "bmp",
      "dds",
      "gif",
      "jpg",
      "jpeg",
      "png",
      "psd",
      "xcf",
      "tga",
      "thm",
      "tif",
      "tiff",
      "yuv",
      "ai",
      "eps",
      "ps",
      "svg",
      "dwg",
      "dxf",
      "gpx",
      "kml",
      "kmz",
      "webp"
    ];

    bool isImage = imageExtensions.contains(result.files.single.extension);
    var type;

    if (isVideo == true) {
      type = MediaType.video;
    } else if (isAudio == true) {
      type = MediaType.audio;
    } else if (isImage == true) {
      type = MediaType.image;
    } else {
      type = MediaType.file;
    }
    print("this is type $type");

    if (result != null) {
      File file = File(result.files.first.path);
      Uint8List bytes = await file.readAsBytes();

      print("bytes length ${bytes.length}");
      if (bytes.length > 6000000) {
        buildShowDialog(
            context, "Error Message", "File size should be less than 6 MB!!");
        return;
      }
      print("this is file ${(file.path.split('.').last)}");
      Map<String, dynamic> filePacket = {
        "id":
            generateMd5(_groupListProvider.groupList.groups[index].channel_key),
        // "topic": _groupListProvider.groupList.groups[index].channel_name,
        "to": _groupListProvider.groupList.groups[index].channel_name,
        "key": _groupListProvider.groupList.groups[index].channel_key,
        "from": authProvider.getUser.ref_id,
        "type": type,
        "content": base64.encode(bytes),
        "fileExtension": (file.path.split('.').last),
        // p.extension(file.path.lastIndexOf('.')).substring(1)),

        "isGroupMessage": false,
        "size": 0,
        "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
        "status": ReceiptType.sent,
        "subtype": type
      };
      //  mesgSent = mesgSent + 1;
      //                       sharedPref.saveInteger("sentMessages", mesgSent);
      isSentMessages("sentMessagesCounter", mesgSent);
//fileee.writeAsBytesSync(bytes);
      // _groupListProvider.sendMsg(index, filePacket);
      widget.publishMessage(
          _groupListProvider.groupList.groups[index].channel_key,
          _groupListProvider.groupList.groups[index].channel_name,
          filePacket);
      filePacket["content"] = kIsWeb ? file.path : file;
      _groupListProvider.sendMsg(index, filePacket);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  List<Uint8List> byteToPortions(Uint8List largeByteArray) {
    // create a list to keep the portions
    List<Uint8List> byteArrayPortions = [];

    // 12kb is about 12288 bytes
    int sizePerPortion = 12288;
    int offset = 0;
    for (int i = 0; i <= (largeByteArray.length / sizePerPortion); i++) {
      int end = sizePerPortion * (i + 1);
      if (end >= largeByteArray.length) {
        end = largeByteArray.length;
      }
      Uint8List portion = largeByteArray.sublist(offset, end);
      offset = end;
      byteArrayPortions.add(portion);
    }
    return byteArrayPortions;
  }

  generateMd5(String groupkey) {
    var input = DateTime.now().millisecondsSinceEpoch.toString() + groupkey;
    var content = crypto.md5.convert(utf8.encode(input)).toString();
    print("the input value in MD5 format: $content");
    return content;
  }

  // Future<bool> _onWillPop() async {
  //  // _groupListProvider.handlBacktoGroupList(index);
  //   if (strArr.last == "ChatScreen") {
  //     widget.mainProvider.homeScreen();
  //     strArr.remove("ChatScreen");
  //   } else if (strArr.last == "ChatScreenWithActiveCall") {
  //     widget.mainProvider.homeScreen();
  //     strArr.remove("ChatScreenWithActiveCall");
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    print("index in chat screen  ${index}");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    // if(_groupListProvider.callprogress==true){
    //    _tickerr = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
    // }
    print("is calling progress in chat screen $index");

    Timer(
        Duration(milliseconds: 5),
        () => controller.hasClients
            ? controller.jumpTo(controller.position.maxScrollExtent)
            //  }
            : null);

    return WillPopScope(
        //onWillPop: _onWillPop,
        child: Consumer3<GroupListProvider, MainProvider, ContactProvider>(
            builder: (context, groupListProvider, mainProvider,
                contactListProvider, child) {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFous = FocusScope.of(context);
          if (!currentFous.hasPrimaryFocus) {
            currentFous.unfocus();
          }
        },
        child: Scaffold(
          //key:scaffoldKey,
          //  key:scaffoldKey.currentState,
          backgroundColor: backgroundChatColor,
          appBar: CustomAppBar(
              groupListProvider: groupListProvider,
              lead: true,
              ischatscreen: true,
              title: "",
              index: index,
              authProvider: authProvider,
              mainProvider: widget.mainProvider,
              funct: widget.funct),
          body: SafeArea(
            child: Column(
              children: [
                //  isCallinProgress==true?

                widget.activeCall
                    ? meidaType == "video" && typeOfCall != "one_to_many"
                        ? StreamBar(
                            mainProvider: widget.mainProvider,
                            groupListProvider: groupListProvider,
                            isActive: true,
                            meidaType: meidaType,
                          )
                        : (typeOfCall == "one_to_many")
                            ? GestureDetector(
                                onTap: () {
                                  widget.mainProvider.callStart();
                                },
                                child: new Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    color: Colors.green,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          21, 0, 11, 0),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(ispublicbroadcast ||
                                                  isDialer == true
                                              ? "You are sharing you screen"
                                              : "You are viewing screen currently"),
                                          Spacer(),
                                          Text(
                                              "${groupListProvider.timerDuration}"),
                                        ],
                                      ),
                                    )),
                              )
                            : GestureDetector(
                                onTap: () {
                                  widget.mainProvider.callStart();
                                },
                                child: new Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    color: Colors.green,
                                    child: Text(
                                        "${groupListProvider.timerDuration}")),
                              )
                    : SizedBox(height: 0),
                Expanded(
                    child: Scrollbar(
                        child: groupListProvider
                                    .groupList.groups[index].chatList ==
                                null
                            ? Text("")
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                //reverse: true,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                controller: controller,
                                itemCount: groupListProvider
                                    .groupList.groups[index].chatList.length,
                                itemBuilder: (context, chatindex) {
                                  if (groupListProvider.groupList.groups[index]
                                              .chatList[chatindex].type !=
                                          MessagingType.text ||
                                      groupListProvider.groupList.groups[index]
                                              .chatList[chatindex].status ==
                                          ReceiptType.delivered) {}

                                  return Column(
                                    children: [
                                      groupListProvider.groupList.groups[index]
                                                  .chatList[chatindex].from !=
                                              authProvider.getUser.ref_id
                                          ? receiverText(groupListProvider,
                                              chatindex, date.toString())
                                          : senderText(groupListProvider,
                                              chatindex, date.toString())
                                    ],
                                  );
                                }))),
                SizedBox(
                  height: 8,
                ),
                buildAlign(groupListProvider)
              ],
            ),
          ),
        ),
      );
    }
            //}
            ));
  }

  //Sender Text Widget//
  Column receiverText(
      GroupListProvider groupListProvider, int chatindex, String date) {
    var participantIndex = groupListProvider
        .groupList.groups[index].participants
        .indexWhere((element) =>
            element.ref_id ==
            groupListProvider.groupList.groups[index].chatList[chatindex].from);
    print("chat index is $chatindex");

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, top: 28),
                    child: Text(
                        // "pata nahi",
                        "${groupListProvider.groupList.groups[index].participants[participantIndex].full_name} ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: receiverMessagecolor, fontSize: 14))),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(top: 5, right: 26, left: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),

                                //The Text Inside Receiver Container//
                                child: groupListProvider.groupList.groups[index]
                                            .chatList[chatindex].type ==
                                        MessagingType.text
                                    ?
                                    //If we have type not equal to 0 then we have to show the content inside the message
                                    Container(
                                        decoration: BoxDecoration(
                                          color: receiverMessagecolor,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        // color: receiverMessagecolor,
                                        child: Text(
                                          "${groupListProvider.groupList.groups[index].chatList[chatindex].content}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    :
                                    //If its an image then we will check if its on web or mobile device

                                    groupListProvider.groupList.groups[index]
                                                .chatList[chatindex].type ==
                                            MediaType.image
                                        ? kIsWeb
                                            ? Container(
                                                width: 200,
                                                child: Image.network(
                                                  groupListProvider
                                                      .groupList
                                                      .groups[index]
                                                      .chatList[chatindex]
                                                      .content,
                                                  fit: BoxFit.fill,
                                                ))
                                            : Container(
                                                padding: EdgeInsets.all(8),
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  color:
                                                      searchbarContainerColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Image.file(
                                                    groupListProvider
                                                        .groupList
                                                        .groups[index]
                                                        .chatList[chatindex]
                                                        .content,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              )
                                        : groupListProvider
                                                    .groupList
                                                    .groups[index]
                                                    .chatList[chatindex]
                                                    .type ==
                                                MediaType.audio
                                            ?
                                            //for audio
                                            AudioWidget(
                                                groupListProvider:
                                                    groupListProvider,
                                                chatindex: chatindex,
                                                index: index,
                                                file: groupListProvider
                                                    .groupList
                                                    .groups[index]
                                                    .chatList[chatindex]
                                                    .content,
                                                isReceive: true,
                                              )
                                            : groupListProvider
                                                        .groupList
                                                        .groups[index]
                                                        .chatList[chatindex]
                                                        .type ==
                                                    MediaType.video
                                                ?
                                                //for video
                                                InkWell(
                                                    onTap: () {
                                                      print(
                                                          "i am opening file1");
                                                      OpenFile.open(
                                                        groupListProvider
                                                            .groupList
                                                            .groups[index]
                                                            .chatList[chatindex]
                                                            .content
                                                            .path,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            receiverMessagecolor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 16,
                                                          bottom: 16,
                                                          left: 15,
                                                          right: 20),
                                                      // width: 250,

                                                      child: Text(
                                                        groupListProvider
                                                            .groupList
                                                            .groups[index]
                                                            .chatList[chatindex]
                                                            .content
                                                            .path
                                                            .toString()
                                                            .split("/")
                                                            .last,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                :
                                                //for file
                                                InkWell(
                                                    onTap: () {
                                                      print(
                                                          "i am opening file2");
                                                      OpenFile.open(
                                                        groupListProvider
                                                            .groupList
                                                            .groups[index]
                                                            .chatList[chatindex]
                                                            .content
                                                            .path,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            receiverMessagecolor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 16,
                                                          bottom: 16,
                                                          left: 15,
                                                          right: 20),
                                                      child: Text(
                                                        groupListProvider
                                                            .groupList
                                                            .groups[index]
                                                            .chatList[chatindex]
                                                            .content
                                                            .path
                                                            .toString()
                                                            .split("/")
                                                            .last,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          // color:
                                                          //     sendMessageColoer,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                              ),
                            ),
                            Container(
                                // margin: EdgeInsets.only(top: 25, left: 10),
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  DateFormat().add_jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          groupListProvider
                                              .groupList
                                              .groups[index]
                                              .chatList[chatindex]
                                              .date)),
                                  style: TextStyle(
                                    color: messageTimeColor,
                                    fontSize: 12,
                                  ),
                                ))
                          ],
                        )),
                  )
                ]),
              ])
        ]);
  }

  //Sender Text Widget//
  Row senderText(
      GroupListProvider groupListProvider, int chatindex, String date) {
    print("this is chat indexxx $chatindex");

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Flexible(
        child: Container(
          margin: EdgeInsets.only(top: 24, right: 26, left: 40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                groupListProvider
                            .groupList.groups[index].chatList[chatindex].from !=
                        authProvider.getUser.ref_id
                    ? Text(
                        "",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: messageTimeColor,
                          fontSize: 14,
                        ),
                      )
                    : groupListProvider.groupList.groups[index]
                                .chatList[chatindex].status ==
                            ReceiptType.sent
                        ? Text("")
                        : groupListProvider.groupList.groups[index]
                                    .chatList[chatindex].status ==
                                ReceiptType.delivered
                            ? Text("")
                            : (groupListProvider.groupList.groups[index]
                                        .participants.length >
                                    2)
                                ? Text(
                                    "Read ${groupListProvider.groupList.groups[index].chatList[chatindex].readCount}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: messageTimeColor,
                                      fontSize: 12,
                                    ),
                                  )
                                : Text(
                                    "Read",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: messageTimeColor,
                                      fontSize: 12,
                                    ),
                                  ),
                Container(
                    margin: EdgeInsets.only(top: 25, left: 10),
                    child: Text(
                      DateFormat().add_jm().format(
                          DateTime.fromMillisecondsSinceEpoch(groupListProvider
                              .groupList
                              .groups[index]
                              .chatList[chatindex]
                              .date)),
                      style: TextStyle(
                        color: messageTimeColor,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
            SizedBox(width: 16),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: searchbarContainerColor,
                ),
                child: groupListProvider
                            .groupList.groups[index].chatList[chatindex].type ==
                        MessagingType.text
                    ?
                    //for text
                    Container(
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, left: 20, right: 20),
                        child: Text(
                          "${groupListProvider.groupList.groups[index].chatList[chatindex].content}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: sendMessageColoer,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : groupListProvider.groupList.groups[index]
                                .chatList[chatindex].type ==
                            MediaType.image
                        ?
                        //for image
                        kIsWeb
                            ? Container(
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, left: 20, right: 20),
                                color: messageTimeColor,
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    groupListProvider.groupList.groups[index]
                                        .chatList[chatindex].content,
                                    fit: BoxFit.fill,
                                  ),
                                ))
                            : InkWell(
                                onTap: () {
                                  print("i am opening file3");
                                  OpenFile.open(
                                    groupListProvider.groupList.groups[index]
                                        .chatList[chatindex].content.path,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  // color: messageTimeColor,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: searchbarContainerColor,
                                      // width: 15,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.file(
                                      groupListProvider.groupList.groups[index]
                                          .chatList[chatindex].content,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              )
                        : groupListProvider.groupList.groups[index]
                                    .chatList[chatindex].type ==
                                MediaType.audio
                            ?
                            // for audio
                            AudioWidget(
                                groupListProvider: groupListProvider,
                                chatindex: chatindex,
                                index: index,
                                file: groupListProvider.groupList.groups[index]
                                    .chatList[chatindex].content,
                                isReceive: false,
                              )
                            : groupListProvider.groupList.groups[index]
                                        .chatList[chatindex].type ==
                                    MediaType.video
                                ?
                                //for video
                                // Container()
                                InkWell(
                                    onTap: () {
                                      print("i am opening file4");
                                      OpenFile.open(
                                        groupListProvider
                                            .groupList
                                            .groups[index]
                                            .chatList[chatindex]
                                            .content
                                            .path,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          bottom: 16,
                                          left: 20,
                                          right: 20),
                                      child: Text(
                                        groupListProvider
                                            .groupList
                                            .groups[index]
                                            .chatList[chatindex]
                                            .content
                                            .path
                                            .toString()
                                            .split("/")
                                            .last,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: sendMessageColoer,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                :
                                //for file
                                InkWell(
                                    onTap: () {
                                      print("i am opening file5");
                                      OpenFile.open(
                                        groupListProvider
                                            .groupList
                                            .groups[index]
                                            .chatList[chatindex]
                                            .content
                                            .path,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          bottom: 16,
                                          left: 20,
                                          right: 20),
                                      child: Text(
                                        groupListProvider
                                            .groupList
                                            .groups[index]
                                            .chatList[chatindex]
                                            .content
                                            .path
                                            .toString()
                                            .split("/")
                                            .last,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: sendMessageColoer,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }

  // Container audioWidget(GroupListProvider groupListProvider, int chatindex) {
  //   Future<void> _onPlay(
  //       {@required String filePath, @required int index}) async {
  //     AudioPlayer audioPlayer = AudioPlayer();
  //     if (!_isPlaying) {
  //       audioPlayer.play(filePath, isLocal: true);
  //       setState(() {
  //         // _selectedIndex = index;
  //         _completedPercentage = 0.0;
  //         _isPlaying = true;
  //       });

  //       audioPlayer.onPlayerCompletion.listen((_) {
  //         setState(() {
  //           _isPlaying = false;
  //           _completedPercentage = 0.0;
  //         });
  //       });
  //       audioPlayer.onDurationChanged.listen((duration) {
  //         setState(() {
  //           _totalDuration = duration.inMicroseconds;
  //         });
  //       });

  //       audioPlayer.onAudioPositionChanged.listen((duration) {
  //         setState(() {
  //           _currentDuration = duration.inMicroseconds;
  //           _completedPercentage =
  //               _currentDuration.toDouble() / _totalDuration.toDouble();
  //         });
  //       });
  //     }
  //   }

  //   return Container(
  //     // height: 50,
  //     // width: 224,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(5),
  //       color: searchbarContainerColor,
  //     ),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           onPressed: () {
  //             _onPlay(
  //                 filePath: groupListProvider
  //                     .groupList.groups[index].chatList[chatindex].content.path,
  //                 index: 0);
  //           },
  //           icon: _isPlaying
  //               ? Icon(
  //                   Icons.pause,
  //                   color: receiverMessagecolor,
  //                 )
  //               : Icon(Icons.play_arrow, color: receiverMessagecolor),
  //           //  onPressed: () => _onPlay(
  //           //  filePath: record, index: 0),
  //         ),
  //         SizedBox(
  //           width: 125,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               LinearProgressIndicator(
  //                 minHeight: 3,

  //                 backgroundColor: typeMessageColor,
  //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
  //                 value: _completedPercentage,
  //                 // value:_completedPercentage,
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //             margin: EdgeInsets.only(left: 5),
  //             child: Text(
  //               "0.37",
  //               style: TextStyle(
  //                 color: receiverMessagecolor,
  //                 fontSize: 14,
  //               ),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  //bottom Text Box//
  Align buildAlign(GroupListProvider groupListProvider) {
    Timer(
        Duration(milliseconds: 5),
        () => controller.hasClients
            ? controller.jumpTo(controller.position.maxScrollExtent)
            //  }
            : null);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              color: messageBoxColor,
              height: 46,
              child: Row(
                children: [
                  Container(
                    color: messageBoxColor,
                    padding: EdgeInsets.only(left: 18),
                    //width:14,
                    child: IconButton(
                      icon: SvgPicture.asset('assets/Mic.svg'),
                      // onPressed: _start,
                    ),
                  ),
                  // Container(
                  //   //   margin: EdgeInsets.only(top: 17),
                  //   height: 21,
                  //   width: 287,
                  //   child:
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: messageController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Type your message",
                        contentPadding: EdgeInsets.only(bottom: 4, right: 28),
                        hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: typeMessageColor,
                            fontFamily: secondaryFontFamily),
                      ),
                      onChanged: (value) {
                        // print("this is date ${((DateTime.now()).millisecondsSinceEpoch).round()}");

                        var send_message = {
                          "id": generateMd5(groupListProvider
                              .groupList.groups[index].channel_key),
                          "to": groupListProvider
                              .groupList.groups[index].channel_name,
                          "key": groupListProvider
                              .groupList.groups[index].channel_key,
                          "from": authProvider.getUser.ref_id,
                          "type": MessagingType.typing,
                          "content": "1",
                          "size": 0,
                          "isGroupMessage": false,
                          "date":
                              ((DateTime.now()).millisecondsSinceEpoch).round(),
                          "status": ReceiptType.sent,
                        };

                        widget.publishMessage(
                            groupListProvider
                                .groupList.groups[index].channel_key,
                            groupListProvider
                                .groupList.groups[index].channel_name,
                            send_message);

                        Timer(Duration(seconds: 6), () {
                          var send_message = {
                            "id": generateMd5(groupListProvider
                                .groupList.groups[index].channel_key),
                            "to": groupListProvider
                                .groupList.groups[index].channel_name,
                            "key": groupListProvider
                                .groupList.groups[index].channel_key,
                            "from": authProvider.getUser.ref_id,
                            // "type": MessagingType.typing,
                            "content": "0",
                            "size": 0,
                            "isGroupMessage": false,
                            "date": ((DateTime.now()).millisecondsSinceEpoch)
                                .round(),
                            "status": ReceiptType.sent,
                          };

                          widget.publishMessage(
                              groupListProvider
                                  .groupList.groups[index].channel_key,
                              groupListProvider
                                  .groupList.groups[index].channel_name,
                              send_message);
                        });
                      },
                    ),
                  ),
                  //   ),
                ],
              )),
          Container(
              height: 45,
              color: messageBoxColor,
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          child: IconButton(
                            icon: Material(
                                child: SvgPicture.asset('assets/imagepic.svg')),
                            onPressed: () async {
                              getImage("Gallery");
                            },
                          ),
                        ),
                        Container(
                          child: IconButton(
                            icon: Material(
                                child:
                                    SvgPicture.asset('assets/AddCircle.svg')),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AddAttachmentPopUp(
                                        getImage: getImage,
                                        filePIcker: filePIcker,
                                      );
                                    });
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(right: 14),
                      child: IconButton(
                        icon: Material(
                            child: SvgPicture.asset('assets/sendmsg.svg')),
                        onPressed: () async {
                          print("here in send on press");
                          // setState(() {

                          var send_message = {
                            "from": authProvider.getUser.ref_id,
                            "content": messageController.text,
                            "id": generateMd5(groupListProvider
                                .groupList.groups[index].channel_key),
                            "key": groupListProvider
                                .groupList.groups[index].channel_key,
                            "type": MessagingType.text,
                            "to": groupListProvider
                                .groupList.groups[index].channel_name,
                            "isGroupMessage": false,
                            "date": ((DateTime.now()).millisecondsSinceEpoch)
                                .round(),
                            "status": ReceiptType.sent,
                            "size": 0.0
                          };

                          // mesgSent = mesgSent + 1;
                          // sharedPref.saveInteger("sentMessages", mesgSent);
                          // isSentMessages();

                          if (messageController.text.isNotEmpty &&
                              messageController.text.trim().length != 0) {
                            print(
                                "This is group chat publish text before adding");
                            //            mesgSent = mesgSent + 1;
                            // sharedPref.saveInteger("sentMessages", mesgSent);
                            isSentMessages("sentMessagesCounter", mesgSent);
                            print(
                                "This is group chat publish text after adding");
                            widget.publishMessage(
                                groupListProvider
                                    .groupList.groups[index].channel_key,
                                groupListProvider
                                    .groupList.groups[index].channel_name,
                                send_message);
                            //FOR SCROLLING TO END
                            groupListProvider.sendMsg(index, send_message);

                            messageController.clear();
                          }
                          //});
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
