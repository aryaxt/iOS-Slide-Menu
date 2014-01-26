//
//  SlideNavigationContorllerAnimationSlideAndFade.m
//  SlideMenu
//
//  Created by Aryan Gh on 1/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorFade.h"

@interface SlideNavigationContorllerAnimatorSlideAndFade()
@property (nonatomic, strong) SlideNavigationContorllerAnimatorFade *fadeAnimation;
@property (nonatomic, strong) SlideNavigationContorllerAnimatorSlide *slideAnimation;
@end

@implementation SlideNavigationContorllerAnimatorSlideAndFade

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
		self.fadeAnimation = [[SlideNavigationContorllerAnimatorFade alloc] initWithMaximumFadeAlpha:maximumFadeAlpha andFadeColor:fadeColor];
		self.slideAnimation = [[SlideNavigationContorllerAnimatorSlide alloc] initWithSlideMovement:slideMovement];
	}
	
	return self;
}

#pragma mark - SlideNavigationContorllerAnimation Methods -

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
