//
//  ViewController.m
//  RAC_objective_C
//
//  Created by doublej on 2017/6/19.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ViewControllerB.h"
#import "LoginViewMode.h"
#import "AppDelegate.h"
#import "SVProgressHUDY.h"

@interface ViewController ()<UITextFieldDelegate>
{
    UIButton    *btn;
    UIView      *viewA;
    UITextField *_pwdField;
    UITextField *_textField;
    UILabel     *label;
    UIButton    *loginBtn;
}
@property(nonatomic,strong) LoginViewMode *loginViewMode;
@property (nonatomic, strong)RACCommand *commandb;
@end

@implementation ViewController

-(LoginViewMode *)loginViewMode
{
    if (!_loginViewMode) {
        _loginViewMode = [[LoginViewMode alloc] init];
    }
    
    return  _loginViewMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, 10+64, 200, 50);
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"注册跳转" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    viewA = [[UIView alloc]init];
    viewA.frame = CGRectMake(10+64+200, 10+64, 50, 50);
    viewA.backgroundColor = [UIColor yellowColor];
    viewA.userInteractionEnabled = YES;
//    [self.view addSubview:viewA];
    
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 10+64+64, 150, 50);
    label.backgroundColor = [UIColor blueColor];
    label.userInteractionEnabled = YES;
//    [self.view addSubview:label];
    
    _textField       = [[UITextField alloc]init];
    _textField.frame = CGRectMake(20, 10+64+64+64, 250, 50);
    _textField.borderStyle     = UITextBorderStyleLine;
    _textField.delegate        = self;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    
    _pwdField       = [[UITextField alloc]init];
    _pwdField.frame = CGRectMake(20, 10+64+64+64+64, 250, 50);
    _pwdField.borderStyle     = UITextBorderStyleLine;
    _pwdField.delegate        = self;
    _pwdField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdField];
    
    loginBtn = [[UIButton alloc]init];
    loginBtn.frame = CGRectMake(33, 310+64, 250, 50);
    loginBtn.backgroundColor = [UIColor redColor];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self btAction];
        
    }];
//给模型的属性绑定信号
    RAC(self.loginViewMode.account,account) = _textField.rac_textSignal;
    RAC(self.loginViewMode.account,pwd) = _pwdField.rac_textSignal;
    
    //绑定颜色变化 根据需求删减
    RAC(_pwdField, backgroundColor) =
    [self.loginViewMode.validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor whiteColor]:[UIColor grayColor];
     }];
    
    RAC(_textField, backgroundColor) =
    [self.loginViewMode.validUsernameSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor whiteColor]:[UIColor grayColor];
     }];
    
    RAC(_pwdField, textColor) =
    [self.loginViewMode.validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
     }];
    
    RAC(_textField, textColor) =
    [self.loginViewMode.validUsernameSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
     }];
    
    
    // 订阅 loginActiveSignal, 使按扭是否可用
    [self.loginViewMode.enableLoginSignal subscribeNext:^(NSNumber*loginActiveSignalValid) {
        
        if ([loginActiveSignalValid boolValue]) {
            [loginBtn setBackgroundColor:[UIColor redColor]];
        }
        else {
            [loginBtn setBackgroundColor:[UIColor grayColor]];
        }
    }];
    //绑定登陆按钮
    RAC(loginBtn,enabled) = self.loginViewMode.enableLoginSignal;
    
//    [self oneTest];
//    [self twoTest];
//    [self threeTest];
//    [self fourTest];
    [self fiveTest];
    [self sixTest];
    [self senvenTest];
    
//    解除键盘第一响应者回退键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tapGesture];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        [_pwdField resignFirstResponder];
        [_textField resignFirstResponder];
    }];
}

- (BOOL)isValidUsername:(NSString *)username {
    
    return username.length >= 6;
    
}

- (BOOL)isValidPassword:(NSString *)password {
    
    return password.length >= 6;
    
}

-(void)btAction
{
//    [SVProgressHUDY showSuccessWithStatus:@"登陆成功" duration:1.5];
    [self.loginViewMode.LoginCommand execute:@"nil"];
    DEBUGLog(@"btActionbtActionbtAction");
}

-(void)btActionB
{
    DEBUGLog(@"点击了btActionB按钮");
}

-(void)oneTest{
    // 1.创建信号
    
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        // 2.发送信号
        [subscriber sendNext:@1];
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            DEBUGLog(@"销毁订阅信号");
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        DEBUGLog(@"接收到数据:%@",x);
    }];
    DEBUGLog(@"****************************\n");
}

-(void)twoTest
{
    /**
     RACSubject使用步骤
     1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
     2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
     3.发送信号 sendNext:(id)value
    
     RACSubject:底层实现和RACSignal不一样。
     1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
     2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    **/
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        DEBUGLog(@"接收第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        DEBUGLog(@"接收第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"1"];
    [subject sendNext:@"1"];
    DEBUGLog(@"****************************\n");
}

