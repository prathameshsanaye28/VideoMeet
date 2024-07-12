import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if(_file != null){
    return await _file.readAsBytes();
  }
  print('No image selected');
  
}

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content))
  );
}

Widget userprofile(String mainText,String hintText, BuildContext context){
  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width*0.8,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        const Color.fromRGBO(224, 224, 224, 1),
        const Color.fromRGBO(255, 224, 130, 1),
        const Color.fromRGBO(255, 183, 77, 1),
        
      ]),
      border: Border(bottom: BorderSide(color: Color.fromRGBO(16, 85, 153, 1))),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(hintText+":",style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),),
          Text(mainText, style: TextStyle(fontSize: 41,color:Colors.black, fontWeight: FontWeight.bold),),
        ],),
      ),
    ),
  );
}