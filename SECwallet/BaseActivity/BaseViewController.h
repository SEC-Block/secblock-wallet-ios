//
//  BaseViewController.h
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "LoadingView.h"

@interface BaseViewController : UIViewController
{
    MBProgressHUD *HUD; //透明提示框
    BOOL _isLoading;
}

@property (nonatomic , strong) LoadingView *loadingView;

-(void)backAction;
/**
 设置导航栏标题
 */
- (void)setNavgationItemTitle:(NSString *)string;

/**
 设置导航栏左边按钮图片
 */
- (void)setNavgationLeftImage:(UIImage *)image withAction:(SEL)methot;


// 显示请求数据的HUD，并执行请求数据的方法
- (void)createLoadingView:(NSString *)message;

// 隐藏请求数据的HUD
- (void)hiddenLoadingView;

/** 显示提示信息 */
- (void)hudShowWithString:(NSString *)str delayTime:(CGFloat)time;


@end
