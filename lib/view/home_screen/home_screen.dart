import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nc = TextEditingController();
  TextEditingController pc = TextEditingController();
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("employees");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: collectionRef.orderBy("name").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: const Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nc,
                  decoration: InputDecoration(
                      label: Text("Enter name"), border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: pc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: Text("Enter ph"), border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      collectionRef.add({
                        "name": nc.text,
                        "ph": pc.text,
                      });
                    },
                    child: Text("add")),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data!.docs[index]['name']),
                        subtitle: Text(snapshot.data!.docs[index]['ph']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  log(snapshot.data!.docs[index].id);
                                  collectionRef
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({
                                    "name": nc.text,
                                    "ph": pc.text,
                                  });
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  collectionRef
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
