//
//  ViewController.h
//  RAC_objective_C
//
//  Created by doublej on 2017/6/19.
//  Copyright © 2017年 doublej. All rights reserved.
//
#ifdef DEBUG
#   define DEBUGLog(fmt, ...) NSLog((@"%s [%d-行] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DEBUGLog(...)
#endif

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

