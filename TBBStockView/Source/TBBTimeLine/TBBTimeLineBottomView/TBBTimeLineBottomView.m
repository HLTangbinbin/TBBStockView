//
//  TBBTimeLineBottomView.m
//  TBBStockView
//
//  Created by 唐彬彬 on 2017/8/7.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "TBBTimeLineBottomView.h"
#import "Common.h"
#import "CommonEnum.h"
#import "UIColor+HL.h"
#import "TBBTimeLineBottom.h"
#import "TBBTimeLineTopModel.h"
#import "TBBTimeLineBottomPointModel.h"
@interface TBBTimeLineBottomView()
@property (nonatomic ,assign) CGFloat maxVolume;//成交量
@property (nonatomic ,assign) CGFloat minVolume;
@property (nonatomic ,assign) kLineViewType lineViewType;
@property (nonatomic ,strong) TBBTimeLineTopModel *timeLineTopModel;
@property (nonatomic ,strong) TBBTimeLineBottomPointModel *timeLineBottomPointModel;
@end

@implementation TBBTimeLineBottomView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
 
    [super drawRect:rect];
    
//    //上下文区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    //计算坐标
    [self caculatePosition];
    //绘制坐标点
    TBBTimeLineBottom *timeLinebottom = [[TBBTimeLineBottom alloc]initWithContext:context];
    CGFloat volumeLineWidth = (kCurrentPhoneWidth-2*kWidthMargin) / self.pointArray.count - 1.0;
    [timeLinebottom drawTimeLineBottomWithPositionArray:self.pointArray withLineColorArray:self.colorArray andLineWidth:volumeLineWidth];
    //绘制背景矩形框
    [self drawGridBackground:context];
}

#pragma mark - ****************使用C语言上下文绘制图形
- (void)drawGridBackground:(CGContextRef)context {
    //绘制整体边框
    CGContextSetLineWidth(context, HYStockChartTimeLineGridWidth);
    CGContextSetStrokeColorWithColor(context,[UIColor colorWithHexString:@"999999"].CGColor);
    CGContextStrokeRect(context, CGRectMake(kWidthMargin, 0, (kViewWidth-2*kWidthMargin) , kViewHeight-kHeightMargin));
    /**
     使用CGContextRef绘制图形，如果将实线放入循环中与虚线一起绘制，绘制时在同一个上下文重用了上次绘制的样式会出现错乱的bug
     */
    //绘制中间的竖实线
    [self lineType:kLineTypeFullLine drawline:context startPoint:CGPointMake(kViewWidth / 2,0) stopPoint:CGPointMake(kViewWidth / 2, kViewHeight-kHeightMargin) color:[UIColor colorWithHexString:@"999999"] lineWidth:0.5];
    //绘制横实线
    [self lineType:kLineTypeFullLine drawline:context startPoint:CGPointMake(kWidthMargin,(kTimeLineBottomViewHeight-kHeightMargin)/2) stopPoint:CGPointMake(kViewWidth-kWidthMargin, (kTimeLineBottomViewHeight-kHeightMargin)/2) color:[UIColor colorWithHexString:@"999999"] lineWidth:0.5];
    //绘制虚线
    for (int i=2; i<5; i++) {
        if (i == 3 ) {
            
        }else{
 
            // 绘制竖着的虚线
            [self  lineType:kLineTypeDottedline drawline:context startPoint:CGPointMake(kWidthMargin+kRectWidth / 4*(i-1),0) stopPoint:CGPointMake(kWidthMargin+kRectWidth / 4*(i-1),kViewHeight-kHeightMargin) color:[UIColor colorWithHexString:@"999999"] lineWidth:0.5];
            
        }
        
    }
    
    
}
#pragma mark - **************** 使用CGContextRef绘制中间的虚实线

- (void)lineType:(kLineType)lineType drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth
{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    if (lineType == kLineTypeDottedline) {
        //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制5个点再绘制1个点
        CGFloat arr[] = {6,1};
        //下面最后一个参数“1”代表排列的个数。
        CGContextSetLineDash(context, 0, arr, 2);
    }
    CGContextStrokePath(context);
    
}

//计算点的位置坐标
-(NSArray *)caculatePosition {
     WS(ws);
    _lineViewType = kLineViewTypeTime;
    CGFloat minY = 0;
    CGFloat maxY = kTimeLineBottomViewHeight-kHeightMargin;

    //1.算y轴的单元值
    if (_lineViewType == kLineViewTypeTime) {
        //x轴每一分钟一个点，9:30到11:30,13:00到15:00共计240分钟
        //每一个横坐标点所占单元
        CGFloat unitX = kRectWidth/240.f;
        NSLog(@"%f",unitX);
        //计算y轴每一个点所占单元
        TBBTimeLineTopModel *firstModel = [self.dataArr firstObject];
        self.maxVolume = firstModel.volume;
        self.minVolume = firstModel.volume;
       
        NSMutableArray *pointArr = [NSMutableArray array];
        if (self.dataArr.count > 0) {
            [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TBBTimeLineTopModel *lineModel = (TBBTimeLineTopModel *)obj;
                if (lineModel.volume < ws.minVolume) {
                    ws.minVolume = lineModel.volume;
                }else if (lineModel.volume > ws.maxVolume) {
                    ws.maxVolume = lineModel.volume;
                }else if (lineModel.volume < 0){
                    NSLog(@"第%ld个成交量%.2f小于0",idx,lineModel.volume);
                }
            }];
            NSLog(@"minVolume: %.2f---maxVolume: %.2f",self.minVolume,self.maxVolume);
            CGFloat unitY = (ws.maxVolume - ws.minVolume)/(maxY-minY);
            if (!self.dataArr && self.dataArr == nil) {
                return nil;
            }else {
                
                //遍历当前的点坐标放入数组
                [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TBBTimeLineTopModel *lineModel = (TBBTimeLineTopModel *)obj;
                    CGFloat x = idx*unitX+kWidthMargin;
                    //y值考虑最大可能超出，加上绘制的线宽和矩形框的线宽
                    CGFloat y = maxY-HYStockChartTimeLineGridWidth-(lineModel.volume - self.minVolume)/unitY;
                    TBBTimeLineBottomPointModel *pointModel = [TBBTimeLineBottomPointModel initPositon:x yPosition:y];
                    [pointArr addObject:pointModel];
                }];
                
                ws.pointArray = pointArr;
            }
        }
        return ws.pointArray;
    }
    
    return ws.pointArray;
}
@end
