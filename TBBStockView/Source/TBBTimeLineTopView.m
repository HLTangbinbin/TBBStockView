//
//  HLLineChartView.m
//  CAShapeLayer
//
//  Created by 唐彬彬 on 16/5/29.
//  Copyright © 2016年 唐彬彬. All rights reserved.
//

#import "TBBTimeLineTopView.h"
//#import "UIView+FrameSet.h"
//#import "UIColor+HYStockChart.h"
#import "Common.h"
#import "TBBTimeLine.h"
#import "UIColor+HL.h"
#import "TBBTimeLineModel.h"
#import "TBBTimeLinePointModel.h"
#import "TBBTouchView.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, kLineType) {
    /**
     *  实线
     */
    kLineTypeFullLine = 1,
    /**
     *  虚线
     */
    kLineTypeDottedline = 2,
 
    
};
typedef NS_ENUM(NSInteger,kLineViewType) {

    /**
     *  分时图
     */
    kLineViewTypeTime = 1,
    /**
     *  k线图
     */
    kLineViewTypek = 2,
};
/**
 *  背景框的宽度
 */
CGFloat const HYStockChartTimeLineGridWidth = 0.5;
/**
 绘制矩形框范围与view横向间距
 */
#define kWidthMargin 10
/**
 绘制矩形框范围与view纵向间距
 */
#define kHeightMargin 20
#define kViewHeight self.frame.size.height
#define kViewWidth self.frame.size.width

/**
 绘制矩形框宽度
 */
#define kRectWidth (kViewWidth-2*kWidthMargin)
/**
 绘制矩形框高度
 */
#define kRectHeight (kViewHeight-2*kHeightMargin)
/**
 横坐标文字上下文范围
 */
#define kHorizontalTextRect CGRectMake(kWidthMargin,kRectHeight+kHeightMargin,kRectWidth, kHeightMargin)
/**
 纵坐标文字上下文范围TOP
 */
#define kVerticalTextTopRect CGRectMake(kWidthMargin,kHeightMargin,100.f, kRectHeight)
/**
 纵坐标文字上下文范围Center
 */
#define kVerticalTextCenterRect CGRectMake(kWidthMargin,kViewHeight/2-strSize.height/2,100.f, kRectHeight)
/**
 纵坐标文字上下文范围Bottom
 */
#define kVerticalTextTopBottomRect CGRectMake(kWidthMargin,kRectHeight+kHeightMargin-strSize.height,100.f, kRectHeight)
@interface TBBTimeLineTopView ()
@property (nonatomic ,strong) TBBTimeLineModel *timePointModel;
@property (nonatomic, strong) UIBezierPath    *drawPath;//绘制点
@property (nonatomic,assign) CGFloat maxPrice ;// 最高点
@property (nonatomic,assign) CGFloat minPrice ;// 最低点
@property (nonatomic,assign) CGFloat endPrice ;// 收盘点
@property (nonatomic, assign) kLineType lineType;
@property (nonatomic ,assign) kLineViewType lineViewType;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) TBBTouchView *touchView;
@property (nonatomic, strong) UIImageView  *pointView;//呼吸灯
@property (nonatomic, strong) CAAnimationGroup *groups;
@end

@implementation TBBTimeLineTopView


-(NSArray *)dataArr {

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
     return _dataArr;
}
-(NSArray*)pointArray {
    if (!_pointArray) {
        _pointArray = [NSArray array];
    }
    return _pointArray;
}
-(UIImageView *)pointView{
    if (!_pointView) {
        _pointView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dian_"]];
        [_pointView sizeToFit];
        [self addSubview:_pointView];
    }
    return _pointView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

}

#pragma mark - 核心绘图
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //上下文区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    //计算坐标点
    [self caculatePosition];
/**
 ******此处方法调用一定在绘制背景虚实线之前，否则会被覆盖属性，导致画出来的是虚线此处bug找了很久才发现原因*****
 */
    //绘制曲线图
    TBBTimeLine *timeLine = [[TBBTimeLine alloc]initWithContext:context];
    [timeLine drawTimeLineWithPositionArray:self.pointArray withLineColor:[UIColor blueColor] andLineWidth:1.0f];
    //绘制呼吸灯view去最后一个点的坐标
    TBBTimeLinePointModel *lastObj = self.pointArray.lastObject;
    self.pointView.frame = CGRectMake(lastObj.xPosition-12/2.f, lastObj.yPosition-10/2.f, 12.f, 12.f);
    [self.pointView.layer addAnimation:[self groups] forKey:@"aAlpha"];
    //使用CAShapeLayer绘制背景边框及虚实线
