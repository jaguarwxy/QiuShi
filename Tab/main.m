//
//  main.m
//  Tab
//
//  Created by zouxue on 15/7/26.
//  Copyright (c) 2015年 xiyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
//视频引起的崩溃纪录：
//1instrument zombie工具下完全正常， 将player文件放到别的小工程demo下也正常，在本项目下经常崩溃
//2时好时坏，崩溃跟正常播放是隔天出现，且都是在改动项目代码后会转换。
//3异常断点不起作用，register read 提示：
//General Purpose Registers:
//ebx = 0x02fe2860  "class"
//是否可能是autorelease引起的？？？？

