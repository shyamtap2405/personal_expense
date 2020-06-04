import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController=TextEditingController();
  DateTime  _selectedDate;
  final _amountController=TextEditingController();

                    void _submitData(){
                      if(_amountController.text.isEmpty)
                      {
                        return;
                      }

                      
                      final enteredTitled=_titleController.text;
                      final enteredAmount=double.parse(_amountController.text);
                      if(enteredTitled.isEmpty||enteredAmount<=0||_selectedDate==null)
                      {
                        return;
                      }


                          widget.addTx(enteredTitled,enteredAmount,_selectedDate);

                          Navigator.of(context).pop();
                         }
                          void _presentDatePicker(){
                            showDatePicker(context: context,
                          
                             initialDate: DateTime.now(),
                             firstDate: DateTime(2019),
                            lastDate: DateTime.now()
                            ).then((pickedDate){
                              if(pickedDate== null){
                                return;
                              }
                              setState(() {
                                _selectedDate=pickedDate;
                              });
                            });

                           }

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);
    return  SingleChildScrollView(
          child: Card(
            color: MediaQuery.of(context).platformBrightness==Brightness.light? Colors.white 
            :Color.fromRGBO(35, 40, 45, 1),
                elevation: 5,
                child: Container(
                  padding:EdgeInsets.only(top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom+10
                  ),
                  child: Column(crossAxisAlignment:CrossAxisAlignment.end,
                    children: <Widget>[
                    TextField(style: TextStyle(color:mediaQuery.platformBrightness==Brightness.light ?
                    Theme.of(context).primaryColor:
                    Theme.of(context).accentColor),
                      decoration:InputDecoration(labelText: 'Title',
                    
                    labelStyle: TextStyle(color:mediaQuery.platformBrightness==Brightness.light? Colors.black :Colors.white)
                    ),
                     controller: _titleController,
                     onSubmitted:(_) => _submitData(),
                     ),
                    TextField(
                      style: TextStyle(color:mediaQuery.platformBrightness==Brightness.light ?
                    Theme.of(context).primaryColor:
                    Theme.of(context).accentColor),
                      decoration: InputDecoration(labelText: 'Amount',labelStyle
                      : TextStyle(color:mediaQuery.platformBrightness==Brightness.light?
                       Colors.black :Colors.white)),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted:   (_) => _submitData(),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                         child: Text( _selectedDate == null ?
                         'No Date Chosen!':
                         'Picked Date:${DateFormat.yMMMd().format(_selectedDate)}',
                         style: TextStyle(color: 
                         MediaQuery.of(context).platformBrightness==Brightness.light?
                         Theme.of(context).primaryColor:
                         Colors.amber),
                        ),
                      ),
                     Platform.isIOS? 
                     CupertinoButton(child: Text('Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                      ),
                       onPressed:  _presentDatePicker)
                       :FlatButton(onPressed: _presentDatePicker, 
                      child: Text('Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                      ),
                      )
                    ],),
                    RaisedButton(onPressed:_submitData ,
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                     child: Text('Add Transaction',
                     style: TextStyle(fontWeight: FontWeight.bold),)
                     )

                  ],
                  ),
                )
              ),
    ); 
      
    
  }
}