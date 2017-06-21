//
//  LoginViewMode.h
//  RAC_objective_C
//
//  Created by doublej on 2017/6/20.
//  Copyright © 2017年 doublej. All rights reserved.
// 登陆视图模型

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "Account.h"

@interface LoginViewMode : NSObject

@property (nonatomic, retain) Account *account;

@property(nonatomic,strong,readonly) RACSignal *enableLoginSignal;//聚合信号
@property(nonatomic,strong,readonly) RACSignal *validUsernameSignal;//用户名属性监听
@property(nonatomic,strong,readonly) RACSignal *validPasswordSignal;//密码属性监听

@property(nonatomic,strong,readonly) RACCommand *LoginCommand;

@end
