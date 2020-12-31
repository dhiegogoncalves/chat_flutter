import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('chats').snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data.documents;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, i) => Container(
              padding: EdgeInsets.all(10),
              child: Text(documents[i]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Firestore.instance.collection('chats').add({
            'text': 'adicionado manualmente!',
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
