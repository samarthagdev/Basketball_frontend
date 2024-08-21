import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back),color: Colors.black, onPressed: () => Navigator.pop(context),),
        backgroundColor: const Color(0xFFf8843d),
        elevation: 1,
        centerTitle: true,
        title: const Text('Contact Page',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('If you have any queries please let us know:- \nbasketbcommunity@gmail.com', textAlign: TextAlign.center, style: TextStyle(
          fontWeight: FontWeight.w600, 
          fontSize: 15
        ),),
      ),
    );
  }
}