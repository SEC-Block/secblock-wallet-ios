//
//  BackupRemindViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/9.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "BackupRemindViewController.h"
#import "BackupFileBeforeViewController.h"
#import "RootViewController.h"
#import "ConfirmPasswordViewController.h"

@interface BackupRemindViewController ()

@end

@implementation BackupRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)setupUI
{
    UIButton *backupBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(45+20), KStatusBarHeight+Size(11), Size(55), Size(24))];
    [backupBT greenBorderBtnStyle:Localized(@"跳过",nil) andBkgImg:@"smallRightBtn"];
    [backupBT addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backupBT];
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), backupBT.maxY +Size(25), Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"备份钱包",nil);
    [self.view addSubview:titleLb];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(105))/2, titleLb.maxY +Size(40), Size(105), Size(85))];
    icon.image = [UIImage imageNamed:@"backupWallet"];
    [self.view addSubview:icon];
    
    UILabel *desLb = [[UILabel alloc]initWithFrame:CGRectMake(0, icon.maxY +Size(50), kScreenWidth, Size(15))];
    desLb.font = SystemFontOfSize(11);
    desLb.textColor = TEXT_GREEN_COLOR;
    desLb.textAlignment = NSTextAlignmentCenter;
    desLb.text = Localized(@"最后一步", nil);
    [self.view addSubview:desLb];
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(0, desLb.maxY, kScreenWidth, Size(20))];
    remindLb.font = BoldSystemFontOfSize(15);
    remindLb.textColor = TEXT_BLACK_COLOR;
    remindLb.textAlignment = NSTextAlignmentCenter;
    remindLb.text = Localized(@"立即备份您的钱包！", nil);
    [self.view addSubview:remindLb];
    
    UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), remindLb.maxY, kScreenWidth -Size(20*2), Size(70))];
    contentLb.font = SystemFontOfSize(11);
    contentLb.textColor = COLOR(85, 101, 110, 1);
    contentLb.numberOfLines = 4;
    contentLb.text = Localized(@"备份钱包：导出[助记词]并抄写到安全的地方，千万不要保存到网络上。\n然后尝试转入，转出小额资产开始使用。", nil);
    [self.view addSubview:contentLb];
    contentLb.textAlignment = NSTextAlignmentCenter;
    /*****************下一步*****************/
    UIButton *nextBT = [[UIButton alloc] initWithFrame:CGRectMake(Size(20),contentLb.maxY +Size(35), kScreenWidth - 2*Size(20), Size(45))];
    [nextBT goldBigBtnStyle:Localized(@"备份钱包",nil)];
    [nextBT addTarget:self action:@selector(backupAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBT];
}

//进入首页
-(void)jumpAction
{
    RootViewController *controller = [[RootViewController alloc] init];
    AppDelegateInstance.window.rootViewController = controller;
    [AppDelegateInstance.window makeKeyAndVisible];
}

-(void)backupAction
{
    ConfirmPasswordViewController *controller = [[ConfirmPasswordViewController alloc]init];
    controller.walletModel = _walletModel;
    [self.navigationController pushViewController:controller animated:YES];
    controller.sureBlock = ^() {
        BackupFileBeforeViewController *controller = [[BackupFileBeforeViewController alloc]init];
        controller.walletModel = _walletModel;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navi animated:YES completion:nil];
    };
}

@end
