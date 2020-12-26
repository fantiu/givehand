import '../common/style/style.dart';

class Conversation {
  String avatar;
  String title;
  int titleColor;
  String des;
  String updateAt;
  bool isMute;
  int unreadMsgCount;
  bool displayDot;
  int groupId;
  String userId;
  int type;
  
  bool isAvatarFromNet() {
    if(this.avatar.indexOf('http') == 0 || this.avatar.indexOf('https') == 0) {
      return true;
    }
    return false;
  }

  Conversation({
    this.avatar,
    this.title,
    this.titleColor : AppColors.TitleColor,
    this.des,
    this.updateAt,
    this.isMute : false,
    this.unreadMsgCount : 0,
    this.displayDot : false,
    this.groupId,
    this.userId,
    this.type
  }) :  assert(avatar != null),
        assert(title != null),
        assert(updateAt != null);
        
static  List<Conversation> mockConversations  = [
    new Conversation(
      avatar: 'assets/images/ic_wx_games.png',
      title: '拼多多',
      titleColor: 0xff586b95,
      des: '请帮忙砍一刀',
      updateAt: '17:12',
      groupId: 000001,
      userId:"000000",
      type: 1
    ),
    new Conversation(
      avatar: 'assets/images/ic_group_chat.png',
      title: '携程',
      titleColor: 0xff586b95,
      des: '请帮忙助力抢火车票',
      updateAt: '18:32',
      groupId: 000002,
      userId:"000000",
      type: 1
    ),
    new Conversation(
      avatar: 'assets/images/ic_fengchao.png',
      title: '微信投票',
      titleColor: 0xff586b95,
      des: '帮忙点下链接，投票给66号张子涵，谢谢大家',
      updateAt: '19:33',
      groupId: 000003,
      userId:"000000",
      type: 1
    ),
    new Conversation(
      avatar: 'assets/images/ic_fengchao.png',
      title: '其他',
      titleColor: 0xff586b95,
      des: '微博粉、抖音赞、订单好评等',
      updateAt: '20:51',
      groupId: 000004,
      userId:"000000",
      type: 1
    ),
];
}