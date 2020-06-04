
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense/models/transaction.dart';
import 'package:personal_expense/widgets/chart.dart';
import 'package:personal_expense/widgets/new_transaction.dart';
import 'package:personal_expense/widgets/transaction_list.dart';

import 'db_helper.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense',
      home: MyHomePage(),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch:Colors.cyan,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(title:TextStyle(fontFamily: 'OpenSans',
        fontSize: 16,
        fontWeight: FontWeight.normal),
        subtitle: TextStyle(fontFamily: 'OpenSans',
        fontSize: 12,
        color: Colors.blueAccent),
        display1: TextStyle(color: Colors.grey),
         button:TextStyle(color: Colors.white),
        ),
        
       
        appBarTheme: AppBarTheme(textTheme:ThemeData.light().textTheme.copyWith(title:TextStyle(fontFamily: 'OpenSans',
        fontSize: 20,
        fontWeight: FontWeight.bold)
        ))
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
          // primaryColor: Colors.blue,
          primaryColor: Color.fromRGBO(15,20,25, 1),
         primarySwatch:Colors.blue,
        accentColor: Colors.lightBlue,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(title:TextStyle(fontFamily: 'OpenSans',
        fontSize: 18,
        fontWeight: FontWeight.normal),
         subtitle: TextStyle(fontFamily: 'OpenSans',
        fontSize: 12,
        color: Colors.lightBlueAccent),
        display1: TextStyle(color: Colors.white),
         button:TextStyle(color: Colors.white),
        ),
        
       
        appBarTheme: AppBarTheme(textTheme:ThemeData.light().textTheme.copyWith(title:TextStyle(fontFamily: 'OpenSans',
        color: Colors.lightBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold)
        ))
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  
   

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    List<Transaction> _userTransactions=[
    // Transaction(id: 't1',title: 'new shoes',amount: 600,date: DateTime.now()),
   // Transaction(id: 't2',title: 'shirt',amount: 200,date: DateTime.now()),
  ];

  bool _showChart=false;

   List<Transaction> get recentTransactions{
     
     return _userTransactions.where((tx){
       return(tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))));
     }).toList();
     
   }


  Future<void> _addNewTransaction(String title,double amount,DateTime chosenDate) async {
   final newtx= Transaction(id: DateTime.now().toString(), amount: amount, title: title, date: chosenDate);
    await DbHelper.insert('shyam',{
      'id':newtx.id,
      'title':newtx.title,
      'amount':newtx.amount,
      'dateTime':newtx.date.toIso8601String()
    } );
    setState(() {
      _userTransactions.add(newtx);
    });
  }


  void _startAddNewTransaction(BuildContext context){
    showModalBottomSheet(backgroundColor: Theme.of(context).accentColor
    ,context: context, builder: (_){

      return GestureDetector(onTap: (){},
      child: NewTransaction(_addNewTransaction),
      behavior: HitTestBehavior.opaque,
      );

       
    });
  }


  
  Future<void> _deleteTransaction(String id) async {
     await DbHelper.deleteColumn('shyam', id);

    setState(() {
      _userTransactions.removeWhere((tx)=> tx.id==id);
    });
  }

   Future<void> fetchAndSetTransactions() async{
   final dataList= await DbHelper.getData('shyam');
    _userTransactions=dataList.map((transaction)=>Transaction(
    id: transaction['id'], 
    amount: transaction['amount'], 
    title: transaction['title'], 
    date: DateTime.parse(transaction['dateTime'])
    )).toList();
    

  } 


  

  @override
  Widget build(BuildContext context) {
     final isLandScape= MediaQuery.of(context).orientation==Orientation.landscape;
   
   
    final PreferredSizeWidget appBar= Platform.isIOS? CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        Switch.adaptive(activeColor: Theme.of(context).accentColor,
                        inactiveThumbColor: Colors.white,
                 value: _showChart, onChanged: (val){
                 setState(() {
                    _showChart=val;
                 });
                
               })

      ],),
    ):AppBar(
        title: Text('Personal Expenses'),
        actions: <Widget>[
           if(isLandScape) 
                
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
               children: 
               <Widget>[
               Text('Show Chart',
               style: TextStyle(color:Theme.of(context).primaryColor,
               fontWeight: FontWeight.bold,
               ),),
               Switch.adaptive(activeColor: Theme.of(context).accentColor,
               inactiveThumbColor: Colors.white,
                 value: _showChart, onChanged: (val){
                 setState(() {
                    _showChart=val;
                 });
                
               })

             ],
             )
        ],
      );

      




      final listTxWidget= Container(height: (MediaQuery.of(context).size.height
                                      -appBar.preferredSize.height-
                                      MediaQuery.of(context).padding.top)*0.7,
               child: FutureBuilder(future: fetchAndSetTransactions(),
                 builder: (context,snapshot)=>snapshot.connectionState==ConnectionState.waiting?
                 Center(child: CircularProgressIndicator(),)
                 :
               TransactionList(_userTransactions,_deleteTransaction,fetchAndSetTransactions)
               ));

               final chartWidget=Chart(recentTransactions);
     
     
     final pageBody=SafeArea(child:  SingleChildScrollView(
                    child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
               
                
             if(!isLandScape)Container(height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.3,
                child:FutureBuilder(future: fetchAndSetTransactions(),builder: (context,snapshot)=> chartWidget)),
                if(!isLandScape)listTxWidget,
                

             if(isLandScape) _showChart==true? Container(height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.7,
                child:FutureBuilder(future: fetchAndSetTransactions(),builder: (context,snapshot)=> chartWidget))
                : listTxWidget
            
             
            ],
        ),
         ),
     );
  
    
    
    
    return Platform.isIOS?CupertinoPageScaffold(child: pageBody) : Scaffold(
      backgroundColor: MediaQuery.of(context).platformBrightness==Brightness.light?
         Colors.white
         : Color.fromRGBO(25, 30, 35, 1),
      appBar:appBar ,
      body: 
      
       Container(
         
         child: pageBody),
        
         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
         floatingActionButton: FloatingActionButton(onPressed:  () => _startAddNewTransaction(context),
         child: Icon(Icons.add),
         ),
      );
    
  }
}
