//
//  SlideNavigationContorllerAnimationScale.m
//  SlideMenu
//
//  Created by Aryan Gh on 1/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "SlideNavigationContorllerAnimatorScale.h"

@implementation SlideNavigationContorllerAnimatorScale

#pragma mark - Initialization -

- (id)init
{
	if (self = [self initWithMinimumScale:.8])
	{
	}
	
	return self;
}

- (id)initWithMinimumScale:(CGFloat)minimumScale
{
	if (self = [super init])
	{
		self.minimumScale = minimumScale;
	}
	
	return self;
}

#pragma mark - SlideNavigationContorllerAnimation Methods -

- (void)prepareMenuForAnimation:(Menu)menu
{
	UIViewController *menuViewController = (menu == MenuLeft)
		? [SlideNavigationController sharedInstance].leftMenu
		: [SlideNavigationController sharedInstance].rightMenu;
	
	menuViewController.view.transform = CGAffineTransformScale([SlideNavigationController sharedInstance].view.transform, self.minimumScale, self.minimumScale);
}

- (void)animateMenu:(Menu)menu withProgress:(CGFloat)progress
{
	UIViewController *menuViewController = (menu == MenuLeft)
		? [SlideNavigationController sharedInstance].leftMenu
		: [SlideNavigationController sharedInstance].rightMenu;
	
	CGFloat scale = MIN(1, (1-self.minimumScale) *progress + self.minimumScale);
	menuViewController.view.transform = CGAffineTransformScale([SlideNavigationController sharedInstance].view.transform, scale, scale);
}

- (void)clear
{
	[SlideNavigationController sharedInstance].leftMenu.view.transform = CGAffineTransformScale([SlideNavigationController sharedInstance].view.transform, 1, 1);
	[SlideNavigationController sharedInstance].rightMenu.view.transform = CGAffineTransformScale([SlideNavigationController sharedInstance].view.transform, 1, 1);
}

@end
