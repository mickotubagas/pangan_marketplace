import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pangan_marketplace/drawer.dart';

class AdminAkses extends StatefulWidget {
  const AdminAkses({Key? key}) : super(key: key);

  @override
  State<AdminAkses> createState() => _AdminAksesState();
}

class _AdminAksesState extends State<AdminAkses> {
  final TextEditingController _usernameController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _usernameController.text = documentSnapshot['username'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String username = _usernameController.text;
                    await _users
                        .doc(documentSnapshot!.id)
                        .update({"username": username});
                    _usernameController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
              fontFamily: 'jaapokkienchance',
            ),
          ),
          Text(
            "Update Data User",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 30,
              fontFamily: 'jaapokkienchance',
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "List User :",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 20,
              fontFamily: 'jaapokkienchance',
            ),
          ),
          SizedBox(
            height: 200,
            child: StreamBuilder(
              stream: _users.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            documentSnapshot['username'],
                            style: TextStyle(fontFamily: 'jaapokkienchance'),
                          ),
                          subtitle: Text(
                            documentSnapshot['email'],
                            style: TextStyle(fontFamily: 'jaapokkienchance'),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _update(documentSnapshot)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
