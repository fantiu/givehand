import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './component/full_with_icon_button.dart';
import '../common/style/style.dart' show ICons,AppColors;

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FullWithIconButton(
            iconPath: 'assets/images/ic_shopping.png',
            title: '购物',
            showDivider: true,
            onPressed: (){},
          ),FullWithIconButton(
            iconPath: 'assets/images/ic_game_entry.png',
            title: '榜单',
            showDivider: false,
            onPressed: (){},
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20.0),
          )
        ],
      ),
    );
  }
}