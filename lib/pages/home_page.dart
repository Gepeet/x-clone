import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:x_clone/services/firestore.dart';

class HomePage extends StatefulWidget{
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //firestore
  final FireStoreService fireStoreService = FireStoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

  //open a dialog box to add a post
  void openPostBox({String? docID,}){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        
        controller: textController,
        
      ),
      actions: [
        ElevatedButton(onPressed: (){
          //check docID to edit

          if (docID == null){
            //Create new post
            fireStoreService.addPost(textController.text);
          }else{
            fireStoreService.updatePost(docID, textController.text);
          }
          
          //clear text
          textController.clear();

          //close the box
          Navigator.pop(context);
        }, child: 
        Text('Post')),
      ],
    ));
  }
   @override
   Widget build(BuildContext context){
      return Scaffold(
         appBar: AppBar(
            title: const Text('X Clone')
         ),
         floatingActionButton: FloatingActionButton(
            onPressed:(){
              openPostBox();
            },
            child: const Icon(Icons.add),
         ),
         body: StreamBuilder<QuerySnapshot>(
          stream: fireStoreService.getPostStream(),
          builder: (context, snapShot){
             //if we have data, get all data

             if(snapShot.hasData){
              List postList = snapShot.data!.docs;

              //display list
              return ListView.builder(
                itemCount: postList.length,
                itemBuilder: 
              (context, index){
                //get individual document
                DocumentSnapshot document = postList[index];
                String docID = document.id;

                //string of post
                Map<String,dynamic> data = document.data() as Map<String, dynamic>;
                String postText = data['post-text'];

                //display UI

                return ListTile(
                  title: Text(postText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    //update icon
                    IconButton(
                    onPressed: () =>
                      openPostBox(docID: docID)
                    ,
                    icon: const Icon(Icons.settings),
                  ),
                  //delete icon
                    IconButton(
                      onPressed: ()=>
                        fireStoreService.deletePost(docID)
                      , 
                      icon: const Icon(Icons.delete))
                  ],)
                );
              }
              );
              
             }
             else{
               return const Text("No Post");
              }
          },
         ),
      );
   }
}
