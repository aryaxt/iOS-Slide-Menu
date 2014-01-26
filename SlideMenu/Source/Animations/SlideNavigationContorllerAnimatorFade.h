//
//  SlideNavigationContorllerAnimationFade.h
//  SlideMenu
//
//  Created by Aryan Gh on 1/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideNavigationContorllerAnimator.h"

@interface SlideNavigationContorllerAnimatorFade : NSObject <SlideNavigationContorllerAnimator>

@property (nonatomic, assign) CGFloat maximumFadeAlpha;
@property (nonatomic, strong) UIColor *fadeColor;

- (id)initWithMaximumFadeAlpha:(CGFloat)maximumFadeAlpha andFadeColor:(UIColor *)fadeColor;

@end
