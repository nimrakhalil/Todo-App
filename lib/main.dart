import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'database.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');

  runApp(MaterialApp(
    home: myapp(),
    debugShowCheckedModeBanner: false,
  ));
}

class myapp extends StatefulWidget {
  const myapp({super.key});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  List tasks = [];
  TextEditingController titlecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Database obj = Database();
  final box = Hive.box('mybox');

  @override
  void initState() {
    // TODO: implement itState
    if (box.isNotEmpty) {
      obj.load();
    }
    super.initState();
  }

  void _onButtonPressed() {
    print('Button pressed.');
    _scaffoldKey.currentState?.openDrawer();
    // Add your functionality for the button press here
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/c.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 74, 133, 134)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: AssetImage('assets/e.jpg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nimra Khalil',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      'nimrakhalilofficial@gmail.com',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  // Add your functionality for the Home item
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
                onTap: () {
                  // Add your functionality for the Messages item
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Add your functionality for the Settings item
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SizedBox(
                  width: 14,
                ),
                IconButton(
                  icon: Icon(Icons.menu), // Using a built-in icon (plus sign)
                  onPressed: _onButtonPressed,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 120,
                ),
                Text(
                  " TO DO ",
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 11, 64, 65)),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  // height: 100,
                  width: 150,
                ),
                Text(
                  " List Your Life ",
                  style: TextStyle(
                      fontSize: 15,
                      // fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 11, 64, 65)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: obj.tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      // Specify the direction to swipe and delete
                      direction: DismissDirection.endToStart,
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        //Removes that item the list on swipwe
                        setState(() {
                          obj.tasks.removeAt(index);
                          obj.save();
                        });
                        //Shows the information on Snackbar
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 238, 238, 235),
                            ),
                            child: ListTile(
                              // shape: RoundedRectangleBorder(
                              //   side: BorderSide(width: 2),
                              //   borderRadius:
                              //       BorderRadius.circular(50), //<-- SEE HERE
                              // ),

                              leading: Container(
                                padding: EdgeInsets.all(7),
                                child: Checkbox(
                                  //value: tasks[index].isCompleted,
                                  value: obj.tasks[index][1],
                                  onChanged: (newValue) {
                                    setState(() {
                                      obj.tasks[index][1] = newValue!;
                                      obj.save();
                                    });
                                  },
                                ),
                                height: 50,
                                width: 50,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     color: Colors.transparent),
                              ),
                              title: Text(
                                obj.tasks[index][0],
                                style: TextStyle(
                                    decoration: obj.tasks[index][1]
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 11, 64, 65)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(height: 30),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // style: ElevatedButton.styleFrom(
          //     backgroundColor:
          //         Color.fromARGB(255, 11, 64, 65) // Background color
          //     ),
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    //elevation: 0,
                    content: Container(
                      height: 220,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0)),
                        image: DecorationImage(
                          image: AssetImage("assets/c.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Add your task",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 11, 64, 65),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                new Flexible(
                                  child: new TextField(
                                      controller: titlecontroller,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        hintText: " Enter your task ",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(255, 25,
                                                  131, 133)), //<-- SEE HERE
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    if (titlecontroller.text.isNotEmpty) {
                                      setState(() {
                                        String titlectr = titlecontroller.text;
                                        //tasks.add(Task(name: titlectr, isCompleted: false));
                                        obj.tasks.add([titlectr, false]);
                                        obj.save();
                                        Navigator.of(context).pop();
                                        titlecontroller.clear();
                                      });
                                    }
                                  },
                                  color: Color.fromARGB(255, 11, 64, 65),
                                  child: Text(
                                    'Add',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                MaterialButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Color.fromARGB(255, 11, 64, 65),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          backgroundColor: Color.fromARGB(255, 11, 64, 65),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
    
  }
}
