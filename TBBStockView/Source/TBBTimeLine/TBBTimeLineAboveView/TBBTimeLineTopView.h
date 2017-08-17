//
//  HLLineChartView.h
//  CAShapeLayer
//
//  Created by 唐彬彬 on 16/5/29.
//  Copyright © 2016年 唐彬彬. All rights reserved.
//  分时图上面的view

#import <UIKit/UIKit.h>

@interface TBBTimeLineTopView : UIView
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *colorArray; //颜色数组
@property (nonatomic, strong) NSArray *pointArray;
-(instancetype)initWithFrame:(CGRect)frame;
-(NSArray *)caculatePosition;
@end
