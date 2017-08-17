//
//  TBBTimeLineBottom.m
//  TBBStockView
//
//  Created by 唐彬彬 on 2017/8/7.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "TBBTimeLineBottom.h"
#import <UIKit/UIKit.h>
#import "UIColor+HL.h"
#import "Common.h"
#import "TBBTimeLineBottomPointModel.h"
#import "TBBTimeLineTopPointModel.h"
@interface TBBTimeLineBottom()
@property(nonatomic,assign) CGContextRef context;
@property(nonatomic,strong) UIColor *color;//矩形框颜色
@end

@implementation TBBTimeLineBottom
-(instancetype)initWithContext:(CGContextRef)context {

    if (self = [super init]) {
        self.context = context;
    }
    return self;
}

-(void)drawTimeLineBottomWithPositionArray:(NSArray *)pointArray withLineColorArray:(NSArray *)colorArray andLineWidth:(CGFloat)lineWidth {

    if (pointArray.count <= 0) {
        return;
    };
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = lineWidth;
    CGFloat maxY = kTimeLineBottomViewHeight-kHeightMargin;
    for (NSInteger i = 0; i < pointArray.count; i++) {
        //当前的点x
        TBBTimeLineBottomPointModel *positionModel = (TBBTimeLineBottomPointModel *)pointArray[i];
        self.color = colorArray[i];
        [self.color setStroke];
        //绘制分时线条
        CGPoint startPoint = CGPointMake(positionModel.xPosition, maxY);
        CGPoint endPoint = CGPointMake(positionModel.xPosition, positionModel.yPosition);
        NSLog(@"statrPointX--%.2f---statrPointY--%.2f",startPoint.x,startPoint.y);
        NSLog(@"endPointX--%.2f---endPointY--%.2f",endPoint.x,endPoint.y);
        //画实体线
        const CGPoint solidPoints[] = {startPoint,endPoint};
        CGContextStrokeLineSegments(self.context, solidPoints, 2);

    }
    
    [path stroke];

}
@end
