import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/currentIndex.dart';
import './message_page.dart';
import './discover_page.dart';
import './mine_page.dart';
import '../common/style/style.dart' show ICons,AppColors;

class IndexPage extends StatelessWidget {
  _buildPopupMenuItem(Widget icon, String title){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 12),
          child: icon,
        ),
        Text(title,style: TextStyle(color: Color(AppColors.AppBarPopupMenuTextColor)),)
      ],
    );
  }

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      // icon: Icon(CupertinoIcons.home),
      icon: new Icon(ICons.MESSAGE),
      // ignore: deprecated_member_use
      title: Text('帮帮',style: TextStyle(fontSize: 14.0)),
      activeIcon: new Icon(ICons.MESSAGE_ACTIVE)
    ),
    BottomNavigationBarItem(
      icon: new Icon(ICons.DISCOVER),
      title: Text('发现',style: TextStyle(fontSize: 14.0)),
      activeIcon: new Icon(ICons.DISCOVER_ACTIVE)
    ),
    BottomNavigationBarItem(
      icon: new Icon(ICons.MINE),
      title: Text('我',style: TextStyle(fontSize: 14.0)),
      activeIcon: new Icon(ICons.MINE_ACTIVE)
    )
  ];

  final List<Widget> tabBodies = [
    MessagePage(),
    DiscoverPage(),
    MinePage()
  ];

  
  /// 单击提示退出
  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
      content: new Text('确定要退出应用?'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text('取消', style: TextStyle(color: Colors.black54))),
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: new Text('确定', style: TextStyle(color: Colors.black54)))
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: Provide.value<CurrentIndexProvide>(context).currentIndex);

    ScreenUtil.instance = ScreenUtil(width: 750,height:1334)..init(context);//初始化屏幕分辨率
    return Provide<CurrentIndexProvide>(
      builder: (context,child,val){
        int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text('帮帮',style: TextStyle(fontSize: ScreenUtil().setSp(30.0),color: Color(AppColors.APPBarTextColor),),),
              elevation: 0.0,
              brightness: Brightness.light,
              backgroundColor: Color(AppColors.PrimaryColor),
            ),
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              fixedColor: Color(AppColors.TabIconActive),
              items: bottomTabs,
              onTap: (index){
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
                _pageController.animateToPage(index,duration: Duration(milliseconds: 10),curve: Curves.easeInOut);
              },
            ),
            body: PageView.builder(
              itemBuilder: (BuildContext context, int index){
                return tabBodies[index];
              },
              controller: _pageController,
              itemCount: tabBodies.length,
              onPageChanged: (int index){
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
              },
            ),
          ),
          onWillPop: (){
            return _dialogExitApp(context);
          },
        );
      },
    );
  }
}