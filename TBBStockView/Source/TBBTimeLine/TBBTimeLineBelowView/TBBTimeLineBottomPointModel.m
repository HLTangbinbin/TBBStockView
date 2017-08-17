//
//  TBBTimeLineBottomPointModel.m
//  TBBStockView
//
//  Created by 唐彬彬 on 2017/8/7.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "TBBTimeLineBottomPointModel.h"

@implementation TBBTimeLineBottomPointModel
+(TBBTimeLineBottomPointModel *)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition {
    TBBTimeLineBottomPointModel *model = [[TBBTimeLineBottomPointModel alloc] init];
    model.xPosition = xPositon;
    model.yPosition = yPosition;
    return model;
}
@end
