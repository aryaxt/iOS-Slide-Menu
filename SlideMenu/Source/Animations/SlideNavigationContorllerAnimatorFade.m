//
//  SlideNavigationContorllerAnimationFade.m
//  SlideMenu
//
//  Created by Aryan Gh on 1/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

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
