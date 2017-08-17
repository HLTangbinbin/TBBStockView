//
//  TBBTimeLinePointModel.m
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/5/28.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "TBBTimeLineTopPointModel.h"
@implementation TBBTimeLineTopPointModel
+(TBBTimeLineTopPointModel *)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition {
    TBBTimeLineTopPointModel *model = [[TBBTimeLineTopPointModel alloc] init];
    model.xPosition = xPositon;
    model.yPosition = yPosition;
    return model;
}
@end
