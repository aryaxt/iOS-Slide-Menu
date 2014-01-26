//
//  SlideNavigationContorllerAnimationScaleAndFade.h
//  SlideMenu
//
//  Created by Aryan Gh on 1/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideNavigationContorllerAnimator.h"

@interface SlideNavigationContorllerAnimatorScaleAndFade : NSObject <SlideNavigationContorllerAnimator>

- (id)initWithMaximumFadeAlpha:(CGFloat)maximumFadeAlpha fadeColor:(UIColor *)fadeColor andMinimumScale:(CGFloat)minimumScale;

@end
