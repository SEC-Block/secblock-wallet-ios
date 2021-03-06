//
//  AppDefaultUtil.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDefaultUtil : NSObject

/**
 单例模式，实例化对象
 */
+ (instancetype)sharedInstance;

// 判断用户是否创建了钱包
-(BOOL) hasCreatWallet;

// 保存默认钱包位置
-(void) setDefaultWalletIndex:(NSString *)index;

// 获取默认钱包位置
-(NSString *) defaultWalletIndex;


@end
