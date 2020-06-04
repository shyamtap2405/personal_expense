import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;
  ChartBar(this.label,this.spendingAmount,this.spendingPctOfTotal);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return Column(children: <Widget>[
      Container(
        height: constraints.maxHeight*0.10,
        child: FittedBox(
                child: Text('₹${spendingAmount.toStringAsFixed(0)}'
          ),
        ),
      ),
      SizedBox(height:constraints.maxHeight*0.05),
      Container(
        height: constraints.maxHeight*0.6,
        width: 10,
        child: Stack(children: <Widget>[
          Container(decoration:BoxDecoration(
            border: Border.all(color: Colors.grey,width:1),
            color:MediaQuery.of(context).platformBrightness==Brightness.light?Color.fromRGBO(240,240,240,0.7) : Colors.white,
          borderRadius:BorderRadius.circular(10)
          ),
          
          ),
          FractionallySizedBox(heightFactor: spendingPctOfTotal,child: Container(decoration: BoxDecoration(
            color:MediaQuery.of(context).platformBrightness==Brightness.light? Theme.of(context).primaryColor:Colors.lightBlue,
            borderRadius: BorderRadius.circular(10)),
            ),
            ),
          
        ],),
        
      ),
      SizedBox(height:constraints.maxHeight*0.05),
      Container(height: constraints.maxHeight*0.15,
        child: Text(label))
    ],
      
    );
    },); 
  }
}