//
//  TBBTimeLineBottom.h
//  TBBStockView
//
//  Created by 唐彬彬 on 2017/8/7.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TBBTimeLineBottom : NSObject
/**曲线点位置数据数组*/
@property(nonatomic,strong) NSArray *positionArr;

@property(nonatomic,strong) CAShapeLayer *lineLayer;

-(instancetype)initWithContext:(CGContextRef)context;
-(void)drawTimeLineBottomWithPositionArray:(NSArray *)pointArray withLineColorArray:(NSArray *)colorArray andLineWidth:(CGFloat)lineWidth;
@end
