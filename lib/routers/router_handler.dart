import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/chat_detail_page.dart';

Handler chatDetailHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    final index = params['index'].first;
    final type = params['type'].first;
    print('message>detail group index is ${index}, type is $type');
    final groupIndex = int.parse(index);
    final groupType = int.parse(type);
    return ChatDetailPage(groupIndex,groupType);
  }
);