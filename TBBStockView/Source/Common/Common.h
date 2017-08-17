//
//  Common.h
//  美丽说DIY
//
//  Created by 唐彬彬 on 17/5/21.
//  Copyright (c) 2017年 tbb. All rights reserved.
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


//2.颜色
#define kColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kColor(r,g,b) kColorAlpha(r,g,b,1)

#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/155.0 green:arc4random_uniform(255)/155.0 blue:arc4random_uniform(255)/155.0 alpha:0.7]

//3.设置弱引用 __weak
#define WEAKINSTANCE(weakInstance,instance) __weak typeof(instance) weakInstance = instance;
#define WS(weakSelf) WEAKINSTANCE(weakSelf,self)

//4.设置绘制矩形上下文相关参数

/**
 *  背景框的宽度
 */
static const float HYStockChartTimeLineGridWidth = 0.5;
/**
 *  TimeLineTopView的高度
 */
#define kTimeLineTopViewHeight 240.f
/**
 *  TimeLineBottomView的高度
 */
#define kTimeLineBottomViewHeight ((kTimeLineTopViewHeight-2*kHeightMargin)/2+kHeightMargin)
/**
 绘制矩形框范围与view横向间距
 */
#define kWidthMargin 10
/**
 绘制矩形框范围与view纵向间距
 */
#define kHeightMargin 20

#define kViewHeight self.frame.size.height
#define kViewWidth self.frame.size.width

/**
 绘制矩形框宽度
 */
#define kRectWidth (kViewWidth-2*kWidthMargin)
/**
 绘制矩形框高度
 */
#define kRectHeight (kViewHeight-2*kHeightMargin)
/**
 横坐标文字上下文范围
 */
#define kHorizontalTextRect CGRectMake(kWidthMargin,kRectHeight+kHeightMargin,kRectWidth, kHeightMargin)
/**
 纵坐标文字上下文范围TOP
 */
#define kVerticalTextTopRect CGRectMake(kWidthMargin,kHeightMargin,100.f, kRectHeight)
/**
 纵坐标文字上下文范围Center
 */
#define kVerticalTextCenterRect CGRectMake(kWidthMargin,kViewHeight/2-strSize.height/2,100.f, kRectHeight)
/**
 纵坐标文字上下文范围Bottom
 */
#define kVerticalTextTopBottomRect CGRectMake(kWidthMargin,kRectHeight+kHeightMargin-strSize.height,100.f, kRectHeight)

#define kSlideWidth 40.f  //滑块宽度
#define kSlideHeigth 20.f  //滑块高度
