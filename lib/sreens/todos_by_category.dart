import 'package:flutter/material.dart';
import 'package:flutter_app_todo/models/todo.dart';
import 'package:flutter_app_todo/services/todo_service.dart';


class TodosByCategory extends StatefulWidget {
  final String category;
  TodosByCategory({this.category});

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = List<Todo>();
  TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getTodosByCategories();
  }

  getTodosByCategories() async{
    var todos = await _todoService.readTodosBy(this.widget.category);
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];
        print(this.widget.category.runtimeType);

        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: ListView.builder(itemCount: _todoList.length, itemBuilder: (context, index) {
            return Card(
              elevation: 10,
              child: ListTile(

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_todoList[index].title ?? 'No title')
                  ],
                ),
                subtitle: Text(_todoList[index].description ?? 'No description'),
                trailing: Text(_todoList[index].todoDate ?? 'No date'),
              ),
            );
          }))
        ],
      ),
    );
  }
}
