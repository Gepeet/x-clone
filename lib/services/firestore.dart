import 'package:cloud_firestore/cloud_firestore.dart';


class FireStoreService {


   //get collection of notes
   final CollectionReference xclone =
      FirebaseFirestore.instance.collection('xclone');

   //C R E A T E
   Future<void> addPost(String post){
      return xclone.add({
      'post-text': post,
      'timestamp': Timestamp.now(),
   }
      );
   }

   //R E A D 
   //get post from database
   Stream<QuerySnapshot> getPostStream(){
      final postStream =
      xclone.orderBy('timestamp',descending: true).snapshots();
      return postStream;
   }

   //U P D A T E
    Future<void> updatePost(String docID, String newPost){
      return xclone.doc(docID).update({
        'post-text': newPost,
        'timestamp': Timestamp.now(),
      });
    }

   //D E L E T E
   Future<void> deletePost(String docID){
    return xclone.doc(docID).delete();
   }
}
