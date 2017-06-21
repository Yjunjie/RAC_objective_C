//
//  Account.m
//  RAC_objective_C
//
//  Created by doublej on 2017/6/20.
//  Copyright © 2017年 doublej. All rights reserved.
//


#import "Account.h"

//数据模型
@implementation Account
/**
 //捆绑事件
 RACSignal *validPasswordSignalB= [RACSignal combineLatest:@[validPasswordNullSignal,validPasswordSignal]
 reduce:^id(NSNumber*validPasswordNullSignalValid, NSNumber *validPasswordSignalValid) {
 return @([validPasswordNullSignalValid boolValue] && [validPasswordSignalValid boolValue]);
 }];
 [validPasswordSignalB subscribeNext:^(NSNumber*validPasswordSignalBValid) {
 
 if ([validPasswordSignalBValid boolValue]) {
 pwdLabelLog.text      = @"✅";
 pwdLabelLog.textColor = [UIColor greenColor];
 }else {
 pwdLabelLog.text      = @"密码不能低于6位";
 pwdLabelLog.textColor = [UIColor redColor];
 }
 }];

 **/
@end
