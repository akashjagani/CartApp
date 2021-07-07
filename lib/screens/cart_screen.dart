import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection('Cart').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var _db = snapshot.data.docs;
              print('Hello DATA');
              return Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
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
                                    '${_db[index]['image']}',
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
                                        '${_db[index]['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${_db[index]['description']}',
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
                                            '₹${_db[index]['price']}/\-',
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
                                                  .doc(snapshot
                                                      .data.docs[index].id)
                                                  .delete()
                                                  .then((value) {
                                                print(
                                                    'Product Remove Successfully');
                                                showToast(
                                                  'Product Remove Successfully',
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
                                                  'Delete Cart',
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
    );
  }
}
