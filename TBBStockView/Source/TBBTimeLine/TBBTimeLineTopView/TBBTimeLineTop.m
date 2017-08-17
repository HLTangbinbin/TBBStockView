//
//  TBBTimeLine.m
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/5/28.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "TBBTimeLineTop.h"
#import "UIColor+HL.h"
#import "Common.h"
#import "TBBTimeLineTopModel.h"
#import "TBBTimeLineTopPointModel.h"



@interface TBBTimeLineTop ()
@property(nonatomic,assign) CGContextRef context;

@end
@implementation TBBTimeLineTop

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
-(void)drawTimeLineTopWithPositionArray:(NSArray *)pointArray withLineColor:(UIColor *)lineColor andLineWidth:(CGFloat)lineWidth{
    if (pointArray.count <= 0) {
        return;
    };
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;
    [lineColor setStroke];
  
    for (NSInteger i = 0; i < pointArray.count; i++) {
        //当前的点
        TBBTimeLineTopPointModel *positionModel = (TBBTimeLineTopPointModel *)pointArray[i];
        //当前点是否包含X，Y
        if (i == 0) {
            //移动到当前点
            [path moveToPoint:CGPointMake(positionModel.xPosition, positionModel.yPosition)];
            [path1 moveToPoint:CGPointMake(positionModel.xPosition, positionModel.yPosition)];
        }

        if (i+1 < pointArray.count) {
            TBBTimeLineTopPointModel *nextPositionModel = (TBBTimeLineTopPointModel *)pointArray[i+1];
            //绘制分时线条
            [path addLineToPoint:CGPointMake(nextPositionModel.xPosition, nextPositionModel.yPosition)];
            [path1 addLineToPoint:CGPointMake(nextPositionModel.xPosition, nextPositionModel.yPosition)];
            NSLog(@"%f,%f",positionModel.xPosition,positionModel.yPosition);
        }
        
}
    [path stroke];
   //绘制背景
    TBBTimeLineTopPointModel *firstObj = (TBBTimeLineTopPointModel *)pointArray.firstObject;
    TBBTimeLineTopPointModel *lastObj = (TBBTimeLineTopPointModel *)pointArray.lastObject;
    [path1 addLineToPoint:CGPointMake(lastObj.xPosition, kTimeLineTopViewHeight-kHeightMargin)];
    [path1 addLineToPoint:CGPointMake(kWidthMargin, kTimeLineTopViewHeight-kHeightMargin)];
    [path1 addLineToPoint:CGPointMake(kWidthMargin, firstObj.yPosition)];
     [[UIColor colorWithHexString:@"ACD6FF"] setFill];
    [path1 fill];
  
}



@end
