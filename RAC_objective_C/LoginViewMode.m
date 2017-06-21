//
//  LoginViewMode.m
//  RAC_objective_C
//
//  Created by doublej on 2017/6/20.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "LoginViewMode.h"
#import "SVProgressHUDY.h"

@implementation LoginViewMode

-(instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    
    return self;
}

-(Account *)account
{
    if (_account == nil) {
        _account  = [[Account alloc ] init];
    }
    
    return _account;
}


-(void)setUp
{
    //RACObserve()这个宏是监听某个对象的某个属性 返回的是信号
    _validUsernameSignal = [RACSignal combineLatest:@[RACObserve(self.account, account)] reduce:^id(NSString* accounta){
        NSLog(@"account==%@",accounta);
        return @(accounta.length);
    }];
    
    _validPasswordSignal = [RACSignal combineLatest:@[RACObserve(self.account, pwd)] reduce:^id(NSString* pwda){
        NSLog(@"account==%@",pwda);
        return @(pwda.length);
    }];
    //聚合
    _enableLoginSignal = [RACSignal combineLatest:@[_validUsernameSignal,_validPasswordSignal]
                                          reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid) {
                                              return @([usernameValid boolValue] && [passwordValid boolValue]);
                                          }];
    
    //RACCommand命令处理登陆业务逻辑
    _LoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"点击了登陆按钮==%@",input);
//        [self getdata];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //模仿网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:@"LoginSucc"];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    //获取执行命令所返回的数据
    [_LoginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        if ([x isEqualToString:@"LoginSucc"]) {
            NSLog(@"登陆成功");
            
        }
    }];
    
    
    //监听登陆状态
    [[_LoginCommand.executing skip:1] subscribeNext:^(id x) {
        if([x boolValue] == YES ){
             //显示蒙板
            NSLog(@"显示蒙板");
            [SVProgressHUDY show];
            
        } else {
            
            //蒙板消失
            [SVProgressHUDY showSuccessWithStatus:@"登陆成功" duration:2];
            
        }
    }];
    
}

//-(void)getdata
//{
//    
//    NSString *urlstr = @"http://192.168.1.26:8888/contentList";
//    NSString *urlstr2 = @"http://192.168.1.26:8888/contentDetail";
//    
//    NSDictionary *dic = @{@"userId":@"2"};
//    NSDictionary *dic2 = @{@"contentId":@"5"};
//    
////    [LXNetworking postWithUrl:urlstr params:dic success:^(id response) {
////        NSLog(@"111response=%@",response[@"result"] );
////    } fail:^(NSError *error) {
////    } showHUD:(NO)];
//    
//    [LXNetworking postWithUrl:urlstr2 params:dic2 success:^(id response) {
//        NSLog(@"222response=%@",response[@"result"]);
//    } fail:^(NSError *error) {
//    } showHUD:(NO)];
//
//    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@"发送请求1"];
//        });
//
//        // 发送请求1
//        
//        return nil;
//    }];
//    
//    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        // 发送请求2
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@"发送请求2"];
//        });
//        
//        return nil;
//    }];
//    
//    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
//    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
//
//}

-(void)updateUIWithR1:(RACSignal *)ra r2:(RACSignal *)rb{
    NSLog(@"updateUIWithR1==%@==%@",ra,rb);
}


@end
