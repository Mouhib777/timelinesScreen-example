//import 'dart:ffi';
//import 'dart:html';

import 'package:bil/Service/DataBase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:bil/Widget/PostingContainer.dart';
import 'package:bil/Widget/header.dart';
import 'package:bil/constant/constants.dart';
import 'package:bil/model/posting.dart';
import 'package:bil/model/user.dart';
import 'package:bil/screens/Eventsscreen.dart';
import 'package:bil/screens/loginscreen.dart';
import 'package:kf_drawer/kf_drawer.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class timelinescreen extends StatefulWidget {
  final String currentUserId;
  const timelinescreen({
    Key? key,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<timelinescreen> createState() => _timelinescreenState();
}

class _timelinescreenState extends State<timelinescreen> {
  List _userpostss = [];
  bool _loading = false;
  // late final String currentUserId;
  buildPosts(Posting posting, Usermodel author) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: PostingContainer(
        posting: posting,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  ShowUserposts(String currentUserId) {
    List<Widget> userpostsList = [];
    for (Posting posting in _userpostss) {
      userpostsList.add(FutureBuilder(
          future: usersRef.doc(posting.authorId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              Usermodel author = Usermodel.fromDocument(snapshot.data!);
              return buildPosts(posting, author);
            } else {
              return SizedBox.shrink();
            }
          }));
    }
    return userpostsList;
  }

  setupuserposts() async {
    setState(() {
      _loading = true;
    });
    List userpostss = await DatabaseServices.getHomePosts(widget.currentUserId);
    if (mounted) {
      setState(() {
        _userpostss = userpostss;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupuserposts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context),
        //*****drawer*****
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  BIL_Color,
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(2.0, 0.8),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  // currentAccountPictureSize: const Size.square(55.0),
                  accountName: Text(""),
                  accountEmail: Text(""),
                  //currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: AssetImage("assets/images/bil_cover.jpg"),
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover)),
                ),
                // ListTile(
                // title: Text(
                //    "    🇧‌🇮‌🇱  🇮‌🇸‌🇮‌🇲‌🇦‌       ᴀᴘᴘᴀʀᴛɪᴇɴᴛ ᴀᴜ ʀᴇꜱᴇᴀᴜx ᴅᴇꜱ ᴄʟᴜʙꜱ ʙɪʟ ᴛᴜɴɪꜱɪᴀ Qᴜɪ ᴀ ᴘᴏᴜʀ   ʙᴜᴛ ᴅ’ɪɴɪᴛɪᴇʀ ʟᴇꜱ ᴊᴇᴜɴᴇꜱ ᴀᴜ ʟᴇᴀᴅᴇʀꜱʜɪᴘ."),
                // leading: Icon(
                //  Icons.info_outline_rounded,
                //  color: Colors.blue.shade700,
                //   size: 35,
                // ),
                // isThreeLine: false,
                //dense: false,
                // ),
                // Divider(
                //    color: Colors.blueGrey[100],
                //   height: 45,
                //  thickness: 1,
                // ),
                Divider(
                  color: Colors.transparent,
                  height: 100,
                  thickness: 0,
                ),
                ListTile(
                  title: Text(
                    "On Board",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        backgroundColor: Colors.transparent),
                  ),
                  leading: Icon(
                    Icons.supervised_user_circle,
                    color: Color(0xFF1C75BC),
                    size: 32,
                  ),
                  onTap: () {},
                ),
                Divider(
                  color: BIL_Color,
                  height: 45,
                  thickness: 2,
                ),
                ListTile(
                  title: Text(
                    "Events",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        backgroundColor: Colors.transparent),
                  ),
                  leading: Icon(
                    Icons.event,
                    color: Color(0xFF1C75BC),
                    size: 32,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => eventsscreen()));
                  },
                ),
                Divider(
                  color: BIL_Color,
                  height: 45,
                  thickness: 2,
                ),
                ListTile(
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        backgroundColor: Colors.transparent),
                  ),
                  leading: Icon(
                    Icons.logout_outlined,
                    color: Color(0xFF1C75BC),
                    size: 32,
                  ),
                  onTap: () async {
                    //isloading = true;
                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('See you soon  ')));

                    await FirebaseAuth.instance.signOut();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
                //Divider(
                // color: Colors.blueGrey[100],
                // height: 45,
                //thickness: 1,
                // ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => setupuserposts(),
          child: ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _loading ? LinearProgressIndicator() : SizedBox.shrink(),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: _userpostss.isEmpty && _loading == false
                        ? [
                            SizedBox(
                              height: 5,
                            ),
                            //Padding(
                            //  padding: EdgeInsets.symmetric(horizontal: 25),
                            //  child: Text(
                            //    'There is no new posts',
                            //    style: TextStyle(fontSize: 20),
                            //  ),
                            // )
                          ]
                        : ShowUserposts(widget.currentUserId),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
