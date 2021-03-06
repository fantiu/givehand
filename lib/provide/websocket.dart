import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../model/conversation.dart';
class WebSocketProvide with ChangeNotifier{
  var uid = '';
  var nickname = '';
  var users = [];
  var groups =[];
  var historyMessage = [];//接收到哦的所有的历史消息
  var messageList = [];
  var currentMessageList = [];//选择进入详情页的消息历史记录
  var connecting = false;//websocket连接状态
  IOWebSocketChannel channel;

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userInfo = prefs.getString('userInfo');
    print("websocket init: $userInfo");
    if(userInfo == null){//弹出设置用户名
      var now = new DateTime.now();
      /*
      print(now.millisecondsSinceEpoch);//单位毫秒，13位时间戳
      print(now.microsecondsSinceEpoch);//单位微秒,16位时间戳
      */
      uid = "c_${now.microsecondsSinceEpoch}";
      nickname = "c_${Random().nextInt(100)}";
      var userInfoData = {
        "uid" : uid,
        "nickname" : nickname
      };
      var userInfoStr =  json.encode(userInfoData).toString();
      prefs.setString('userInfo', userInfoStr);
    }else{
      var userInfoData = json.decode(userInfo.toString());
      uid = userInfoData['uid'];
      nickname = userInfoData['nickname'];
    }
    return await createWebsocket(uid);
    // monitorMessage();
  }
  createWebsocket(uid) async {//创建连接并且发送鉴别身份信息
    channel = await new IOWebSocketChannel.connect('ws://swmabby.cn:8090/socketServer/'+uid);
    var obj = {
      "uid": uid,
      "type": 1,
      "nickname": nickname,
      "msg": "",
      "bridge": [],
      "groupId": ""
    };
    String text = json.encode(obj).toString();
    channel.sink.add(text);
    //监听到服务器返回消息
    channel.stream.listen((data) => listenMessage(data),onError: onError,onDone: onDone);
  }
    
  listenMessage(data){
    connecting = true;
    var obj = jsonDecode(data);
    print("websocket listen message: $data");
    historyMessage.add(obj);
    // messageList.add(obj);

    /*if(obj['type'] == 1){ // 获取聊天室的人员与群列表
      messageList = [];
      print("websocket listen message type1: $obj['msg']");
      users = obj['users'];
      groups = obj['groups'];
      for(var i = 0; i < groups.length; i++){
        messageList.add(new Conversation(
          avatar: 'assets/images/ic_group_chat.png',
          title: groups[i]['name'],
          des: '点击进入聊天ing',
          updateAt: obj['date'].substring(11,16),
          unreadMsgCount: 0,
          displayDot: false,
          groupId: groups[i]['id'],
          type: 2
        ));
      }
    }else if (obj['type'] == 2){//接收到消息
      historyMessage.add(obj);
      print("websocket listen message type2 history message: $historyMessage");
      for(var i = 0; i < messageList.length; i++){
        if(messageList[i].userId != null){
          var count = 0;
          for(var r = 0; r < historyMessage.length; r++){
            if(historyMessage[r]['status']==1 &&  historyMessage[r]['bridge'].contains(messageList[i].userId) && historyMessage[r]['uid'] != uid){
              count++;
            }
          }
          if(count > 0){
            messageList[i].displayDot = true;
            messageList[i].unreadMsgCount = count;
          }
        }
        if(messageList[i].groupId != null){
          var count = 0;
          for(var r = 0; r < historyMessage.length; r++){
            if(historyMessage[r]['status']==1 &&  historyMessage[r]['groupId']==messageList[i].groupId && historyMessage[r]['uid'] != uid){
              count++;
            }
          }
          if(count > 0){
            messageList[i].displayDot = true;
            messageList[i].unreadMsgCount = count;
          }
        }
      }
    }*/
    notifyListeners();
  }
  sendMessage(type,data,index){//发送消息
    /*print("websocket send message: userid: ${messageList[index].userId} , group id ${messageList[index].groupId}");
    var _bridge = [];
    if(messageList[index].userId != null){
      _bridge..add(messageList[index].userId)..add(uid);
    }
    int _groupId;
    if(messageList[index].groupId != null){
      _groupId = messageList[index].groupId;
    }*/
    // print(_bridge);
    var obj = {
      "uid": uid,
      "type": 2,
      "nickname": nickname,
      "msg": data,
      //"bridge": _bridge ,
      "groupId": 000001
    };
    String text = json.encode(obj).toString();
    // print(text);
    channel.sink.add(text);
  }
  onError(error){
    print('error------------>${error}');
  }

  void onDone() {
    print('websocket断开了');
    createWebsocket(uid);
    print('websocket重连');
  }

  closeWebSocket(){//关闭链接
    channel.sink.close();
    print('关闭了websocket');
    notifyListeners();
  }
}