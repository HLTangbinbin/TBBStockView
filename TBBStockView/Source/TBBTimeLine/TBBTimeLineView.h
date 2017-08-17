//
//  TimeLineView.h
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/7/2.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBBTimeLineTopView.h"
#import "TBBTimeLineBottomView.h"
#import "TBBTimeLineTopTouchView.h"
@interface TBBTimeLineView : UIView
@property (nonatomic, strong) TBBTimeLineTopView *topView;
@property (nonatomic, strong) TBBTimeLineTopTouchView *touchView;
@property (nonatomic, strong) TBBTimeLineBottomView *bottomView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *topPointArr;//上面视图点的坐标数组
@property (nonatomic, strong) NSArray *bottomPointArr;//下面视图点的坐标数组
-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)dataArray;
@end
