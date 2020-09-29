import 'package:flutter/material.dart';
import 'package:flutter_app_todo/models/category.dart';
import 'package:flutter_app_todo/services/category_service.dart';
import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var category;

  var _editcategoryNameController = TextEditingController();
  var _editcategoryDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();


  getAllCategories() async{
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategory();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async{
    category = await _categoryService.readCategoryById(categoryId);
        setState(() {
          _editcategoryNameController.text = category[0]['name'] ?? 'No Name';
          _categoryDescriptionController.text = category[0]['description'] ?? 'No Description';
        });
        _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(onPressed: ()=>Navigator.pop(context),
              child: Text('Cancel')),
          FlatButton(onPressed: () async{
            _category.name = _categoryNameController.text;
            _category.description = _categoryDescriptionController.text;
           var result = await _categoryService.saveCategory(_category);
           print (result);
           Navigator.pop(context);
           getAllCategories();
           _showSuccessSnackBar(Text('Category Added'));

          },
              child: Text('Save')),
        ],
        title: Text("Categories form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write a category',
                  labelText: 'Category',
                ),
              ),TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Write a description',
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(context: context, barrierDismissible: true, builder: (param){
        return AlertDialog(
        actions: <Widget>[
          FlatButton(onPressed: ()=>Navigator.pop(context),
              child: Text('Cancel')),
          FlatButton(onPressed: () async{
            _category.id = category[0]['id'];
            _category.name = _editcategoryNameController.text;
            _category.description = _editcategoryDescriptionController.text;
           var result = await _categoryService.updateCategory(_category);
           if (result > 0) {
             print (result);
             Navigator.pop(context);
             getAllCategories();
             _showSuccessSnackBar(Text('Updated'));
           }
          },
              child: Text('Update')),
        ],
        title: Text("Edit Categories form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editcategoryNameController,
                decoration: InputDecoration(
                  hintText: 'Edit a category',
                  labelText: 'Category',
                ),
              ),TextField(
                controller: _editcategoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Edit a description',
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.green,
            onPressed: ()=>Navigator.pop(context),
              child: Text('Cancel'),),
          FlatButton(
              color: Colors.red,
              onPressed: () async{

           var result = await _categoryService.deleteCategory(categoryId);
           if (result > 0 ) {
             Navigator.pop(context);
             getAllCategories();
             _showSuccessSnackBar(Text('Deleted'));
             print('deleted $categoryId');
           }
          },
              child: Text('Delete')),
        ],
        title: Text("Delete Categories form")
      );
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
        leading: RaisedButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())),
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Text("Categories"),
      ),
      body: ListView.builder(itemCount: _categoryList.length, itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 5.0,
            child: ListTile(
              leading: IconButton(icon: Icon(Icons.edit), onPressed: () {
                _editCategory(context, _categoryList[index].id);
              },),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_categoryList[index].name),
                  IconButton(icon: Icon(Icons.delete), onPressed: (){
                    _deleteFormDialog(context, _categoryList[index].id);
                  },)
                ],
              ),
              subtitle: Text(_categoryList[index].description),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
