import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:makequiz/screens/note.dart';

import '../components/Nav.dart';
import '../utils.dart';

class HeaderItem {
  final Icon icon;
  final String text;
  final String number;
  final Color? color;

  HeaderItem(
      {required this.icon,
      required this.text,
      required this.number,
      required this.color});
}

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  var headerItems = [
    HeaderItem(
        icon: Icon(Icons.star),
        text: "Starred",
        number: "7",
        color: Colors.blue[700]!),
    HeaderItem(
        icon: Icon(Icons.archive),
        text: "Archive",
        number: "7",
        color: Colors.yellow[700]!),
    HeaderItem(
        icon: Icon(Icons.garage),
        text: "Trash",
        number: "7",
        color: Colors.red[700]!),
    HeaderItem(
        icon: Icon(Icons.notifications),
        text: "Notifications",
        number: "7",
        color: Colors.grey[700]!),
    HeaderItem(
        icon: Icon(Icons.settings),
        text: "Settings",
        number: "7",
        color: Colors.grey[400]!),
  ];

  var noteItems = [
    HeaderItem(
        icon: Icon(Icons.book),
        text: "Intro to CS",
        number: "7",
        color: Colors.grey[500]!),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "CS for nerds",
        number: "7",
        color: Colors.grey[500]),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "how to git",
        number: "7",
        color: Colors.grey[500]),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "hi",
        number: "7",
        color: Colors.grey[500]),
    HeaderItem(
        icon: Icon(Icons.book),
        text: "notes",
        number: "7",
        color: Colors.grey[500]),
  ];

  bool _isDeleting = false;

  void _addNewNote() {
    setState(() {
      noteItems.add(HeaderItem(
          icon: Icon(Icons.book),
          text: "New Note",
          number: "",
          color: Colors.grey[500]));
    });
  }

  void _toggleDeleteMode() {
    setState(() {
      _isDeleting = !_isDeleting;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      noteItems.removeAt(index);
    });
  }

  Widget buildItem(HeaderItem item, int index) {
    return GestureDetector(
      onTap: () {
        if (_isDeleting) {
          _deleteNote(index);
        } else {
          navigate(context, Note(title: item.text));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _isDeleting
                    ? IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () => _deleteNote(index),
                      )
                    : item.icon,
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey, thickness: 0.2)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nav("Library", context),
      drawer: sidebar(context),
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          children: [
            // ...headerItems.map((item) => buildItem(item, -1)).toList(),
            // const Divider(
            //   color: Colors.grey,
            //   thickness: 1,
            // ),
            ...noteItems
                .asMap()
                .entries
                .map((entry) => buildItem(entry.value, entry.key))
                .toList(),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: _addNewNote,
            label: 'Add Note',
          ),
          SpeedDialChild(
            child: Icon(_isDeleting ? Icons.check : Icons.delete),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: _toggleDeleteMode,
            label: 'Delete Note',
          ),
        ],
      ),
    );
  }
}
