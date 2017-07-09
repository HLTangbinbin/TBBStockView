//
//  ViewController.m
//  TBBLineChartView
//
//  Created by 唐彬彬 on 2017/7/8.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "ViewController.h"
#import "BtnView.h"
#import "TBBTimeLineTopView.h"
#import "Masonry.h"
#import "UIColor+HL.h"
#import "TBBTimeLine.h"
#import "TBBTimeLineModel.h"
#import "TBBTimeLineView.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define WEAKINSTANCE(weakInstance,instance) __weak typeof(instance) weakInstance = instance;
#define WS(weakSelf) WEAKINSTANCE(weakSelf,self)

@interface ViewController ()
@property (nonatomic ,strong) BtnView *btnview;
@property (nonatomic ,strong) TBBTimeLineView *lineView;
@property (nonatomic ,strong) NSArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"分时",@"日K",@"周K",@"月K",@"分钟"];
    //按钮选择
    BtnView *btnView = [[BtnView alloc]initWithFrame:CGRectMake(0, 64.0f, KScreenWidth, 50.0f) titleArray:array selectedColor:[UIColor redColor] normalColor:[UIColor blackColor] titleSize:(__bridge CGSize *)([UIFont systemFontOfSize:13])];
    self.btnview = btnView;
    [self.view addSubview:btnView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *datas = [dict objectForKey:@"data3"];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (NSDictionary *dic in datas) {
        TBBTimeLineModel *model = [[TBBTimeLineModel alloc]init];
        model.data_time_stamp = dict[@"data_time_stamp"];
        model.currtTime = dic[@"curr_time"];
        model.preClosePx = [dic[@"pre_close_px"] floatValue] ;
        model.avgPirce = [dic[@"avg_pirce"] floatValue];
        model.lastPirce = [dic[@"last_px"]floatValue];
        model.volume = [dic[@"last_volume_trade"]floatValue];
        model.rate = dic[@"rise_and_fall_rate"];
        [dataArray addObject:model];
    }
    self.dataArr = dataArray;
    TBBTimeLineView *lineView = [[TBBTimeLineView alloc]initWithFrame:CGRectMake(0, 114.0f, KScreenWidth, 300.f) withDataArr:self.dataArr];
    self.lineView = lineView;
    [self.view addSubview:self.lineView];
    
    WS(ws);
    //点击不同的按钮根据tag添加不同的视图
    [self.btnview addSubviewWithBlock:^(NSInteger tag) {
        if (tag == 100) {
            for (UIView *views in [ws.lineView subviews]) {
                [views removeFromSuperview];
            }
            [ws.lineView addSubview:ws.lineView.topView];
            [ws.lineView addSubview:ws.lineView.touchView];
        }else if (tag == 101){
            for (UIView *views in [ws.lineView subviews]) {
                [views removeFromSuperview];
            }
            
        }else {
            
            for (UIView *views in [ws.lineView subviews]) {
                [views removeFromSuperview];
            }
        }
    }];
    
    
}




@end
