//
//  TimeLineView.m
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/7/2.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//  分时图整个view

#import "Common.h"
#import "TBBTimeLineView.h"
#import "TBBTimeLineTopView.h"
#import "TBBTimeLineTopPointModel.h"
#import "TBBTimeLineTopView.h"
#import "TBBTimeLineTopTouchView.h"
@interface TBBTimeLineView ()
@property (nonatomic, strong) CAShapeLayer *xLineLayer;
@property (nonatomic, strong) CAShapeLayer *yLineLayer;
@property (nonatomic,assign) NSInteger curentModelIndex;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@end
@implementation TBBTimeLineView
-(NSArray *)dataArray {

    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)dataArray{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = dataArray;
         self.backgroundColor = [UIColor whiteColor];
        [self setupPages];
        
    }
    return self;
}

-(void)setupPages {
    self.topView = [[TBBTimeLineTopView alloc]initWithFrame:CGRectMake(0, 0, kCurrentPhoneWidth, kTimeLineTopViewHeight)];
    self.topView.dataArr = self.dataArray;
    self.topPointArr = [self.topView caculatePosition];
    [self addSubview:self.topView];
    self.bottomView = [[TBBTimeLineBottomView alloc]initWithFrame:CGRectMake(0, kTimeLineTopViewHeight, kCurrentPhoneWidth, kTimeLineBottomViewHeight)];
    self.bottomView.colorArray = self.topView.colorArray;
    self.bottomView.dataArr = self.dataArray;
    self.bottomPointArr = [self.bottomView caculatePosition];
    [self addSubview:self.bottomView];
    self.touchView = [[TBBTimeLineTopTouchView alloc]initWithFrame:CGRectMake(0, 0, kCurrentPhoneWidth, 400.f) withTopViewPointArray:self.topPointArr BottomViewPointArray:self.bottomPointArr];
    self.touchView.dataArray = self.dataArray;
    [self addSubview:self.touchView];
}


@end
