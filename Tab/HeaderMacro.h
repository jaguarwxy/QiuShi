//
//  HeaderMacro.h
//  Tab
//
//  Created by zouxue on 15/9/12.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#ifndef Tab_HeaderMacro_h
#define Tab_HeaderMacro_h


#endif
//192.168.0.102
//个人详细资料的图片请求
//http://cover.qiushibaike.com/FnlW89zFiQhJTymslXWS44qI08Fv?imageView2/2/w/8
//http://cover.qiushibaike.com/FnlW89zFiQhJTymslXWS44qI08Fv?imageView2/2/w/500/q/80
//个人资料请求
//http://nearby.qiushibaike.com/user/27497116/detail
//视频列表
//http://m2.qiushibaike.com/article/list/video?count=30&page=1
//一个视频
//http://qiubai-video.qiushibaike.com/7I9LF85U2UQ9XH99.mp4
//最新
//http://m2.qiushibaike.com/article/list/latest?count=30&page=1//////后面这些没用的&AdID=144127855968357777DE21


//用户头像请求
//http://pic.qiushibaike.com/system/avtnew/1628/16284333/medium/20140611094145.jpg   16284333是id，第一个参数是id截断4位  最后是图片名，在返回数据里有,icon字段
//糗事图片请求
//http://pic.qiushibaike.com/system/pictures/11249/112499734/medium/app112499734.jpg  参数1是图片名称的数字段前4位，参数2是全名，参数3是返回的数据中有的，image字段
//他的糗事  请求
//http://m2.qiushibaike.com/user/22954709/articles?count=30&page=1&AdID=144127763854517777DE21
#define  HisQiuShiURLString(userID,count,page)  [NSString stringWithFormat:@"http://m2.qiushibaike.com/user/%@/articles?count=%d&page=%d",userID,count,page]
//http://m2.qiushibaike.com/user/22954709/articles?count=30&page=1
//用户头像
#define userPortritURLString(path1,path2,path3) [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@",path1,path2,path3]
//内容图片
#define contentPicturURLString(path1,path2,path3) [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/pictures/%@/%@/medium/%@",path1,path2,path3]


//用户资料
#define UserDetailInforURLString(userID) [NSString stringWithFormat:@"http://nearby.qiushibaike.com/user/%@/detail",userID]
//详情及评论页面
#define detailURLSring(qiuShiID,count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/%@/comments?count=%d&page=%d",qiuShiID,count,page]
//视频
#define VideoURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/video?count=%d&page=%d",count,page]
//http://m2.qiushibaike.com/article/112499734/comments?count=50&page=1

#define LastestURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/latest?count=%d&page=%d",count,page]
//精华
#define BestURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/day?count=%d&page=%d",count,page]
//纯文
#define PureTextURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/text?count=%d&page=%d",count,page]
//http://m2.qiushibaike.com/article/list/text?count=30&page=1&readarticles=%5B112703616%2C112523783%2C112521068%5D&AdID=144127719882017777DE21纯文
//纯图
#define PurePicURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/imgrank?count=%d&page=%d",count,page]
//zhu专享
//http://m2.qiushibaike.com/mainpage/list?type=refresh&readarticles=%5B112845742%5D&count=30&page=1&longitude=120.0643&latitude=30.28213&AdID=144202587124777777DE21

#define ImageURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/images?count=%d&page=%d",count,page]
#define SuggestURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/suggest?count=%d&page=%d",count,page]

#define WeakURlString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/week?count=%d&page=%d",count,page]
#define MonthURLString(count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/month?count=%d&page=%d",count,page]
#define CommentsURLString(ID) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/%@/comments?count=500&page=1",ID]

#define ClearRequest(request) if(request!=nil){[request clearDelegatesAndCancel];[request release];request=nil;}

#define LoginURLString(userName,passWord) [NSString stringWithFormat:@"m2.qiushibaike.com/user/signin?loginName=%@&password=%@",userName,passWord]
//http://m2.qiushibaike.com/config  http://m2.qiushibaike.com/mainpage/check?AdID=144202559295897777DE21   http://bitmap.qiushibaike.com/bitmap/9747043/get?AdID=144202559222957777DE21

#define NeedLoginTips @"您还未登录"
#define PageNumberOf_LatestQiuShi 1001;
#define PageNumberOf_BestQiushi 1002;
#define PageNumberOf_PureTextQiuShi 1003;
#define PageNumberOf_purePictureQiuShi 1004;
#define PageNumberOf_VideoQiuShi   1005;
#define PageNumberOf_BaseQiuShiContainer 1000;
#define PageNumberOf_CommentView 1015;
#define PageNumberOf_UserInforView 4001;
#define PageNumberOf_TalkView 3001;
#define PageNumberOf_DiscoverView 2001;





