import 'package:flutter/material.dart';
import 'package:notes_app/sqldb/sqldb.dart';
import 'package:notes_app/view/home_page.dart';

class AddOrEditNote extends StatefulWidget {
  final String title;
  final String note;
  final int? id;
  const AddOrEditNote({
    super.key,
    this.id,
    this.title = "",
    this.note = "",
  });

  @override
  State<AddOrEditNote> createState() => _AddOrEditNoteState();
}

class _AddOrEditNoteState extends State<AddOrEditNote> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  final SqlDB db = SqlDB();
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final bool isNew;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _noteController = TextEditingController(text: widget.note);
    isNew = widget.title.isEmpty;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isNew ? "Add Note" : "Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "Add Title"),
                validator: (title) {
                  if (title!.isEmpty) {
                    return "please, enter title";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(hintText: "Add Note"),
                validator: (title) {
                  if (title!.isEmpty) {
                    return "please, enter title";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  int response = 0;
                  if (_formKey.currentState!.validate()) {
                    if (isNew) {
                      response = await db.insertNote(
                          _noteController.text, _titleController.text);
                    } else {
                      response = await db.updateNote(_noteController.text,
                          _titleController.text, widget.id!);
                    }

                    if (response > 0) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const MyHomePage();
                      }));
                    }
                  }
                },
                child: Text(isNew ? "Add Note" : "Edit Note"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