//    [self drawLineWithShapeLayerRect];
//    使用Contex绘制背景边框及虚实线
    [self drawGridBackground:context];
//    绘制横坐标值
    [self drawHorizental];
     //绘制纵坐标值
    [self drawVerticalt];
    
}
#pragma mark - ****************使用C语言上下文绘制图形
- (void)drawGridBackground:(CGContextRef)context {
    //绘制整体边框
    CGContextSetLineWidth(context, HYStockChartTimeLineGridWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"999999"].CGColor);
    CGContextStrokeRect(context, CGRectMake(kWidthMargin, kHeightMargin, (kViewWidth-2*kWidthMargin) , kViewHeight-2*kHeightMargin));
/**
 使用CGContextRef绘制图形，如果将实线放入循环中与虚线一起绘制，绘制时在同一个上下文重用了上次绘制的样式会出现错乱的bug
 */ 
    //绘制中间的竖实线
    [self lineType:kLineTypeFullLine drawline:context startPoint:CGPointMake(kViewWidth / 2,kHeightMargin) stopPoint:CGPointMake(kViewWidth / 2, kViewHeight-kHeightMargin) color:[UIColor colorWithHexString:@"999999"] lineWidth:0.5];
    //绘制横实线
    [self lineType:kLineTypeFullLine drawline:context startPoint:CGPointMake(kWidthMargin,kViewHeight/ 2) stopPoint:CGPointMake(kViewWidth-kWidthMargin, kViewHeight/2) color:[UIColor colorWithHexString:@"999999"] lineWidth:0.5];
    //绘制虚线
    for (int i=2; i<5; i++) {
        if (i == 3 ) {
            
        }else{
            
            //绘制横着的虚线
            [self lineType:kLineTypeDottedline drawline:context startPoint:CGPointMake(kWidthMargin,kHeightMargin+kRectHeight / 4*(i-1)) stopPoint:CGPointMake(kViewWidth-kWidthMargin, kHeightMargin+kRectHeight / 4*(i-1)) color:[UIColor colorWithHexString:@"999999"] lineWidth:0.5];
            // 绘制竖着的虚线
            [self  lineType:kLineTypeDottedline drawline:context startPoint:CGPointMake(kWidthMargin+kRectWidth / 4*(i-1),kHeightMargin) stopPoint:CGPointMake(kWidthMargin+kRectWidth / 4*(i-1),kViewHeight-kHeightMargin) color:[UIColor colorWithHexString:@"999999"] lineWidth:0.5];
            
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

#pragma mark - 横坐标
-(void)drawHorizental{
    _lineViewType = kLineViewTypeTime;
    if (_lineViewType == kLineViewTypeTime) {
        
        NSString *leftStr = @"09:30";
        [leftStr drawInRect:kHorizontalTextRect withAttributes:[self fontSize:13 andTextColor:[UIColor colorWithHexString:@"999999"] textAlignment:NSTextAlignmentLeft]];
        NSString *centerStr = @"13:00";
        [centerStr drawInRect:kHorizontalTextRect withAttributes:[self fontSize:13 andTextColor:[UIColor colorWithHexString:@"999999"] textAlignment:NSTextAlignmentCenter]];
        NSString *rightStr = @"15:00";
        [rightStr drawInRect:kHorizontalTextRect withAttributes:[self fontSize:13 andTextColor:[UIColor colorWithHexString:@"999999"] textAlignment:NSTextAlignmentRight]];
        
    }else if (_lineViewType == kLineViewTypek){
    
       
        
    }

}
#pragma mark - 纵坐标
-(void)drawVerticalt{
    _lineViewType = kLineViewTypeTime;
    
    if (_lineViewType == kLineViewTypeTime) {

        NSString *topStr = @"5.56";
        NSString *centerStr = @"5.46";
        NSString *bottomStr = @"5.36";
        CGSize  strSize = [topStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        [topStr drawInRect:kVerticalTextTopRect withAttributes:[self fontSize:13 andTextColor:[UIColor colorWithHexString:@"fb4747"] textAlignment:NSTextAlignmentLeft]];
        [centerStr drawInRect:kVerticalTextCenterRect withAttributes:[self fontSize:13 andTextColor:[UIColor colorWithHexString:@"333333"] textAlignment:NSTextAlignmentLeft]];
        [bottomStr drawInRect:kVerticalTextTopBottomRect withAttributes:[self fontSize:13 andTextColor:[UIColor colorWithHexString:@"009100"] textAlignment:NSTextAlignmentLeft]];

    }else if (_lineViewType == kLineViewTypek){
      
        
        
    }
    
}

//计算点的位置坐标
-(NSArray *)caculatePosition {
    _lineViewType = kLineViewTypeTime;
    CGFloat minY = kHeightMargin; //10
    CGFloat maxY = kHeightMargin+kRectHeight;
  
    __block CGFloat offset = CGFLOAT_MIN;
    //1.算y轴的单元值
    if (_lineViewType == kLineViewTypeTime) {
        //x轴每一分钟一个点，9:30到11:30,13:00到15:00共计240分钟
        //每一个横坐标点所占单元
        CGFloat unitX = kRectWidth/240.f;
        NSLog(@"%f",unitX);
        //计算y轴每一个点所占单元
        NSMutableArray *pointArr = [NSMutableArray array];
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TBBTimeLineModel *lineModel = (TBBTimeLineModel *)obj;
            
            offset = offset >fabs(lineModel.preClosePx-lineModel.lastPirce) ? offset:fabs(lineModel.preClosePx-lineModel.lastPirce);
        }];
        self.maxPrice =((TBBTimeLineModel *)[_dataArr firstObject]).preClosePx  + offset;
        self.minPrice =((TBBTimeLineModel*)[_dataArr firstObject]).preClosePx  - offset;
 
        CGFloat unitY = (self.maxPrice - self.minPrice)/(maxY-minY);
        //遍历当前的点坐标放入数组
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TBBTimeLineModel *lineModel = (TBBTimeLineModel *)obj;
            CGFloat x = idx*unitX+kWidthMargin;
            //y值考虑最大可能超出，加上绘制的线宽和矩形框的线宽
            CGFloat y = (maxY-minY)-(lineModel.lastPirce - self.minPrice)/unitY+kHeightMargin+HYStockChartTimeLineGridWidth+1.0f;
            TBBTimeLinePointModel *pointModel = [TBBTimeLinePointModel initPositon:x yPosition:y];
            [pointArr addObject:pointModel];
        }];
   
        self.pointArray = pointArr;
        }
    return self.pointArray;

}
/**
 设置需要绘制的字体样式

 @param fontSize 字体大小
 @param color 字体颜色
 @param textAlignment 段落样式
 @return 返回属性字典
 */
