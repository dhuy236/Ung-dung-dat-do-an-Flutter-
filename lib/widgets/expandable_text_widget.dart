import 'package:flutter/material.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/small_text.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({super.key, required this.text});

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firtsHaft;
  late String seconHaft;

  bool hiddenText=true;

  double textHeight = Dimensions.screenHeight/5.63;

  @override
  void initState(){
    super.initState();
    if(widget.text.length>textHeight){
      firtsHaft = widget.text.substring(0, textHeight.toInt());
      seconHaft = widget.text.substring(textHeight.toInt()+1,widget.text.length );
    }else{
      firtsHaft=widget.text;
      seconHaft="";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: seconHaft.isEmpty?SmallText(size:Dimensions.font16,text: firtsHaft):Column(
        children: [
          SmallText(height: 1.8,color:const Color.fromARGB(255, 69, 68, 68) ,size:Dimensions.font16, text: hiddenText?(firtsHaft+"..."):(firtsHaft+seconHaft)),
          InkWell(
            onTap: (){
              setState(() {
                hiddenText=!hiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(text: "xem thêm", color: Color.fromARGB(255, 62, 155, 249),),              
                Icon(hiddenText?Icons.arrow_drop_down:Icons.arrow_drop_up, color: Color.fromARGB(255, 82, 168, 255),)             ],
            ),
          )
        ],
      ),
    );
  }
}