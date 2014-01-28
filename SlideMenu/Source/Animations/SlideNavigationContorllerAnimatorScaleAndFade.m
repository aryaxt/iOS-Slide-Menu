//
//  SlideNavigationContorllerAnimationScaleAndFade.m
//  SlideMenu
//
//  Created by Aryan Gh on 1/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorScale.h"

@interface SlideNavigationContorllerAnimatorScaleAndFade()
@property (nonatomic, strong) SlideNavigationContorllerAnimatorFade *fadeAnimation;
@property (nonatomic, strong) SlideNavigationContorllerAnimatorScale *scaleAnimation;
@end

@implementation SlideNavigationContorllerAnimatorScaleAndFade

#pragma mark - Initialization -

- (id)init
{
	if (self = [self initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andMinimumScale:.8])
	{
	}
	
	return self;
}

- (id)initWithMaximumFadeAlpha:(CGFloat)maximumFadeAlpha fadeColor:(UIColor *)fadeColor andMinimumScale:(CGFloat)minimumScale
{
	if (self = [super init])
	{
		self.fadeAnimation = [[SlideNavigationContorllerAnimatorFade alloc] initWithMaximumFadeAlpha:maximumFadeAlpha andFadeColor:fadeColor];
		self.scaleAnimation = [[SlideNavigationContorllerAnimatorScale alloc] initWithMinimumScale:minimumScale];
	}
	
	return self;
}

#pragma mark - SlideNavigationContorllerAnimation Methods -

- (void)prepareMenuForAnimation:(Menu)menu
{
	[self.fadeAnimation prepareMenuForAnimation:menu];
	[self.scaleAnimation prepareMenuForAnimation:menu];
}

- (void)animateMenu:(Menu)menu withProgress:(CGFloat)progress
{
	[self.fadeAnimation animateMenu:menu withProgress:progress];
	[self.scaleAnimation animateMenu:menu withProgress:progress];
}

- (void)clear
{
	[self.fadeAnimation clear];
	[self.scaleAnimation clear];
}

@end
