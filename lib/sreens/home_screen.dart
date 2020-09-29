import 'package:flutter/material.dart';
import 'package:flutter_app_todo/helpers/drawer_navigation.dart';
import 'package:flutter_app_todo/models/todo.dart';
import 'package:flutter_app_todo/services/todo_service.dart';
import 'package:flutter_app_todo/sreens/todo_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TodoService _todoService;

  List<Todo> _todoList = List<Todo>();

  @override
  initState () {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async{
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach ((todo){
      setState((){
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDoList App"
        ),
      ),
      body: ListView.builder(
          itemCount: _todoList.length,itemBuilder: (context, index){
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_todoList[index].title ?? 'No title')
                  ],
                ),
                subtitle: Text(_todoList[index].category ?? 'No category'),
                trailing: Text(_todoList[index].todoDate ?? 'No date'),
              ),
            );
      }),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(155, 66, 157, 1),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TodoScreen()));
        },
      ),
    );
  }
}
