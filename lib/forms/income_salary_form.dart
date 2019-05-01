import 'package:flutter/material.dart';
import '../models/salary_model.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../utils/db_helper.dart';
import '../utils/common.dart';



class INForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Income_salaryFrom();
  }
}


class Income_salaryFrom extends State<INForm> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  Salary salary_d = Salary('', 0, DateTime.now());
  List<Salary> salarylist;
  int count = 0;

  Common com = Common();


  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  var _formKey = GlobalKey<FormState>();


  final double _minimumPadding = 5.0;




  TextEditingController contactcontoller = TextEditingController();
  TextEditingController salarycontroller = TextEditingController();
  TextEditingController timecontoller = TextEditingController();
  TextEditingController descontroller = TextEditingController();

  var displayResult = '';

   @override
  Widget build(BuildContext context){
    if(salarylist == null){
      salarylist = List<Salary>();
    }


     TextStyle textStyle = Theme.of(context).textTheme.title;

     return new Scaffold(
       appBar: AppBar(
          title: Text('Salary'),
          backgroundColor: Colors.black,
         leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
            ),
            actions: <Widget>[
              Image(
	            width: 50,
	            image: AssetImage("assets/salary.png"),
	          )
            ],
          
       ),
        body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                // getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      // keyboardType: TextInputType.text,
                      style: textStyle,
                      controller: contactcontoller,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter the contact name';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Contact & Company' ,
                          hintText: 'Name eg:Bala or Dostrix',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
  
                    ),
                  ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: salarycontroller,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter the salary amount';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Salary Amount',
                          hintText: 'Rupees',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                    Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      // keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: descontroller,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter the description';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'optional',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                DateTimePickerFormField(
              inputType: inputType,
              format: formats[inputType],
              editable: editable,
              controller: timecontoller,
              decoration: InputDecoration(
                  labelText: 'Date/Time', hasFloatingPlaceholder: false),
              onChanged: (dt) => setState((){ 
                print(dt);
                date = dt;
                print(date);
                }),
            ),
                
                Padding(
                    padding: EdgeInsets.only(
                        bottom: _minimumPadding, top: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              getSalaryFormValues();
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Reset',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Text(
                    this.displayResult,
                    style: textStyle,
                  ),
                )
          
              ],
            )),
      )
    );
  }

  


  void _reset() async{
    salarycontroller.text = '';
    contactcontoller.text = '';
    timecontoller.text = '';
    descontroller.text = '';
  }

 

  void getSalaryFormValues() async{
    double sal = num.tryParse(salarycontroller.text).toDouble();
    salary_d.contact = contactcontoller.text;
    salary_d.amount = sal;
    salary_d.date = date;
    salary_d.desc = descontroller.text;
    dynamic result = await databaseHelper.insertSalary(salary_d);
    print(result);
    if(result != 0){
      print('Saved Successfully');
      Navigator.pop(context, false);
      // com.showSnackBar(context, 'Saved Successfully');
    }else{
      print('Not Saved.');
      // com.showSnackBar(context, 'Not Saved.');
    }
  }
}