-(void)threeTest
{
    /**
     RACReplaySubject使用步骤:
     1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
     2.可以先订阅信号，也可以先发送信号。
     2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
     2.2 发送信号 sendNext:(id)value
    
     RACReplaySubject:底层实现和RACSubject不一样。
     1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
     2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
     如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
     也就是先保存值，在订阅值。
    **/
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    [replaySubject sendNext:@"发送信号"];
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        DEBUGLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        DEBUGLog(@"第二个订阅者接收到的数据%@",x);
    }];
    DEBUGLog(@"****************************\n");
}

-(void)fourTest
{
    /**
     一、RACCommand使用步骤:
     1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
     2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
     3.执行命令 - (RACSignal *)execute:(id)input
    
     二、RACCommand使用注意:
     1.signalBlock必须要返回一个信号，不能传nil.
     2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
     3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
     4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
     三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
     1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
     2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
     四、如何拿到RACCommand中返回信号发出的数据。
     1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
     2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
     五、监听当前命令是否正在执行executing
    
     六、使用场景,监听按钮点击，网络请求
    **/
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        DEBUGLog(@"RAC-执行命令");
        
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"RAC-请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _commandb = command;
    
    // 3.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            
            DEBUGLog(@"RAC-%@",x);
        }];
        
    }];
       
    DEBUGLog(@"****************************\n");
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [_commandb.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        DEBUGLog(@"RAC高级用法-%@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[_commandb.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            DEBUGLog(@"RAC高级用法-正在执行");
            
        }else{
            // 执行完成
            DEBUGLog(@"RAC高级用法-执行完成");
        }
        
    }];
    // 5.执行命令
    [_commandb execute:@1];
    
    DEBUGLog(@"****************************\n");
}

-(void)fiveTest
{
    /**
     RACMulticastConnection使用步骤:
     1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
     2.创建连接 RACMulticastConnection *connect = [signal publish];
     3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
     4.连接 [connect connect]
    
     RACMulticastConnection底层原理:
     1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
     2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
     3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
     3.1.订阅原始信号，就会调用原始信号中的didSubscribe
     3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
     4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
     4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    
    
     需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
     解决：使用RACMulticastConnection就能解决.
    **/
    // 1.创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        DEBUGLog(@"aa发送请求");
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        DEBUGLog(@"aa接收数据==%@",x);
        
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        DEBUGLog(@"aa接收数据==%@",x);
        
    }];
   
    
    // 3.运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求
    DEBUGLog(@"****************************\n");
    {
    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        DEBUGLog(@"重复请求问题发送请求");
        [subscriber sendNext:@1];
        [subscriber sendNext:@"重复请求问题发送请求"];
        return nil;
    }];
    
    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        
        DEBUGLog(@"重复请求问题订阅者一信号==%@",x);
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        DEBUGLog(@"重复请求问题订阅者二信号==%@",x);
        
    }];
        
    [connect.signal subscribeNext:^(id x) {
        
        DEBUGLog(@"重复请求问题订阅者三信号==%@",x);
        
    }];
    
    // 4.连接,激活信号
    [connect connect];
}
}

-(void)sixTest
{
    /**
     1.代替代理
     需求：自定义redView,监听红色view中按钮点击
     之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
     rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
     这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
     **/
    [[viewA rac_signalForSelector:@selector(btActionB)] subscribeNext:^(id x) {
       
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
//    tapGesture.numberOfTapsRequired = 2;
    [viewA addGestureRecognizer:tapGesture];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        DEBUGLog(@"viewArac_gestureSignal==%@",x);
        
    }];
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[viewA rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        DEBUGLog(@"center==%@",x);
        
    }];
    
    [RACObserve(viewA, center) subscribeNext:^(id x) {
        
        DEBUGLog(@"RACObserveviewA==%@",x);
    }];
    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        DEBUGLog(@"按钮被点击了");
        // 创建第二个控制器
        ViewControllerB *twoVc = [[ViewControllerB alloc] init];
        
        // 设置代理信号
        twoVc.delegateSignal = [RACSubject subject];
        
        // 订阅代理信号
        [twoVc.delegateSignal subscribeNext:^(id x) {
            
            DEBUGLog(@"点击了通知按钮==%@",twoVc.signalstr);
        }];
        // 跳转到第二个控制器
        [self presentViewController:twoVc animated:YES completion:nil];

        [_textField resignFirstResponder];
//        viewA.frame = CGRectMake(250, 64+10+10, 150, 150);
    }];
    
    // 只要文本框文字改变，就会修改label的文字
    RAC(label,text) = _textField.rac_textSignal;
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        DEBUGLog(@"键盘弹出%@",x);
    }];
    
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        DEBUGLog(@"键盘隐藏%@",x);
    }];
    
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        DEBUGLog(@"文字改变了%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    

}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    DEBUGLog(@"更新UI%@  %@",data,data1);
}

-(void)senvenTest
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
