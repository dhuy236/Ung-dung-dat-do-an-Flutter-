import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/location_controller.dart';
import 'package:my_app/pages/address/add_address_page.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/big_text.dart';
import 'package:my_app/widgets/icon_and_text_widget.dart';
import 'package:my_app/widgets/small_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  final String address1;
  final String address2;
  
  const AppColumn({super.key, 
  required this.text,
  required this.address1,
  required this.address2,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: text, size: Dimensions.font26,),
                        SizedBox(height: Dimensions.height10),
                        Row(
                          children: [
                            Wrap(
                              children: List.generate(5, (index)  {return Icon(Icons.star, color:Color.fromARGB(255, 228, 232, 2), size: 13,);}),
                            ),
                            SizedBox(width: 10,),
                            SmallText(text: "4.5"),
                            SizedBox(width: 10,),
                            SmallText(text: "1287"),
                            SizedBox(width: 10,),
                            SmallText(text: "Lượt đánh giá")
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconAndTextWidget(icon: Icons.circle_sharp,
                                text: "Seller",
                                iconcolor: Color.fromARGB(255, 223, 178, 105)),
                            // IconAndTextWidget(icon: Icons.location_on,
                            //     text: "1.7km",
                            //     iconcolor: Color.fromARGB(255, 105, 213, 223)),
                              FutureBuilder<double>(
                                            future: calculateDistance(
                                                address1,
                                                address2 ??
                                                    address1),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                // Trạng thái đang chờ đợi
                                                return IconAndTextWidget(
                                                  icon: Icons.location_on,
                                                  text: "Loading...",
                                                  iconcolor: Color.fromARGB(
                                                      255, 105, 213, 223),
                                                );
                                              } else if (snapshot.hasError) {
                                                // Xử lý khi có lỗi
                                                return IconAndTextWidget(
                                                  icon: Icons.error,
                                                  text: "error...",
                                                  iconcolor: Colors.red,
                                                );
                                              } else {
                                                // Hiển thị giá trị khoảng cách tính toán
                                                return IconAndTextWidget(
                                                  icon: Icons.location_on,
                                                  text: "${snapshot.data} km",
                                                  iconcolor: Color.fromARGB(
                                                      255, 105, 213, 223),
                                                );
                                              }
                                            },
                                          ),
                            IconAndTextWidget(icon: Icons.access_time_rounded,
                                text: "32min",
                                iconcolor: Color.fromARGB(255, 215, 45, 23)),
                          ],
                        ),
                      ],
                    );
  }
}