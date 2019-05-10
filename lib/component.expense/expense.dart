import 'package:flutter/material.dart';
import './pages/expense_online.dart';
import './pages/expense_purchase.dart';


class Expenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Image(
	        width: 74,
          height: 41,
	        image: AssetImage("assets/onlinexp.png"),
	      )),
                Tab(icon: Image(
	        width: 74,
          height: 41,
	        image: AssetImage("assets/purchase.png"),
	      ))
              ],
            ),
            title: Text('Expenses'),
            backgroundColor: Color.fromRGBO(107, 99, 255, 1),
            leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
            ),
          ),
          body: TabBarView(
            children: [
              ExpOnline(),
              ExpensePur()
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}