import 'package:flutter/material.dart';
import 'package:flutter_app_todo/models/todo.dart';
import 'package:flutter_app_todo/services/category_service.dart';
import 'package:flutter_app_todo/services/todo_service.dart';
class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();

  var _selectedValue;

  var _categories = List<DropdownMenuItem>();

  @override
  void initState(){
    super.initState();
    _loadCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _loadCategories() async{
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category['name']),
        value: category['name'],
        ));
      });
    });
  }

  _showSuccessSnackBar(message) {
    var _snackbar = SnackBar(content: message,);
    _globalKey.currentState.showSnackBar(_snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('create Todo'),
      ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
        children: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write a Title'
              ),
            ),
            TextField(
              controller: todoDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Write Description'
              ),
            ),
            TextField(
              controller: todoDateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a Date',
                prefixIcon: InkWell(
                  onTap: (){},
                  child: Icon(Icons.calendar_today),
                )
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButton(
              value: _selectedValue,
              items: _categories,
              hint: Text('category '),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text('Save'),color: Colors.blue,
              onPressed: () async{
                var todoObject = Todo();

                todoObject.title = todoTitleController.text;
                todoObject.description = todoDescriptionController.text;
                todoObject.isFinished = 0 ;
                todoObject.category = _selectedValue.toString();
                todoObject.todoDate = todoDateController.text;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                if (result > 0) {
                  _showSuccessSnackBar(Text("todo added"));
                }
                print(result);
              },
            )
        ],
    ),
          ),
    );
  }
}