-(NSDictionary *)fontSize:(CGFloat )fontSize andTextColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];//段落样式
    style.alignment = textAlignment;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = @{NSFontAttributeName:font, NSForegroundColorAttributeName:color,
        NSParagraphStyleAttributeName:style};
    return dict;
    
}

/**
 呼吸灯动画组

 @return 返回核心动画
 */
- (CAAnimationGroup *)groups {
    if (!_groups) {
        // 缩放动画
        CABasicAnimation * scaleAnim = [CABasicAnimation animation];
        scaleAnim.keyPath = @"transform.scale";
        scaleAnim.fromValue = @0.1;
        scaleAnim.toValue = @1;
        scaleAnim.duration = 2;
        // 透明度动画
        CABasicAnimation *opacityAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue= @1;
        opacityAnim.toValue= @0.1;
        opacityAnim.duration= 2;
        // 动画组
        _groups =[CAAnimationGroup animation];
        _groups.animations = @[scaleAnim,opacityAnim];
        _groups.removedOnCompletion = NO;
        _groups.fillMode = kCAFillModeForwards;
        _groups.duration = 2;
        _groups.repeatCount = FLT_MAX;
    }
    return _groups;
}
#pragma  mark delloc
-(void)dealloc{
    MyLog(@"TBBTimeLineTopView dealloc");
    //移除动画
    [self.pointView.layer removeAllAnimations];
    _pointArray = nil;
    _drawPath = nil;
    
}


@end