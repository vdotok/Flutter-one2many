// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'src/core/providers/auth.dart';
// import 'src/common/customAppBar.dart';

// import 'constant.dart';

// class NoContactsScreen extends StatelessWidget {
//   AuthProvider authProvider;
//   final refreshList;
//   final bool state;
//   final bool isSocketConnect;
//   NoContactsScreen(
//       {this.authProvider, this.refreshList, this.state, this.isSocketConnect});

//   @override
//   Widget build(BuildContext context) {
//     print("here in no chat screen");
//     return
//         // Scaffold(
//         //   backgroundColor: chatRoomBackgroundColor,
//         //   appBar: CustomAppBar(),
//         //   body:
//         SingleChildScrollView(
//       child: RefreshIndicator(
//         onRefresh: refreshList,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 128,
//             ),
//             Container(
//                 height: 160.0,
//                 child: Center(
//                   child: SvgPicture.asset(
//                     'assets/Face.svg',
//                   ),
//                 )),
//             SizedBox(height: 43),
//             Text(
//               "No User Found",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: chatRoomColor,
//                 fontSize: 21,
//               ),
//             ),
//             // SizedBox(height: 8),
//             // SizedBox(
//             //     width: 220,
//             //     height: 66,
//             //     child: Text(
//             //       "Tap and hold on any message to star it, so you can easily find it later.",
//             //       textAlign: TextAlign.center,
//             //       style: TextStyle(
//             //         color: chatRoomTextColor,
//             //         fontSize: 14,
//             //       ),
//             //     )),
//             // SizedBox(height: 22),
//             // Container(
//             //   width: 196,
//             //   height: 56,
//             //   child: Row(
//             //     mainAxisSize: MainAxisSize.min,
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     crossAxisAlignment: CrossAxisAlignment.center,
//             //     children: [
//             //       Container(
//             //           width: 196,
//             //           height: 56,
//             //           decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(5),
//             //             border: Border.all(
//             //               color: refreshButtonColor,
//             //               width: 3,
//             //             ),
//             //           ),
//             //           child: FlatButton(
//             //             onPressed: () {

//             //             },
//             //             child: Text(
//             //               "New Chat",
//             //               style: TextStyle(
//             //                   fontSize: 14.0,
//             //                   fontFamily: primaryFontFamily,
//             //                   fontStyle: FontStyle.normal,
//             //                   fontWeight: FontWeight.bold,
//             //                   color: refreshButtonColor),
//             //             ),
//             //           )),
//             //     ],
//             //   ),
//             // ),
//             SizedBox(height: 15),
//             Container(
//               width: 196,
//               height: 56,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: refreshButtonColor,
//               ),
//               child: Container(
//                   width: 196,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border.all(
//                       color: Color(0xff190354),
//                       width: 3,
//                     ),
//                   ),
//                   child: Center(
//                       child: FlatButton(
//                     onPressed: refreshList,
//                     child: Text(
//                       "Refresh",
//                       style: TextStyle(
//                           fontSize: 14.0,
//                           fontFamily: primaryFontFamily,
//                           fontStyle: FontStyle.normal,
//                           fontWeight: FontWeight.w700,
//                           color: refreshTextColor,
//                           letterSpacing: 0.90),
//                     ),
//                   ))),
//             ),
//             SizedBox(height: 40),
//             Row(
//               children: [
//                 SizedBox(
//                     width: 105,
//                     child: FlatButton(
//                       onPressed: () {
//                         authProvider.logout();
//                         // emitter.disconnect();
//                       },
//                       child: Text(
//                         "LOG OUT",
//                         style: TextStyle(
//                             fontSize: 14.0,
//                             fontFamily: primaryFontFamily,
//                             fontStyle: FontStyle.normal,
//                             fontWeight: FontWeight.w700,
//                             color: logoutButtonColor,
//                             letterSpacing: 0.90),
//                       ),
//                     )),
//                 Container(
//                   height: 10,
//                   width: 10,
//                   decoration: BoxDecoration(
//                       color:
//                           state && isSocketConnect ? Colors.green : Colors.red,
//                       shape: BoxShape.circle),
//                 )
//               ],
//             ),
//             Container(
//                 padding: const EdgeInsets.only(bottom: 60),
//                 child: Text(authProvider.getUser.full_name))
//           ],
//         ),
//       ),
//     );

//     // );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_onetomany/src/core/providers/auth.dart';
import 'package:flutter_onetomany/src/core/providers/groupListProvider.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constant.dart';

class NoContactsScreen extends StatelessWidget {
  //AuthProvider authProvider;
  final bool isConnect;
  final bool state;
  final refreshList;
  final newChatHandler;
  final GroupListProvider groupListProvider;
  final AuthProvider authProvider;
  NoContactsScreen({this.refreshList, this.newChatHandler, this.groupListProvider, this.authProvider, this.isConnect, this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: SvgPicture.asset(
            'assets/Face.svg',
          )),
          // SizedBox(height: 43),
          Text(
            "No Conversation Yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: chatRoomColor,
              fontSize: 21,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
              width: 220,
              height: 66,
              child: Text(
                "Tap and hold on any message to star it, so you can easily find it later.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: chatRoomTextColor,
                  fontSize: 14,
                ),
              )),
          SizedBox(height: 22),
          Container(
            width: 196,
            height: 56,
            child: Container(
                width: 196,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: refreshButtonColor,
                    width: 3,
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                   // handleGroupState()
                    newChatHandler();
                  },
                  child: Text(
                    "New Group",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: primaryFontFamily,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: refreshButtonColor),
                  ),
                )),
          ),
          SizedBox(height: 15),
          Container(
            width: 196,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: refreshButtonColor,
            ),
            child: Container(
                width: 196,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: selectcontactColor,
                    width: 3,
                  ),
                ),
                child: Center(
                    child: FlatButton(
                     onPressed: refreshList,
                  child: Text(
                    "Refresh",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: primaryFontFamily,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: refreshTextColor,
                        letterSpacing: 0.90),
                  ),
                ))),
          ),
          SizedBox(height:40),
           Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 105,
                        child: FlatButton(
                          onPressed: () {
                            authProvider.logout();
                         
                          },
                          child: Text(
                            "LOG OUT",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: primaryFontFamily,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                color: logoutButtonColor,
                                letterSpacing: 0.90),
                          ),
                        )),
                          Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color:
                          isConnect? Colors.green : Colors.red,
                      shape: BoxShape.circle),
                ),
                  ],
                ),
                  Container(
                    // padding: const EdgeInsets.only(bottom: 60),
                    child: Text(authProvider.getUser.full_name))
        ],
      ),
    );
  }
}
