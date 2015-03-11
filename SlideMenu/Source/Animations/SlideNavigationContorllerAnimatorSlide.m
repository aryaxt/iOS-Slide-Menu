//
//  SlideNavigationContorllerAnimationSlide.m
//  SlideMenu
//
//  Created by Aryan Gh on 1/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//
// https://github.com/aryaxt/iOS-Slide-Menu
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SlideNavigationContorllerAnimatorSlide.h"

@implementation SlideNavigationContorllerAnimatorSlide

#pragma mark - Initialization -

- (id)init
{
    if (self = [self initWithSlideMovement:100])
    {
    }
    
    return self;
}

- (id)initWithSlideMovement:(CGFloat)slideMovement
{
	if (self = [super init])
	{
		self.slideMovement = slideMovement;
	}
	
	return self;
}

#pragma mark - SlideNavigationContorllerAnimation Methods -

- (void)prepareMenuForAnimation:(Menu)menu
{
	UIViewController *menuViewController = (menu == MenuLeft)
        ? [SlideNavigationController sharedInstance].leftMenu
        : [SlideNavigationController sharedInstance].rightMenu;
	
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	CGRect rect = menuViewController.view.frame;
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        rect.origin.x = (menu == MenuLeft) ? self.slideMovement*-1 : self.slideMovement;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            if (orientation == UIDeviceOrientationLandscapeRight)
            {
                rect.origin.y = (menu == MenuLeft) ? self.slideMovement*-1 : self.slideMovement;
            }
            else
            {
                rect.origin.y = (menu == MenuRight) ? self.slideMovement*-1 : self.slideMovement;
            }
        }
        else
        {
            if (orientation == UIDeviceOrientationPortrait)
            {
                rect.origin.x = (menu == MenuLeft) ? self.slideMovement*-1 : self.slideMovement;
            }
            else
            {
                rect.origin.x = (menu == MenuRight) ? self.slideMovement*-1 : self.slideMovement;
            }
        }
    }
    
    menuViewController.view.frame = rect;
}

- (void)animateMenu:(Menu)menu withProgress:(CGFloat)progress
{
    UIViewController *menuViewController = (menu == MenuLeft)
        ? [SlideNavigationController sharedInstance].leftMenu
        : [SlideNavigationController sharedInstance].rightMenu;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    NSInteger location = (menu == MenuLeft)
        ? (self.slideMovement * -1) + (self.slideMovement * progress)
        : (self.slideMovement * (1-progress));
    
    if (menu == MenuLeft)
        location = (location > 0) ? 0 : location;
    
    if (menu == MenuRight)
        location = (location < 0) ? 0 : location;
    
    CGRect rect = menuViewController.view.frame;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        rect.origin.x = location;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            rect.origin.y = (orientation == UIDeviceOrientationLandscapeRight) ? location : location*-1;
        }
        else
        {
            rect.origin.x = (orientation == UIDeviceOrientationPortrait) ? location : location*-1;
        }
    }
    
    menuViewController.view.frame = rect;
}

- (void)clear
{
    [self clearMenu:MenuLeft];
    [self clearMenu:MenuRight];
}

#pragma mark - Private Method -

- (void)clearMenu:(Menu)menu
{
    UIViewController *menuViewController = (menu == MenuLeft)
    ? [SlideNavigationController sharedInstance].leftMenu
    : [SlideNavigationController sharedInstance].rightMenu;
    
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	
    CGRect rect = menuViewController.view.frame;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        rect.origin.x = 0;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            rect.origin.y = 0;
        }
        else
        {
            rect.origin.x = 0;
        }
    }
    
    menuViewController.view.frame = rect;
}

@end
