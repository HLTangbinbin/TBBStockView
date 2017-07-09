//
//  TBBTouchView.h
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/7/3.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBBTimeLineModel.h"
@interface TBBTouchView : UIView
@property (nonatomic, strong) NSArray *pointArray;
@property (nonatomic, strong) NSArray<TBBTimeLineModel *> *dataArray;
- (instancetype)initWithFrame:(CGRect)frame withPointArray:(NSArray *)pointArr;

@end
