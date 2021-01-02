import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import './message_page/conversation_item.dart';
import '../model/conversation.dart';
import '../provide/websocket.dart';

class MessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provide<WebSocketProvide>(
      builder: (context,child,val){
        //var messageList = Provide.value<WebSocketProvide>(context).messageList;
        var length = Conversation.mockConversations.length;// + messageList.length;
        return Container(
          child: ListView.builder(
            itemBuilder:  (BuildContext context, int index){
              if (index < Conversation.mockConversations.length){
                return ConversationItem(Conversation.mockConversations[index],index,0);
              }/*else {
                var extraIndex = index - Conversation.mockConversations.length;
                return ConversationItem(messageList[extraIndex],extraIndex,0);
              }*/
            },
            itemCount: length ,
          )
        );
      }
    );
  }
}