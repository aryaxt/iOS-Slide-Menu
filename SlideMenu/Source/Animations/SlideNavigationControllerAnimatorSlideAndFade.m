//
//  SlideNavigationControllerAnimationSlideAndFade.m
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

#import "SlideNavigationControllerAnimatorSlideAndFade.h"
#import "SlideNavigationControllerAnimatorSlide.h"
#import "SlideNavigationControllerAnimatorFade.h"

@interface SlideNavigationControllerAnimatorSlideAndFade()
@property (nonatomic, strong) SlideNavigationControllerAnimatorFade *fadeAnimation;
@property (nonatomic, strong) SlideNavigationControllerAnimatorSlide *slideAnimation;
@end

@implementation SlideNavigationControllerAnimatorSlideAndFade

#pragma mark - Initialization -

- (id)init
{
	if (self = [self initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100])
	{
	}
	
	return self;
}

- (id)initWithMaximumFadeAlpha:(CGFloat)maximumFadeAlpha fadeColor:(UIColor *)fadeColor andSlideMovement:(CGFloat)slideMovement
{
	if (self = [super init])
	{
		self.fadeAnimation = [[SlideNavigationControllerAnimatorFade alloc] initWithMaximumFadeAlpha:maximumFadeAlpha andFadeColor:fadeColor];
		self.slideAnimation = [[SlideNavigationControllerAnimatorSlide alloc] initWithSlideMovement:slideMovement];
	}
	
	return self;
}

#pragma mark - SlideNavigationControllerAnimation Methods -

- (void)prepareMenuForAnimation:(Menu)menu
{
	[self.fadeAnimation prepareMenuForAnimation:menu];
	[self.slideAnimation prepareMenuForAnimation:menu];
}

- (void)animateMenu:(Menu)menu withProgress:(CGFloat)progress
{
	[self.fadeAnimation animateMenu:menu withProgress:progress];
	[self.slideAnimation animateMenu:menu withProgress:progress];
}

- (void)clear
{
	[self.fadeAnimation clear];
	[self.slideAnimation clear];
}

@end
