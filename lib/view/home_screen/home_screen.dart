import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? file; // picked image file
  var url;
  TextEditingController nc = TextEditingController();
  TextEditingController pc = TextEditingController();

  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("employees");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
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
                InkWell(
                  onTap: () async {
                    file = await ImagePicker()
                        .pickImage(source: ImageSource.camera);

                    setState(() {});

                    if (file != null) {
                      var uniqueName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      // root reference
                      final storageRef = FirebaseStorage.instance.ref();

                      //create a folder inside the root
                      var folderReference = storageRef.child("Images");

                      //create a reference to which the image shoul be uploaded

                      var uploadRef = folderReference.child("$uniqueName.jpg");

                      await uploadRef.putFile(File(file!.path));

                      url = await uploadRef.getDownloadURL();
                      log(url.toString());
                    }
                  },
                  child: file != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(file!.path)),
                        )
                      : CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                ),
                SizedBox(height: 20),
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
                        "url": url ?? "",
                      });
                    },
                    child: Text("add")),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading:
                            Image.network(snapshot.data!.docs[index]['url']),
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
