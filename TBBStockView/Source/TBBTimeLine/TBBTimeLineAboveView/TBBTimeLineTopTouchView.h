//
//  TBBTouchView.h
//  TBB-Kline
//
//  Created by 唐彬彬 on 2017/7/3.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBBTimeLineTopModel.h"
@interface TBBTimeLineTopTouchView : UIView
@property (nonatomic, strong) NSArray *topViewPointArray;
@property (nonatomic, strong) NSArray *bottomViewPointArray;
@property (nonatomic, strong) NSArray<TBBTimeLineTopModel *> *dataArray;
- (instancetype)initWithFrame:(CGRect)frame withTopViewPointArray:(NSArray *)topViewPointArray BottomViewPointArray:(NSArray *)bottomViewPointArray;

@end
