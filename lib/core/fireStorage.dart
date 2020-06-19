
import 'dart:async';
import 'dart:convert';


import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';



File file;
StorageReference storageReference;

 _isolateEntry(dynamic d) async {
  final ReceivePort receivePort = ReceivePort();
  d.send(receivePort.sendPort);
  Map data =   await  receivePort.first;
  var image = decodeImage(data["file"].readAsBytesSync());
  var thumbnail = copyResize(image, width: 600);
  Uint8List sendData =  encodeJpg(thumbnail);

  d.send(sendData);
}

 uploadUserAvatar(String userUID, Isolate isolate) async {
   storageReference =  FirebaseStorage().ref();
   file = await ImagePicker.pickImage(source: ImageSource.gallery);
   final ReceivePort receivePort = ReceivePort();
   isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);

   receivePort.listen((dynamic data) {
     if (data is SendPort) {
       data.send({
         'file': file,
         'with': 600
       });
     } else {
       decodeAndUploadToStorage(data, "/userimages/avatars/$userUID/" + "/" + file.path.split("/").last).then((value) =>
           firestore.collection("users").document(userUID).updateData
             ({
             "photoURL" : value,
           })
       );
     }
   });
 }


Future<String>  decodeAndUploadToStorage (Uint8List data, String path) async {

  final StorageUploadTask uploadTask = storageReference.child(
      path).putData(data);

//  final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask
//      .events.listen((event) {
//    // You can use this to notify yourself or your user in any kind of way.
//    // For example: you could use the uploadTask.events stream in a StreamBuilder instead
//    // to show your user what the current status is. In that case, you would not need to cancel any
//    // subscription as StreamBuilder handles this automatically.
//    // Here, every StorageTaskEvent concerning the upload is printed to the logs.
//    print('EVENT ${event.type}');
//  });
// Cancel your subscription when done.
  await uploadTask.onComplete;
//  streamSubscription.cancel();
//  final String imageURL =  await storageReference.getPath();
  return path;
}


Future<Uri>  uploadFileToStorage (File file, String path ) async {
   final StorageReference storageReference = FirebaseStorage().ref().child(
       path);
   final StorageUploadTask uploadTask = storageReference.putFile(file);

   final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask
       .events.listen((event) {

     // You can use this to notify yourself or your user in any kind of way.
     // For example: you could use the uploadTask.events stream in a StreamBuilder instead
     // to show your user what the current status is. In that case, you would not need to cancel any
     // subscription as StreamBuilder handles this automatically.

     // Here, every StorageTaskEvent concerning the upload is printed to the logs.
     print('EVENT ${event.type}');
   });

// Cancel your subscription when done.

     return await uploadTask.onComplete.then((onValue) {
     streamSubscription.cancel();
     return  onValue.ref.getDownloadURL().then( (onValue) {
       return onValue;
     } );
   } );
 }