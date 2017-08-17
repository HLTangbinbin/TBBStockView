//
//  TBBTimeLineBottomPointModel.h
//  TBBStockView
//
//  Created by 唐彬彬 on 2017/8/7.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TBBTimeLineBottomPointModel : NSObject
@property (nonatomic, assign) CGFloat xPosition;
@property (nonatomic, assign) CGFloat yPosition;
+(TBBTimeLineBottomPointModel *)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition;
@end
