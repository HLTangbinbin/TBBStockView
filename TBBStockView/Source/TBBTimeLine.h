//
//  TBBTimeLine.h
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/5/28.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//  绘制分时线与背景的类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TBBTimeLine : NSObject
/**曲线点位置数据数组*/
@property(nonatomic,strong) NSArray *positionArr;

@property(nonatomic,strong) CAShapeLayer *lineLayer;

-(instancetype)initWithContext:(CGContextRef)context;
-(void)drawTimeLineWithPositionArray:(NSArray *)pointArray withLineColor:(UIColor *)lineColor andLineWidth:(CGFloat)lineWidth;
@end
