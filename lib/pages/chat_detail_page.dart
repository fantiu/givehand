import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/websocket.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/style/style.dart';
import './chat_detail/chat_content_view.dart';
import '../model/conversation.dart';


class ChatDetailPage extends StatefulWidget {
  int type;
  int index;
  ChatDetailPage(this.index,this.type);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState(type,index);
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  ScrollController _scrollController;
  bool hasText = false;
  int type;
  int index;
  Conversation data;
  _ChatDetailPageState(this.type,this.index);
  var messageList = [
    {'type':0,'text':'hello',},
    {'type':1,'text':'hello',},
  ];
  
  final controller = TextEditingController();
  void _handleSubmitted(String text) {
      if (controller.text.length > 0) {
        print('发送${text}');
        if(type == 1){
          Provide.value<WebSocketProvide>(context).sendMessage(2,text,index);
        }
        setState(() {
          hasText = false;
          messageList.add({'type':1,'text':text,});
        });
        controller.clear(); //清空输入框
        _jumpBottom();
      }
  }
  void _jumpBottom(){//滚动到底部
    _scrollController.animateTo(99999,curve: Curves.easeOut, duration: Duration(milliseconds: 200));
  }
  @override
  void initState(){
    super.initState();
    _scrollController = new ScrollController();
    // _jumpBottom();
  }
  @override
  Widget build(BuildContext context) {
    if(type ==1){
      data = Provide.value<WebSocketProvide>(context).messageList[index];
      print("message index: $index");
    }else{
      data = Conversation.mockConversations[index];
      print("group index: $index");
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: Text(data.title + "(555)",style: TextStyle(fontSize: ScreenUtil().setSp(30.0),color: Color(AppColors.APPBarTextColor),),),
        iconTheme: IconThemeData(
          color: Color(AppColors.APPBarTextColor)
        ),
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Color(AppColors.PrimaryColor),

      ),
      body: Container(
        color: Color(AppColors.ChatDetailBg),
        child: Column(
          children: <Widget>[
            Provide<WebSocketProvide>(
              builder: (context,child,val){
                List<Map<String, Object>>list = [];
                if(type == 1){
                  print('llllll');
                  messageList = [];
                  var historyMessage = Provide.value<WebSocketProvide>(context).historyMessage;
                  for(var i = 0; i< historyMessage.length; i++){
                    if(data.userId != null){
                      if(historyMessage[i]['bridge'].contains(data.userId)){
                        if(historyMessage[i]['uid'] == data.userId){
                          list.add({'type':0,'text':historyMessage[i]['msg'],'nickname':historyMessage[i]['nickname']});
                        }else{
                          list.add({'type':1,'text':historyMessage[i]['msg'],'nickname':historyMessage[i]['nickname']});
                        }
                      }
                    }else if(data.groupId != null && data.groupId == historyMessage[i]['groupId'] && historyMessage[i]['bridge'].length==0){
                      var uid = Provide.value<WebSocketProvide>(context).uid;
                      if(historyMessage[i]['uid'] != uid ){
                        list.add({'type':0,'text':historyMessage[i]['msg'],'nickname':historyMessage[i]['nickname']});
                      }else{
                        list.add({'type':1,'text':historyMessage[i]['msg'],'nickname':historyMessage[i]['nickname']});
                      }
                    }
                  }
                }
                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                    if(type == 1){
                      return ChatContentView(type:list[index]['type'],text:list[index]['text'],avatar:list[index]['type'] == 0 ? data.avatar: '',isNetwork: list[index]['type'] == 0 ? data.isAvatarFromNet() : false,username:list[index]['nickname'],userType:data.type);
                    }else{
                      return ChatContentView(type:messageList[index]['type'],text:messageList[index]['text'],avatar:messageList[index]['type'] == 0 ? data.avatar: '',isNetwork: messageList[index]['type'] == 0 ? data.isAvatarFromNet() : false,username:data.title,userType:data.type);
                    }
                  },
                  itemCount:type == 1 ? list.length : messageList.length ,
                  )
                );
            }),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(2.0), bottom:ScreenUtil().setHeight(28.0),left: 16,right: 8),
              color: Color(0xFFF7F7F7),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(15.0), bottom: ScreenUtil().setHeight(15.0)),
                    height: ScreenUtil().setHeight(60.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration.collapsed(hintText: null),
                      maxLines: 1,
                      autocorrect: true,
                      autofocus: false,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.green,
                      onChanged: (text) {
                        setState(() {
                            hasText = text.length > 0 ?  true : false; 
                        });
                        // print('change=================== $text');
                      },
                      onSubmitted:_handleSubmitted,
                      enabled: true, //是否禁用
                    ),
                  )),
                  Container(
                    width: ScreenUtil().setWidth(60.0),
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(20.0)),
                    child:  IconButton(
                      icon: Icon(Icons.send), //发送按钮图标
                      onPressed: () {
                        if(!hasText){
                          print('无输入');
                        }else{
                          _handleSubmitted(controller.text);
                        }
                      } 
                    ), 
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
