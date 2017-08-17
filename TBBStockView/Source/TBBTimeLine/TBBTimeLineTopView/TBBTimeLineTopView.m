//
//  HLLineChartView.m
//  CAShapeLayer
//
//  Created by 唐彬彬 on 16/5/29.
//  Copyright © 2016年 唐彬彬. All rights reserved.
//

#import "Common.h"
#import "Masonry.h"
#import "UIColor+HL.h"
#import "CommonEnum.h"
#import "TBBTimeLineTop.h"
#import "TBBTimeLineTopTouchView.h"
#import "TBBTimeLineTopView.h"
#import "TBBTimeLineTopModel.h"
#import "TBBTimeLineTopPointModel.h"


@interface TBBTimeLineTopView ()
@property (nonatomic ,strong) TBBTimeLineTopModel *timePointModel;
@property (nonatomic, strong) UIBezierPath    *drawPath;//绘制点
@property (nonatomic,assign) CGFloat maxPrice ;// 最高点
@property (nonatomic,assign) CGFloat minPrice ;// 最低点
@property (nonatomic,assign) CGFloat averPrice ;// 均值点
@property (nonatomic,assign) CGFloat endPrice ;// 收盘点
@property (nonatomic, assign) kLineType lineType;
@property (nonatomic ,assign) kLineViewType lineViewType;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) TBBTimeLineTopTouchView *touchView;
@property (nonatomic, strong) UIImageView  *pointView;//呼吸灯
@property (nonatomic, strong) CAAnimationGroup *groups;
@property (nonatomic, strong) UIColor *color; //用于判断柱状图的颜色

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
-(NSArray *)colorArray {

    if (!_colorArray) {
        _colorArray = [NSArray array];
    }
    return _colorArray;
}
-(UIImageView *)pointView{
    if (!_pointView) {
        NSString * bundlePath = [[NSBundle mainBundle] pathForResource: @"images"ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        
        NSString *img_path = [resourceBundle pathForResource:@"dian_@2x" ofType:@"png"];
        _pointView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:img_path]];
    
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
    TBBTimeLineTop *timeLine = [[TBBTimeLineTop alloc]initWithContext:context];
    [timeLine drawTimeLineTopWithPositionArray:self.pointArray withLineColor:[UIColor colorWithHexString:@"1860FE"] andLineWidth:1.0f];
    //绘制呼吸灯view去最后一个点的坐标
    if (self.pointArray.count > 0) {
        
        TBBTimeLineTopPointModel *lastObj = self.pointArray.lastObject;
        self.pointView.frame = CGRectMake(lastObj.xPosition-12/2.f, lastObj.yPosition-10/2.f, 12.f, 12.f);
        [self.pointView.layer addAnimation:[self groups] forKey:@"aAlpha"];
    }
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

        NSString *topStr = [NSString stringWithFormat:@"%.2f",self.maxPrice];
        NSString *centerStr = [NSString stringWithFormat:@"%.2f",self.averPrice];
        NSString *bottomStr = [NSString stringWithFormat:@"%.2f",self.minPrice];
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
        //x轴每一分钟一个点，9:30到11:30,13:00到15:00共计240分钟
        //每一个横坐标点所占单元
        CGFloat unitX = kRectWidth/240.f;
        NSLog(@"%f",unitX);
        //计算y轴每一个点所占单元
        NSMutableArray *pointArr = [NSMutableArray array];
        NSMutableArray *colorArr = [NSMutableArray array];
        if (self.dataArr.count > 0) {
            for (int i=0; i<self.dataArr.count; i++) {
                TBBTimeLineTopModel *lineModel = self.dataArr[i];
                if (i == 0) {
                    if(lineModel.lastPirce<lineModel.preClosePx) {
                    
                         self.color = [UIColor colorWithHexString:@"25AE44"];
                    }else {
                    
                        self.color = [UIColor colorWithHexString:@"CE4115"];
                    }
                }else{
                
                    TBBTimeLineTopModel *lastMedel = self.dataArr[i-1];
                    //价格跌
                    if (lastMedel.lastPirce > lineModel.lastPirce) {
                        self.color = [UIColor colorWithHexString:@"25AE44"];
                    }else {
                        //涨
                        self.color = [UIColor colorWithHexString:@"CE4115"];
                    }
                }
                offset = offset >fabs(lineModel.preClosePx-lineModel.lastPirce) ? offset:fabs(lineModel.preClosePx-lineModel.lastPirce);
                [colorArr addObject:self.color];
                
            }
            self.colorArray = colorArr;
        }

            self.maxPrice =((TBBTimeLineTopModel *)[_dataArr firstObject]).preClosePx  + offset;
            self.minPrice =((TBBTimeLineTopModel*)[_dataArr firstObject]).preClosePx  - offset;
            self.averPrice = (self.maxPrice + self.minPrice)/2;
            CGFloat unitY = (self.maxPrice - self.minPrice)/(maxY-minY);
            if (!self.dataArr && self.dataArr == nil) {
                return nil;
            }else {
                
                //遍历当前的点坐标放入数组
                [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TBBTimeLineTopModel *lineModel = (TBBTimeLineTopModel *)obj;
                    CGFloat x = idx*unitX+kWidthMargin;
                    //y值考虑最大可能超出，加上绘制的线宽和矩形框的线宽
                    CGFloat y = maxY-(lineModel.lastPirce - self.minPrice)/unitY+HYStockChartTimeLineGridWidth+1.0f;
                    TBBTimeLineTopPointModel *pointModel = [TBBTimeLineTopPointModel initPositon:x yPosition:y];
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
