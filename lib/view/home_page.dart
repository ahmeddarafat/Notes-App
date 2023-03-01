import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/view/add_or_edit_note.dart';

import '../sqldb/sqldb.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _searchController;
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
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        AnimationSearchBar(
          //* text
          centerTitle: 'Notes App',
          hintText: 'Search here...',

          //* Styles
          // title text style
          centerTitleStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 20,
          ),
          // Search hint text style
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w300,
          ),
          // Search Text style
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),

          //* colors
          backIconColor: Colors.white,
          closeIconColor: Colors.white,
          cursorColor: Colors.lightBlue.shade300,
          searchIconColor: Colors.white,

          //* previous screen
          isBackButtonVisible: false,
          previousScreen: null,

          // call this func when search field changes 
          onChanged: (text) => debugPrint(text),
          duration: const Duration(milliseconds: 500),
          searchTextEditingController: _searchController,

          //* dimensions
          // Total height of the search field
          searchFieldHeight: 35,
          // Total height of this Widget
          searchBarHeight: 50, 
          // Total width of this Widget
          searchBarWidth: MediaQuery.of(context).size.width -40, 
          // the horizontal & vertical padding of the whole widget
          horizontalPadding: 20,
          verticalPadding: 0,

          //* decoration
          searchFieldDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ]),
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
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return AddOrEditNote(
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
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
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
