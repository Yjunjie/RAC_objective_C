//
//  ViewControllerB.m
//  RAC_objective_C
//
//  Created by doublej on 2017/6/20.
//  Copyright © 2017年 doublej. All rights reserved.
//
#import "ViewControllerB.h"
#import "SVProgressHUDY.h"

@interface ViewControllerB ()<UITextFieldDelegate>

{
    UITextField *_pwdField;//密码TextField
    UITextField *_pwdFieldB;//密码确认TextField
    UITextField *_nameField;//用户名TextField
    UILabel *nameLabelLog;//用户名提示
    UILabel *pwdLabelLog;//密码提示
    UILabel *pwdBLabelLog;//确认密码提示
    UIButton *loginBtn;//登录按钮

}

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    UIButton *bt = [[UIButton alloc]init];
    bt.frame = CGRectMake(10,20,250, 30);
    bt.backgroundColor = [UIColor redColor];
    [bt setTitle:@"测试代理替换的按钮" forState:UIControlStateNormal];
    [[bt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.delegateSignal) {
            // 有值，才需要通知
            NSLog(@"x===%@",x);
            self.signali = self.signali + 1;
            self.signalstr = [NSString stringWithFormat:@"%i",self.signali];
            [self.delegateSignal sendNext:self.signalstr];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:bt];
    
//    用户名监听
    RACSignal *validUsernameSignal =
    [_nameField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidNameNull:text]);//输入字数判断
     }];
    
//    密码监听
    RACSignal *validPasswordSignal =
    [_pwdField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);//输入字数判断
     }];
    
//    确认密码监听
    RACSignal *validPasswordBSignal =
    [_pwdFieldB.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPasswordB:text]);//输入字数判断
     }];
    
//    两次密码输入是否一致判断监听
    RACSignal *validPasswordEqualSignal =
    [_pwdFieldB.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPasswordEqual:text]);//两次密码输入是否一致判断
     }];
    
    
    {
//        监听对应信号量改变背景或文字颜色 选择性 看设计需求
//        输入框背景颜色随输入变化
        RAC(_pwdField, backgroundColor) =
        [validPasswordSignal
         map:^id(NSNumber *textValid){
             return[textValid boolValue] ? [UIColor whiteColor]:[UIColor grayColor];
         }];
        
        RAC(_pwdFieldB, backgroundColor) =
        [validPasswordBSignal
         map:^id(NSNumber *textValid){
             return[textValid boolValue] ? [UIColor whiteColor]:[UIColor grayColor];
         }];
        
        RAC(_nameField, backgroundColor) =
        [validUsernameSignal
         map:^id(NSNumber *textValid){
             return[textValid boolValue] ? [UIColor whiteColor]:[UIColor grayColor];
         }];
        
//        输入字体颜色随输入变化
        RAC(_pwdField, textColor) =
        [validPasswordSignal
         map:^id(NSNumber *textValid){
             return[textValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
         }];
        
        RAC(_pwdFieldB, textColor) =
        [validPasswordBSignal
         map:^id(NSNumber *textValid){
             return[textValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
         }];
        
        RAC(_nameField, textColor) =
        [validUsernameSignal
         map:^id(NSNumber *textValid){
             return[textValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
         }];
    }
    
//    判断用户名是否为空，设置用户名提醒文字及字体颜色
    [validUsernameSignal subscribeNext:^(NSNumber*validUsernameSignalValid) {
        
        if ([validUsernameSignalValid boolValue]) {
            nameLabelLog.text = @"✅";
            nameLabelLog.textColor = [UIColor greenColor];
         }else {
             nameLabelLog.text = @"请输入用户名";
             nameLabelLog.textColor = [UIColor redColor];
        }
    }];
    
//    判断密码是否低于6位，设置密码提醒文字及字体颜色
    [validPasswordSignal subscribeNext:^(NSNumber*validPasswordSignalValid) {
        
        if ([validPasswordSignalValid boolValue]) {
            pwdLabelLog.text      = @"✅";
            pwdLabelLog.textColor = [UIColor greenColor];
        }else {
            pwdLabelLog.text      = @"密码不能低于6位";
            pwdLabelLog.textColor = [UIColor redColor];
        }
    }];
    
    //捆绑事件
//    判断两次密码不一致，设置确认密码提醒文字及字体颜色
    RACSignal *validPasswordSignalB= [RACSignal combineLatest:@[validPasswordSignal,validPasswordEqualSignal]
                                                       reduce:^id(NSNumber*validPasswordNullSignalValid, NSNumber *validPasswordEqualSignalValid) {
                                                           return @([validPasswordNullSignalValid boolValue] && [validPasswordEqualSignalValid boolValue]);
                                                       }];
    [validPasswordSignalB subscribeNext:^(NSNumber*validPasswordSignalBValid) {
        
        if ([validPasswordSignalBValid boolValue]) {
            pwdBLabelLog.text      = @"✅";
            pwdBLabelLog.textColor = [UIColor greenColor];
        }else {
            pwdBLabelLog.text      = @"两次密码不一致";
            pwdBLabelLog.textColor = [UIColor redColor];
        }

    }];
    
    //捆绑事件 所以条件满足开放注册按钮
//    聚合捆绑监听所以事件改变注册按钮颜色
    RACSignal *loginActiveSignal = [RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal,validPasswordBSignal,validPasswordEqualSignal]
                                                     reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid,NSNumber *validPasswordBValid,NSNumber *passwordEqualValid) {
                                                         return @([usernameValid boolValue] && [passwordValid boolValue]&&
                                                         [validPasswordBValid boolValue]&&
                                                         [passwordEqualValid boolValue]);
                                                     }];
    // 订阅 loginActiveSignal, 使按扭是否可用
    [loginActiveSignal subscribeNext:^(NSNumber*loginActiveSignal) {
        
        if ([loginActiveSignal boolValue]) {
            [loginBtn setBackgroundColor:[UIColor redColor]];
        }
        else {
            [loginBtn setBackgroundColor:[UIColor grayColor]];
        }
    }];

    //依次输入满足条件后 将其点击事件置为YES
    RAC(_pwdField,enabled)   = validUsernameSignal;
    RAC(_pwdFieldB,enabled)  = validPasswordSignal;

    //绑定注册按钮
    RAC(loginBtn,enabled) = loginActiveSignal;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tapGesture];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        [_nameField resignFirstResponder];
        [_pwdField resignFirstResponder];
        [_pwdFieldB resignFirstResponder];
        
    }];

}

