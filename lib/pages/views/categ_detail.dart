import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './../../dbutils/DBhelper.dart' show Models;
import './../models/category.dart' show categoryTypes;
import '../../Xwidgets/fields.dart' show DateTimeItem, WidgetMany2One, WidgetSelection;

// import './../../Xwidgets/Xcommon.dart' show getM2o;

Models models = Models();

//Future<List<Map<String, dynamic>>>
Future<List<Map>> fetchCategoriesFromDatabase() async {
  return models.getTableData("Category");
}

void main(){
  /// The default is to dump the error to the console.
  /// Instead, a custom function is called.
  FlutterError.onError = (FlutterErrorDetails details) async {
    await _reportError(details);
  };
}


class CategoryDetailPage extends StatefulWidget {
  final String title;
  final Map listData;

  CategoryDetailPage(this.title, this.listData);

  @override
  State<StatefulWidget> createState() {

    return CategoryDetailPageState(this.title, this.listData);
  }
}

class CategoryDetailPageState extends State<CategoryDetailPage> {

  String title;
  Map listData ;
  CategoryDetailPageState(this.title, this.listData);

  Models db = models;

  final categoryScaffoldKey = GlobalKey<ScaffoldState>();
  final categoryFormKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var categoryTypeController = TextEditingController();
  var parentIdController = TextEditingController();
  Future categoryListFeature = fetchCategoriesFromDatabase();
  List<Map> categoryDropDownList = List();
  Color themeColor;
  // String _currentParentId = '0';
  

  @override
  initState(){
    super.initState();
    db.init();
    initFormDefaultValues(this.listData);
    getTheme();
  }

  @override
  void dispose() {
    db.disposed();
    super.dispose();
  }

  // Initiate Form view values
  initFormDefaultValues(Map listData){
    print(listData);
    int recId = listData['id'];
    if(recId != null) {
      nameController.text = listData['name'];
      categoryTypeController.text = listData['categoryType'];
      parentIdController.text = listData['parentId'].toString();
    } else {
      // parentIdController.text = '';
      categoryTypeController.text = '';
    }
    setState(() {
      // this._currentParentId = parentIdController.text;
    });
    // print(parentIdController.text);
  }

  getTheme() {
    String sqlStmt = "SELECT * FROM Settings where name='themeColor' limit 1";
    models.rawQuery(sqlStmt).then((res){
      if(res.isNotEmpty) {
        setState(() {
          themeColor = Color(int.parse(res[0]['value']));
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    
    db.values['Category']['id'] = this.listData['id'];
    // db.values['Category']['categoryId'] = this.listData['categoryId'];

    return Scaffold(
      key: categoryScaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          title: Text(this.title),
          // backgroundColor: themeColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.view_list),
              tooltip: 'Category List',
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: categoryFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (val){
                  if(val.length == 0) {
                    return "Enter Category";
                  } else {
                    db.values['Category']['name'] = nameController.text;
                  }
                },
                onSaved: (val) => db.values['Category']['name'] = val,
              ),
              
              // DropdownButtonFormField(
              //   decoration: InputDecoration(labelText: 'Type'),
              //   value: (categoryTypeController.text != null) ? categoryTypeController.text : '-',
              //   items: categoryTypes.map((item){
              //     return DropdownMenuItem(
              //       value: item,
              //       child:Text(item)
              //     );
              //   }).toList()
              //   ..add(DropdownMenuItem(value: '-', child: Text("No Data"),)),
              //   onChanged: (val){
              //     // print(val);
              //     setState(() {
              //       categoryTypeController.text = val;
              //       // db.values['Category']['categoryType'] =  categoryTypeController.text;
              //     });
              //   },
              //   onSaved: (val) => db.values['Category']['categoryType'] = categoryTypeController.text,
              // ),
              WidgetSelection(
                label: 'Type',
                controllerText: categoryTypeController.text,
                items: categoryTypes,
                onChanged: (val){
                  setState(() {
                    categoryTypeController.text = val;
                  });
                },
                onSaved: (val) => db.values['Category']['categoryType'] = categoryTypeController.text,
              ),

              WidgetMany2One(
                tbl: 'Category',
                label: 'Parent Category',
                defaultValue: {'0': 'No-Data'},
                valueField1: 'parentId',
                controllerText: parentIdController.text,
                onChanged: (val){
                  // print(val);
                  setState((){
                    parentIdController.text = val;
                  });
                },
                onSaved: (val){
                  // print(parentIdController.text);
                  db.values['Category']['parentId'] = int.parse(parentIdController.text);
                },
              ),
              
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  onPressed: _submit,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    try {
      db.values['Category']['createDate'] = DateFormat.yMMMd().format(DateTime.now());
      if (this.categoryFormKey.currentState.validate()) {
        categoryFormKey.currentState.save();
      }else{
        return null;
      }
      // print(db.values['Category']);
      db.save('Category');
      _showSnackBar("Data saved successfully");

      moveToLastScreen();
    } catch (e) {
      _showSnackBar(e.toString());
      throw e;
    }
    
  }

  void _showSnackBar(String text) {
    categoryScaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(text)));
  }
  

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  // String validateValue(validateId){
  //   db.rawQuery("select id from Category where id = " + validateId).then((val){
  //     print(val);
  //     String result = '0';
  //     if(val.length > 0){
  //       result = validateId;
  //     }
  //     setState(() {
  //       parentIdController.text = result;
  //       db.values['Category']['parentId'] =  result;
  //     });
  //     return result;
  //   });
  // }
  
}


/// Reports [error] along with its [stackTrace]
Future<Null> _reportError(FlutterErrorDetails details) async {
  // details.exception, details.stack

  FlutterError.dumpErrorToConsole(details);
}