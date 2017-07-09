//
//  TimeLineView.h
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/7/2.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBBTimeLineTopView.h"
#import "TBBTouchView.h"
@interface TBBTimeLineView : UIView
@property (nonatomic, strong) TBBTimeLineTopView *topView;
@property (nonatomic, strong) TBBTouchView *touchView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *pointArr;
-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray *)dataArray;
@end
