
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuDetails extends StatefulWidget {
  final String name;
 final  String description;
  const MenuDetails({super.key,required this.name,required this.description});

  @override
  State<MenuDetails> createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: (){Navigator.pop(context);},
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.arrow_back,color: Colors.white,)),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.15,),
                  Center(child: Text(
                   overflow: TextOverflow.ellipsis,
                    "${widget.name}",style: Theme.of(context).textTheme.bodyLarge,)),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Text("Lets talk about details",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12),),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                 Text("${widget.description}",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15,fontWeight: FontWeight.w400),),
            ],
          ),
        ),
      ),
    );
  }
}