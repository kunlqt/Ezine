//
//  UIViewController+MJPopupViewController.h
//  MJModalViewController
//
//  Created by Martin Juhasz on 11.05.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFKPageFlipper.h"
typedef enum {
    MJPopupViewAnimationSlideBottomTop = 1,
    MJPopupViewAnimationSlideRightLeft,
    MJPopupViewAnimationSlideLeftRight,
    MJPopupViewAnimationSlideBottomBottom,
    MJPopupViewAnimationFade
} MJPopupViewAnimation;

@interface UIViewController (MJPopupViewController)

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType;
- (void)presentPopupViewController2:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType;
- (void)dismissPopupViewControllerWithanimationType:(MJPopupViewAnimation)animationType;
#pragma Mark=====Ok======Try========
- (void)presentPopupViewControllerParent:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType;
- (void)dismissPopupViewControllerWithanimationTypeInParent:(MJPopupViewAnimation)animationType;
- (void)dismissPopupViewControllerWithanimation:(id)sender;

@end