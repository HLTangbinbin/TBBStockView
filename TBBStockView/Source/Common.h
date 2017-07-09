//
//  Common.h
//  美丽说DIY
//
//  Created by 唐彬彬 on 15/5/21.
//  Copyright (c) 2015年 tbb. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import "CommonNotifications.h"
//#import "HLThirdPlatFormConfig.h"


// 1.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)
#endif
#ifdef DEBUG

#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif


//iPhone6的屏幕宽度(点)---以iPhone6的屏幕为基准进行适配
static const float kiPhone6Width          = 375.f;
//iPhone6的屏幕宽度(点)---以iPhone6的屏幕为基准进行适配
#define kCurrentPhoneWidth   ([UIScreen mainScreen].bounds.size.width)
#define kCurrentPhoneHeight  ([UIScreen mainScreen].bounds.size.height)


/**
 *  以iPhone6的屏幕宽度计算伸缩比例，例如6P的伸缩比例是 414/375 = 1.104
 *  如果小于1，就是iPhone4或者5的屏幕
 */
#define kZoomFromiPhone6 [UIScreen mainScreen].bounds.size.width/kiPhone6Width

//2.颜色
#define kColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kColor(r,g,b) kColorAlpha(r,g,b,1)

#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/155.0 green:arc4random_uniform(255)/155.0 blue:arc4random_uniform(255)/155.0 alpha:0.7]



//3.设置弱引用 __weak
#define WEAKINSTANCE(weakInstance,instance) __weak typeof(instance) weakInstance = instance;
#define WS(weakSelf) WEAKINSTANCE(weakSelf,self)




