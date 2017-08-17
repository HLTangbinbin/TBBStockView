//
//  TBBTimeLineBottomView.h
//  TBBStockView
//
//  Created by 唐彬彬 on 2017/8/7.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBBTimeLineBottomView : UIView
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *pointArray;
@property (nonatomic, strong) NSArray *colorArray;
-(NSArray *)caculatePosition;
@end
