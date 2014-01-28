//
//  SlideNavigationContorllerAnimationFade.m
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

#import "SlideNavigationContorllerAnimatorFade.h"

@interface SlideNavigationContorllerAnimatorFade()
@property (nonatomic, strong) UIView *fadeAnimationView;
@end

@implementation SlideNavigationContorllerAnimatorFade

#pragma mark - Initialization -

- (id)init
{
	if (self = [self initWithMaximumFadeAlpha:.8 andFadeColor:[UIColor blackColor]])
	{
	}
	
	return self;
}

- (id)initWithMaximumFadeAlpha:(CGFloat)maximumFadeAlpha andFadeColor:(UIColor *)fadeColor
{
	if (self = [super init])
	{
		self.maximumFadeAlpha = maximumFadeAlpha;
		self.fadeColor = fadeColor;
		
		self.fadeAnimationView = [[UIView alloc] init];
		self.fadeAnimationView.backgroundColor = self.fadeColor;
	}
	
	return self;
}

#pragma mark - SlideNavigationContorllerAnimation Methods -

- (void)prepareMenuForAnimation:(Menu)menu
{
	UIViewController *menuViewController = (menu == MenuLeft)
		? [SlideNavigationController sharedInstance].leftMenu
		: [SlideNavigationController sharedInstance].rightMenu;
	
	self.fadeAnimationView.alpha = self.maximumFadeAlpha;
	self.fadeAnimationView.frame = menuViewController.view.bounds;
}

- (void)animateMenu:(Menu)menu withProgress:(CGFloat)progress
{
	UIViewController *menuViewController = (menu == MenuLeft)
		? [SlideNavigationController sharedInstance].leftMenu
		: [SlideNavigationController sharedInstance].rightMenu;
	
	self.fadeAnimationView.frame = menuViewController.view.bounds;
	[menuViewController.view addSubview:self.fadeAnimationView];
	self.fadeAnimationView.alpha = self.maximumFadeAlpha - (self.maximumFadeAlpha *progress);
}

- (void)clear
{
	[self.fadeAnimationView removeFromSuperview];
}

@end
