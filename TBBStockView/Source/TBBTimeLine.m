//
//  TBBTimeLine.m
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/5/28.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "TBBTimeLine.h"
#import "TBBTimeLineModel.h"
#import "UIColor+HL.h"
#import "TBBTimeLinePointModel.h"

#define kWidthMargin 10
#define kHeightMargin 20
#define kTimeLineAboveViewHeight 200.f

@interface TBBTimeLine ()
@property(nonatomic,assign) CGContextRef context;

@end
@implementation TBBTimeLine

-(instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

/**
 获取点坐标数组进行绘制

 @param pointArray 点坐标数组
 @param lineColor 线的颜色
 @param lineWidth 线宽
 */
-(void)drawTimeLineWithPositionArray:(NSArray *)pointArray withLineColor:(UIColor *)lineColor andLineWidth:(CGFloat)lineWidth{
    if (pointArray == nil) {
        return;
    };
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;
    [[UIColor colorWithHexString:@"1860FE"] setStroke];
  
    for (NSInteger i = 0; i < pointArray.count; i++) {
        //当前的点
        TBBTimeLinePointModel *positionModel = (TBBTimeLinePointModel *)pointArray[i];
        //当前点是否包含X，Y
        if (i == 0) {
            //移动到当前点
            [path moveToPoint:CGPointMake(positionModel.xPosition, positionModel.yPosition)];
            [path1 moveToPoint:CGPointMake(positionModel.xPosition, positionModel.yPosition)];
        }

        if (i+1 < pointArray.count) {
            TBBTimeLinePointModel *nextPositionModel = (TBBTimeLinePointModel *)pointArray[i+1];
            //绘制分时线条
            [path addLineToPoint:CGPointMake(nextPositionModel.xPosition, nextPositionModel.yPosition)];
            [path1 addLineToPoint:CGPointMake(nextPositionModel.xPosition, nextPositionModel.yPosition)];
            NSLog(@"%f,%f",positionModel.xPosition,positionModel.yPosition);
        }
        
}
    [path stroke];
   //绘制背景
    TBBTimeLinePointModel *firstObj = (TBBTimeLinePointModel *)pointArray.firstObject;
    TBBTimeLinePointModel *lastObj = (TBBTimeLinePointModel *)pointArray.lastObject;
    [path1 addLineToPoint:CGPointMake(lastObj.xPosition, kTimeLineAboveViewHeight-kHeightMargin)];
    [path1 addLineToPoint:CGPointMake(kWidthMargin, kTimeLineAboveViewHeight-kHeightMargin)];
    [path1 addLineToPoint:CGPointMake(kWidthMargin, firstObj.yPosition)];
     [[UIColor colorWithHexString:@"ACD6FF"] setFill];
    [path1 fill];
  
}



@end
