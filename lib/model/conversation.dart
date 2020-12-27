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
    /*new Conversation(
      avatar: 'assets/images/ic_wx_games.png',
      title: '会话标题',
      titleColor: 0xff586b95,
      des: '最新一条消息',
      updateAt: '17:12',
      groupId: 000001,
      userId:"000100",
      type: 1
    ),*/
];
}