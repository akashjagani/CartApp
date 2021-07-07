import 'package:cartapp/screens/cart_screen.dart';
import 'package:cartapp/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
          icon: Icon(
            Icons.menu,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        title: Text('Product Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  reverseDuration: Duration(
                    milliseconds: 500,
                  ),
                  child: CartScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      drawer: Drawer(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await _firebaseAuth
                  .signOut()
                  .then(
                    (value) => Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.topToBottom,
                        duration: Duration(
                          milliseconds: 500,
                        ),
                        child: LoginScreen(),
                      ),
                      (route) => false,
                    ),
                  )
                  .catchError((e) {
                print('Error $e');
                showToast(
                  'Some Error Please Try Again!',
                  context: context,
                  animation: StyledToastAnimation.slideFromBottom,
                  reverseAnimation: StyledToastAnimation.slideToBottom,
                  startOffset: Offset(0.0, 3.0),
                  reverseEndOffset: Offset(0.0, 3.0),
                  position: StyledToastPosition.bottom,
                  duration: Duration(seconds: 4),
                  animDuration: Duration(seconds: 1),
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.fastOutSlowIn,
                );
              });
            },
            child: Text('LogOut'),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection('Products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var _db = snapshot.data.docs;
              print('Hello DATA');
              print('Hello DATA ${snapshot.data.docs}');
              return Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    '${_db[index]['iphoneList'][index]['image'][index]}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_db[index]['iphoneList'][index]['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_db[index]['iphoneList'][index]['description']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${_db[index]['iphoneList'][index]['price']}/\-',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              await _fireStore
                                                  .collection('Cart')
                                                  .add({
                                                'name':
                                                    '${_db[index]['iphoneList'][index]['name']}',
                                                'description':
                                                    '${_db[index]['iphoneList'][index]['description']}',
                                                'price':
                                                    '${_db[index]['iphoneList'][index]['price']}',
                                                'image':
                                                    '${_db[index]['iphoneList'][index]['image'][index]}',
                                              }).then((value) {
                                                print(
                                                    '${_db[index]['iphoneList'][index]['name']} Add To Cart Successfully');
                                                showToast(
                                                  '${_db[index]['iphoneList'][index]['name']} Add To Cart Successfully',
                                                  context: context,
                                                  animation:
                                                      StyledToastAnimation
                                                          .slideFromBottom,
                                                  reverseAnimation:
                                                      StyledToastAnimation
                                                          .slideToBottom,
                                                  startOffset: Offset(0.0, 3.0),
                                                  reverseEndOffset:
                                                      Offset(0.0, 3.0),
                                                  position: StyledToastPosition
                                                      .bottom,
                                                  duration:
                                                      Duration(seconds: 4),
                                                  animDuration:
                                                      Duration(seconds: 1),
                                                  curve: Curves.elasticOut,
                                                  reverseCurve:
                                                      Curves.fastOutSlowIn,
                                                );
                                              }).catchError((e) {
                                                print('Error $e');
                                                showToast(
                                                  'Some Error Please Try Again!',
                                                  context: context,
                                                  animation:
                                                      StyledToastAnimation
                                                          .slideFromBottom,
                                                  reverseAnimation:
                                                      StyledToastAnimation
                                                          .slideToBottom,
                                                  startOffset: Offset(0.0, 3.0),
                                                  reverseEndOffset:
                                                      Offset(0.0, 3.0),
                                                  position: StyledToastPosition
                                                      .bottom,
                                                  duration:
                                                      Duration(seconds: 4),
                                                  animDuration:
                                                      Duration(seconds: 1),
                                                  curve: Curves.elasticOut,
                                                  reverseCurve:
                                                      Curves.fastOutSlowIn,
                                                );
                                              });
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Add To Cart',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              print('Hello ERROR');
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'Add Product',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
        splashColor: Colors.transparent,
      ),
    );
  }
}
