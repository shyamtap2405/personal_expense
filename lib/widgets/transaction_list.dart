import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';


class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  final Function fetchAndSetTransactions;

  TransactionList(this.transactions,this.deleteTransaction,this.fetchAndSetTransactions);
 
 
 
  @override
  Widget build(BuildContext context) {
    return
    
       transactions.isEmpty?
       LayoutBuilder(builder :(ctx,constrainsts){
         
         return Column(children: <Widget>[
           
         Text('No Transaction Yet!',style: Theme.of(context).textTheme.title,),
        const SizedBox(height: 20,),
        Container(
          height: constrainsts.maxHeight*0.6,
          child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,))

      ],
      );
       })
       :

    FutureBuilder(future: fetchAndSetTransactions()
      ,builder: (context,snapshot)=>snapshot.connectionState==ConnectionState.waiting?
      Center(child: CircularProgressIndicator(),)
      
       :
      ListView.builder(
        itemBuilder: (ctx,index){
          return Card(
            
            
            color: MediaQuery.of(context).platformBrightness==Brightness.light?
            Colors.white 
            :
            Color.fromRGBO(35, 40, 45, 1),
            elevation: 5,
            margin: EdgeInsets.symmetric(
              vertical:8,
              horizontal:5
            ),
                      child: ListTile(
                      
              leading: CircleAvatar(
                
                radius: 30,
                child: Padding(
                     padding: const EdgeInsets.all(6),
                            child: FittedBox(
                    child: Text(
                      '₹${transactions[index].amount}',style: TextStyle(color:
                      MediaQuery.of(context).platformBrightness==Brightness.light?
                        Colors.black
                      :  Theme.of(context).accentColor

                    ),)
                      ),
                ),
                    ),
                    title: Text(transactions[index].title,
                    style: Theme.of(context).textTheme.title,),
                    subtitle: Text(DateFormat().add_yMMMd().format(transactions[index].date),
                    style: Theme.of(context).textTheme.subtitle,),
                    trailing: MediaQuery.of(context).size.width>460 ? 
                    FlatButton.icon(icon: Icon(Icons.delete),
                     label:  const Text("Delete"),
                    textColor: Theme.of(context).errorColor,
                    onPressed: ()=>deleteTransaction(transactions[index].id),
                    ) : IconButton(icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                     onPressed:()=> deleteTransaction(transactions[index].id)),




            ),
          );
                
              

        },
        itemCount: transactions.length,

                
                  
              
        
      
    )
    );
  }
}