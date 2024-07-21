import 'package:flutter/material.dart';


class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 10,),
          OutlinedButton.icon(onPressed: () {}, icon: Icon(Icons.image), label: Text("Add pcture"),),
          SizedBox(height: 80,),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
            label: Text("닫기"),
          )
        ],
      ),
    );
  }
}