//判断两次密码输入是否一致
- (BOOL)isValidPasswordEqual:(NSString *)pass{
    
    return [pass isEqualToString:_pwdField.text];
    
}

//判断密码框输入字数不低于6位
- (BOOL)isValidPassword:(NSString *)password {
//  密码输入后显示密码提示文字
    pwdLabelLog.hidden = password.length <= 0;
    return password.length >= 6;
    
}

//判断确认密码框输入字数不低于6位
- (BOOL)isValidPasswordB:(NSString *)password {
//  确认密码输入后显示确认密码提示文字
    pwdBLabelLog.hidden = password.length <= 0;
    return password.length >= 6;
    
}

//判断用户名是否为空
- (BOOL)isValidNameNull:(NSString *)password {
    
    return password.length > 0;
    
}


-(void)initUI
{
    _nameField       = [[UITextField alloc]init];
    _nameField.frame = CGRectMake(20, 10+64, 250, 50);
    _nameField.borderStyle     = UITextBorderStyleLine;
    _nameField.delegate        = self;
    [self.view addSubview:_nameField];
    
    nameLabelLog = [[UILabel alloc]init];
    nameLabelLog.frame = CGRectMake(250+25, 10+64, 250, 50);
    nameLabelLog.font  = [UIFont systemFontOfSize:10];
//    nameLabelLog.backgroundColor = [UIColor blueColor];
    nameLabelLog.userInteractionEnabled = YES;
    [self.view addSubview:nameLabelLog];
    
    _pwdField       = [[UITextField alloc]init];
    _pwdField.frame = CGRectMake(20, 10+64+64, 250, 50);
    _pwdField.borderStyle     = UITextBorderStyleLine;
    _pwdField.delegate        = self;
    [self.view addSubview:_pwdField];
    
    pwdLabelLog = [[UILabel alloc]init];
    pwdLabelLog.frame = CGRectMake(250+25, 10+64+64, 250, 50);
    pwdLabelLog.font  = [UIFont systemFontOfSize:10];
//    pwdLabelLog.backgroundColor = [UIColor blueColor];
    pwdLabelLog.userInteractionEnabled = YES;
    [self.view addSubview:pwdLabelLog];
    
    _pwdFieldB       = [[UITextField alloc]init];
    _pwdFieldB.frame = CGRectMake(20, 10+64+64+64, 250, 50);
    _pwdFieldB.borderStyle     = UITextBorderStyleLine;
    _pwdFieldB.delegate        = self;
    [self.view addSubview:_pwdFieldB];
    
    pwdBLabelLog = [[UILabel alloc]init];
    pwdBLabelLog.frame = CGRectMake(250+25, 10+64+64+64, 250, 50);
    pwdBLabelLog.font  = [UIFont systemFontOfSize:10];
//    pwdBLabelLog.backgroundColor = [UIColor blueColor];
    pwdBLabelLog.userInteractionEnabled = YES;
    [self.view addSubview:pwdBLabelLog];
    
    loginBtn = [[UIButton alloc]init];
    loginBtn.frame = CGRectMake(33, 300, 250, 50);
    loginBtn.backgroundColor = [UIColor redColor];
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        //模仿网络延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUDY showSuccessWithStatus:@"注册成功" duration:1.5];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
