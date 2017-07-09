//
//  BtnView.m
//  SelectedBtn
//
//  Created by 唐彬彬 on 2017/3/28.
//  Copyright © 2017年 唐彬彬. All rights reserved.
//

#import "BtnView.h"
#import "Masonry.h"
#import "UIColor+HL.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KBtnHeight 44.0f
#define KSlideHeight 2.0f
#define WEAKINSTANCE(weakInstance,instance) __weak typeof(instance) weakInstance = instance;
#define WS(weakSelf) WEAKINSTANCE(weakSelf,self)

@interface BtnView ()
@property (nonatomic ,strong) UIButton *selectedBtn;//按钮
@property (nonatomic ,strong) UIView *slideView;//滑块
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,strong) NSArray *btnArray;

@end

@implementation BtnView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray selectedColor:(UIColor *)selectedColor normalColor:(UIColor *)normalColor titleSize:(CGSize *)size{

    if (self = [super initWithFrame:frame]) {
        WS(ws);
        NSMutableArray *btnArr = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
        for (int i=0; i<titleArray.count; i++) {
            //设置为自定义button
            UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectedBtn.frame = CGRectMake(KScreenWidth/titleArray.count*i, 0, KScreenWidth/titleArray.count, KBtnHeight);
            self.selectedBtn = selectedBtn;
            [selectedBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [selectedBtn setTitleColor:normalColor forState:UIControlStateNormal];
            [selectedBtn setTitleColor:selectedColor forState: UIControlStateSelected];
            //此处加上自定义button类型设置高亮状态颜色可以避免使用系统button类型在点击按钮时的高亮显示bug
            [selectedBtn setTitleColor:selectedColor forState:UIControlStateHighlighted|UIControlStateSelected];
            [self addSubview:selectedBtn];
            [btnArr addObject:selectedBtn];
            selectedBtn.tag = i+100;
            [selectedBtn addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        self.btnArray = btnArr;
        ((UIButton *)[self.btnArray objectAtIndex:0]).selected = YES;

        UIView *slideView = [[UIView alloc]init];
        self.slideView = slideView;
        slideView.backgroundColor = selectedColor;
        [self addSubview:slideView];
 
        [_slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(((UIButton *)[self.btnArray objectAtIndex:0]));
            make.top.equalTo(ws.selectedBtn.mas_bottom);
            make.width.mas_equalTo(0.6*KScreenWidth/self.btnArray.count);
            make.height.mas_equalTo(2.0f);
        }];
        
    }
    return self;
}

/**
 点击按钮切换页面

 @param btn 点击的按钮
 */
-(void)selectedButtonClick:(UIButton *)btn {

  ((UIButton *)[self.btnArray objectAtIndex:0]).selected = NO;
    [self selecteButton:btn.tag];
    [self changeSlideView];
    [self changePages];
    self.index = btn.tag;
}

/**
 选中按钮改变字体颜色

 @param index button tag值
 */
-(void)selecteButton:(NSInteger )index {
    if (index != self.selectedBtn.tag) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = [self viewWithTag:index];
        self.selectedBtn.selected = YES;
    }else{
        
        self.selectedBtn.selected = YES;
        
    }
    
}

/**
 点击按钮滑块动画
 */
-(void)changeSlideView {

    WS(ws);
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = ws.selectedBtn.center;
        center.x = ws.selectedBtn.frame.origin.x+KScreenWidth/ws.btnArray.count/2;
        center.y = ws.selectedBtn.frame.origin.y+KBtnHeight+KSlideHeight/2;
        ws.slideView.center = center;
        
    }];
}

/**
 点击按钮切换页面
 */
-(void)changePages {

    NSLog(@"%ld",self.selectedBtn.tag);
   
    self.myBlock(self.selectedBtn.tag);
    

}

-(void)addSubviewWithBlock:(addSubViewBlock)block{
    
    self.myBlock = block;

}

@end
