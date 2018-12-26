//
//  MineViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonTableViewCell.h"
#import "WalletManageViewController.h"
#import "TradeListViewController.h"
#import "TokenCoinModel.h"
#import "AddressListViewController.h"
#import "RootViewController.h"

@interface SettingViewController ()<UIActionSheetDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addContentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowTabView object:nil];
}

- (void)addContentView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2 +Size(20))];
    headerView.backgroundColor = LightGreen_COLOR;
    [self.view addSubview:headerView];
    //标题
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(25), Size(55), kScreenWidth, Size(30))];
    titLb.font = BoldSystemFontOfSize(20);
    titLb.textColor = TEXT_BLACK_COLOR;
    titLb.text = Localized(@"我的钱包",nil);
    [headerView addSubview:titLb];
    NSArray *titArr = @[Localized(@"管理钱包",nil),Localized(@"交易记录",nil)];
    NSArray *imgArr = @[@"manageWalletIcon",@"tradeRecordIcon"];
    //快捷功能入口
    CGFloat btWidth = Size(45);
    CGFloat insert = (kScreenWidth -btWidth *imgArr.count)/(imgArr.count +2);
    for (int i = 0; i< titArr.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(insert +(insert*2 +btWidth)*i, titLb.maxY +Size(70), btWidth, btWidth)];
        iv.image = [UIImage imageNamed:imgArr[i]];
        [headerView addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(iv.minX -Size(18), iv.maxY, Size(80), Size(35))];
        lb.font = SystemFontOfSize(10);
        lb.textColor = TEXT_BLACK_COLOR;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = titArr[i];
        [headerView addSubview:lb];
        
        UIButton *lnkBtn = [[UIButton alloc]initWithFrame:iv.frame];
        lnkBtn.tag = 1000+i;
        [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:lnkBtn];
    }
    //中间线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, titLb.maxY +Size(60), Size(0.5), Size(90))];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [headerView addSubview:line];
    
    //地址薄
    CommonTableViewCell *addressCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    addressCell.frame = CGRectMake(Size(20), headerView.maxY +Size(35), kScreenWidth -Size(20 *2), Size(42));
    addressCell.icon.image = [UIImage imageNamed:@"addressBook"];
    addressCell.staticTitleLb.text = Localized(@"地址薄",nil);
    addressCell.accessoryIV.image = [UIImage imageNamed:@"accessory_right"];
    [self.view addSubview:addressCell];
    UIButton *lnkBtn = [[UIButton alloc]initWithFrame:addressCell.frame];
    lnkBtn.tag = 1002;
    [lnkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lnkBtn];
    
    CommonTableViewCell *exchangeCell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    exchangeCell.frame = CGRectMake(addressCell.minX, addressCell.maxY +Size(8), addressCell.width, addressCell.height);
    exchangeCell.icon.image = [UIImage imageNamed:@"addressBook"];
    exchangeCell.staticTitleLb.text = Localized(@"切换语言",nil);
    exchangeCell.accessoryIV.image = [UIImage imageNamed:@"accessory_right"];
    [self.view addSubview:exchangeCell];
    UIButton *lnkBtn1 = [[UIButton alloc]initWithFrame:exchangeCell.frame];
    lnkBtn1.tag = 1003;
    [lnkBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lnkBtn1];
    
    //版本提示
    UILabel *versionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, exchangeCell.maxY +Size(40), kScreenWidth, Size(10))];
    versionLb.font = SystemFontOfSize(10);
    versionLb.textColor = TEXT_DARK_COLOR;
    versionLb.textAlignment = NSTextAlignmentCenter;
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLb.text = [NSString stringWithFormat:@"V%@",app_Version];;
    [self.view addSubview:versionLb];
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(0, versionLb.maxY, kScreenWidth, Size(10))];
    remindLb.font = SystemFontOfSize(10);
    remindLb.textColor = TEXT_DARK_COLOR;
    remindLb.textAlignment = NSTextAlignmentCenter;
    remindLb.text = Localized(@"版本更新", nil);
    [self.view addSubview:remindLb];
    
}

#pragma mark - 快捷功能入口点击
-(void)btnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHiddenTabView object:nil];
    switch (sender.tag) {
        case 1000:
            //管理钱包
        {
            WalletManageViewController *controller = [[WalletManageViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1001:
            //交易记录
        {
            TradeListViewController *controller = [[TradeListViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1002:
            //地址薄
        {
            AddressListViewController *controller = [[AddressListViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1003:
            //切换语言
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:Localized(@"切换语言",nil) delegate:self cancelButtonTitle:Localized(@"取消",nil) destructiveButtonTitle:Localized(@"简体中文", nil) otherButtonTitles:Localized(@"英文", nil), nil];
            sheet.actionSheetStyle = UIActionSheetStyleDefault;
            [sheet showInView:self.view];
            sheet.delegate = self;
        }
            break;
        default:
            break;
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowTabView object:nil];
    if (buttonIndex == 0) {
        [[Localized sharedInstance]setLanguage:@"zh-Hans"];
    }else{
        [[Localized sharedInstance]setLanguage:@"en"];
    }
    
    RootViewController *controller = [[RootViewController alloc] init];
    AppDelegateInstance.window.rootViewController = controller;
    [AppDelegateInstance.window makeKeyAndVisible];
}

@end