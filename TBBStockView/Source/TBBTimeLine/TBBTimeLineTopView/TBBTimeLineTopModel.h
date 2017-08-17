//
//  TBBTimeLineModel.h
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/5/28.
//  assignright © 2017年 唐彬彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//分时图模型
@interface TBBTimeLineTopModel : NSObject
@property (nonatomic, copy)    NSString *data_time_stamp;
@property (nonatomic, copy)    NSString *currtTime;
@property (nonatomic, assign)  CGFloat  preClosePx;
@property (nonatomic, assign)  CGFloat  avgPirce;
@property (nonatomic, assign)  CGFloat  lastPirce;
@property (nonatomic, assign)  CGFloat  totalVolume;
@property (nonatomic, assign)  CGFloat  volume;
@property (nonatomic, assign)  CGFloat  trade;
@property (nonatomic, copy)    NSString *rate;

@end
