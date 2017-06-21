//
//  ViewControllerB.h
//  RAC_objective_C
//
//  Created by doublej on 2017/6/20.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewControllerB : UIViewController

@property (nonatomic, strong) RACSubject *delegateSignal;
@property (nonatomic, strong) NSString *signalstr;
@property (nonatomic, assign) int signali;

@end
