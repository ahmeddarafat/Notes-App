import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_app/view/add_or_edit_note.dart';

import '../sqldb/sqldb.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SqlDB db = SqlDB();
  List<Map> notes = [];

  _getNotes() async {
    notes.addAll(await db.selectAll());
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note App"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                title: Text(
                  notes[index]["title"],
                ),
                subtitle: Text(
                  notes[index]["note"],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,color: Colors.blue,),
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return  AddOrEditNote(
                                id: notes[index]["id"],
                                title: notes[index]["title"],
                                note: notes[index]["note"],
                              );
                            },
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,color: Colors.red,),
                      onPressed: () async {
                        int response = await db.deleteNote(notes[index]["id"]);
                        if (response > 0) {
                          notes.removeWhere(
                              (note) => note["id"] == notes[index]["id"]);
                          setState(() {});
                        }
                      },
                    ),
                  ],
                )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const AddOrEditNote();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
