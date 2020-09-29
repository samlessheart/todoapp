import 'package:flutter_app_todo/models/todo.dart';
import 'package:flutter_app_todo/repositories/repository.dart';

class TodoService{
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  saveTodo(Todo todo) async{
    return await _repository.insertData('todos', todo.todoMap());
  }

  readTodos() async{
    return await _repository.readData('todos');
  }

  readTodosBy(category) async{
    return await _repository.readDataByColumnName('todos', 'category', category);
  }
}