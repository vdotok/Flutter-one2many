import 'package:flutter/material.dart';
import 'package:flutter_onetomany/src/core/models/contact.dart';
import 'package:flutter_onetomany/src/core/providers/contact_provider.dart';


import 'package:flutter_svg/flutter_svg.dart';

import '../../constant.dart';

class ContactListScreen extends StatefulWidget {
  ContactProvider state;
  List<Contact> selectedContact;
  final searchController;
  final refreshcontactList;
  ContactListScreen({this.state,this.selectedContact,this.searchController, this.refreshcontactList});
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
bool notmatched = false;
  List _filteredList = [];
   onSearch(value) {
      print("this is here $value");
      List temp;
      temp = widget.state.contactList.users
          .where((element) =>
              element.full_name.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
      print("this is filtered list $_filteredList");
      setState(() {
        if (temp.isEmpty) {
          notmatched = true;
          print("Here in true not matched");
        } else {
          print("Here in false matched");
          notmatched = false;
          _filteredList = temp;
        }
      });
    }
  @override
  Widget build(BuildContext context) {
        if (widget.state.contactState == ContactStates.Loading)
      return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(chatRoomColor),
        )),
      );
    else
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: widget.refreshcontactList,
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 21, right: 21),
                  child: TextFormField(
                    //textAlign: TextAlign.center,
                    controller: widget.searchController,
                    onChanged: (value) {
                      onSearch(value);
                    },
                    validator: (value) =>
                        value.isEmpty ? "Field cannot be empty." : null,
                    decoration: InputDecoration(
                      fillColor: refreshTextColor,
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/SearchIcon.svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: searchbarContainerColor)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: searchbarContainerColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: searchbarContainerColor)),
                      hintText: "Search",
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: searchTextColor,
                          fontFamily: secondaryFontFamily),
                    ),
                  ),
                  //),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Scrollbar(
                    child: notmatched == true
                        ? Text("No data Found")
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            cacheExtent: 9999,
                            scrollDirection: Axis.vertical,
                            itemCount: widget.searchController.text.isEmpty
                                ? widget.state.contactList.users.length
                                : _filteredList.length,
                            itemBuilder: (context, position) {
                              Contact element = widget.searchController.text.isEmpty
                                  ? widget.state.contactList.users[position]
                                  : _filteredList[position];

                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      if (widget.selectedContact.indexWhere(
                                              (contact) =>
                                                  contact.user_id ==
                                                  element.user_id) !=
                                          -1) {
                                        setState(() {
                                          widget.selectedContact.remove(element);
                                        });
                                      } else {
                                        setState(() {
                                          widget.selectedContact.add(element);
                                        });
                                      }
                                    },
                                    leading: Container(
                                      margin: const EdgeInsets.only(
                                          left: 12, right: 14),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child:
                                          SvgPicture.asset('assets/User.svg'),
                                    ),
                                    title: Text(
                                      "${element.full_name}",
                                      style: TextStyle(
                                        color: contactNameColor,
                                        fontSize: 16,
                                        fontFamily: primaryFontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 35),
                                      child: widget.selectedContact.indexWhere(
                                                  (contact) =>
                                                      contact.user_id ==
                                                      element.user_id) ==
                                              -1
                                          ? Text("")
                                          : SvgPicture.asset(
                                              'assets/checkmark-circle.svg'),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 14.33, right: 19),
                                child: Divider(
                                  thickness: 1,
                                  color: listdividerColor,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
