//
//  SVProgressHUDY.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUDY
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>
 

enum {
    SVProgressHUDYMaskTypeNone = 1, // allow user interactions while HUD is displayed
    SVProgressHUDYMaskTypeClear, // don't allow
    SVProgressHUDYMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    SVProgressHUDYMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger SVProgressHUDYMaskType;

@interface SVProgressHUDY : UIView
@property (nonatomic, strong) UIView *hudViewa;
+ (void)show;
+ (void)show2;
+ (void)show3;
+ (void)dismiss2;
+ (void)dismiss3;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDYMaskType)maskType;
+ (void)showWithMaskType:(SVProgressHUDYMaskType)maskType;

+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation
+ (void)dismissWithSuccess:(NSString*)successString; // also displays the success icon image
+ (void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString; // also displays the error icon image
+ (void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

@end
