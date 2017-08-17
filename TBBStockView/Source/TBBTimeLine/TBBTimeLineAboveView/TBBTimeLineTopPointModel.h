//
//  TBBTimeLinePointModel.h
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/5/28.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TBBTimeLineTopPointModel : NSObject
@property (nonatomic, assign) CGFloat xPosition;
@property (nonatomic, assign) CGFloat yPosition;
+(TBBTimeLineTopPointModel *)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition;
@end
