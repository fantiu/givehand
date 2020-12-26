import 'package:flutter/widgets.dart';

class Profile {
  String name;
  String avatar;
  String account;

  Profile({
    this.name,
    this.account,
    this.avatar
  });
}

 Profile me = new Profile(
  name: '多多砍',
  avatar:'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=116988972,55295650&fm=11&gp=0.jpg',
  account: 'bangbang123'
);