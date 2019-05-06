import 'package:flutter/material.dart';
import 'package:flutter_assignment_03/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskScreen();
  }
}

class _TaskScreen extends State<TaskScreen> {
  static int index = 0;
  static List<String> id_doc = new List<String>();

// Button add or bin
  @override
  Widget build(BuildContext context) {
    final List btn = <AppBar>[
      AppBar(
        title: Text("Todo"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.pushNamed(context, "//");
            },
          )
        ],
      ),
      AppBar(
        title: Text("Todo"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              setState(() {
                for (int i = 0; i < _TaskScreen.id_doc.length; i++) {
                  Firestore.instance
                      .collection('todo')
                      .document(_TaskScreen.id_doc[i])
                      .delete();
                }
                _TaskScreen.id_doc = new List<String>();
              });
            },
          )
        ],
      )
    ];

    return Scaffold(
      appBar: btn[index],
      body: StreamBuilder(
        stream: Firestore.instance.collection('todo').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text("No data found"),
              );
            }
            _TaskScreen.id_doc = new List<String>();

            List<Todo> notdone = new List<Todo>();
            List<Todo> done = new List<Todo>();
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              var item = snapshot.data.documents[i];
              if (item['done'] == 0) {
                notdone.add(new Todo(
                    id: item.documentID,
                    title: item['title'],
                    done: item['done']));
              } else {
                id_doc.add(item.documentID);
                done.add(new Todo(
                    id: item.documentID,
                    title: item['title'],
                    done: item['done']));
              }
            }
            if ((notdone.length == 0 && index == 0) ||
                (done.length == 0 && index == 1)) {
              return Center(
                child: Text("No data found"),
              );
            }

            return ListView.builder(
              itemCount: index == 0 ? notdone.length : done.length,
              itemBuilder: (BuildContext context, int i) {
                Todo item = index == 0 ? notdone[i] : done[i];
                return ListTile(
                  title: Text(item.title),
                  trailing: Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        Firestore.instance
                            .collection('todo')
                            .document(item.id)
                            .updateData({'done': value ? 1 : 0});
                      });
                    },
                    value: item.done == 1 ? true : false,
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.brown[100],
        ),
        child: BottomNavigationBar(
          onTap: appbarTab,
          currentIndex: _TaskScreen.index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: new Text('Task'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              title: new Text('Completed'),
            ),
          ],
        ),
      ),
    );
  }

  void appbarTab(int i) {
    setState(() {
      index = i;
    });
  }
}
