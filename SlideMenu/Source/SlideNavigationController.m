//
//  SlideNavigationController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "SlideNavigationController.h"

@interface SlideNavigationController()
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@end

@implementation SlideNavigationController
@synthesize righMenu;
@synthesize leftMenu;
@synthesize tapRecognizer;

#define MENU_OFFSET 60
#define MENU_SLIDE_ANIMATION_DURATION 0.3

static SlideNavigationController *singletonInstance;

#pragma mark - Initialization -

+ (SlideNavigationController *)sharedInstance
{
	return singletonInstance;
}

- (void)awakeFromNib
{
	[self setup];
}

- (id)init
{
	if (self = [super init])
	{
		[self setup];
	}
	
	return self;
}

- (void)setup
{
	singletonInstance = self;
	self.delegate = self;
	
	self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	self.view.layer.shadowRadius = 10;
	self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
	self.view.layer.shadowOpacity = 1;
	self.view.layer.shouldRasterize = YES;
	self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - Public Methods -

- (void)switchViewController:(UIViewController *)viewController withCompletion:(void (^)())completion
{
	__block CGRect rect = self.view.frame;
	
	if ([self isMenuOpen])
	{
		[UIView animateWithDuration:MENU_SLIDE_ANIMATION_DURATION animations:^{
			rect.origin.x = (rect.origin.x > 0) ? rect.size.width : -1*rect.size.width;
			self.view.frame = rect;
		} completion:^(BOOL finished) {
			
			[self popToRootViewControllerAnimated:NO];
			[self pushViewController:viewController animated:NO];
			
			[self closeMenuWithCompletion:^{
				if (completion)
					completion();
			}];
		}];
	}
	else
	{
		[self popToRootViewControllerAnimated:NO];
		[self pushViewController:viewController animated:YES];
		
		if (completion)
			completion();
	}
}

#pragma mark - Private Methods -

- (UIBarButtonItem *)leftBarButton
{
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
														 target:self
														 action:@selector(leftMenuSelected:)];
}

- (UIBarButtonItem *)rightBarButton
{
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
														 target:self
														 action:@selector(righttMenuSelected:)];
}

- (BOOL)isMenuOpen
{
	return (self.view.frame.origin.x == 0) ? NO : YES;
}

- (BOOL)shouldDisplayRightMenuButtonForViewController:(UIViewController *)vc
{
	if ([vc respondsToSelector:@selector(slideNavigationControllerShouldSisplayRightMenu)] &&
		[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldSisplayRightMenu])
	{
		return YES;
	}

	return NO;
}

- (BOOL)shouldDisplayLeftMenuButtonForViewController:(UIViewController *)vc
{
	if ([vc respondsToSelector:@selector(slideNavigationControllerShouldSisplayLeftMenu)] &&
		[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldSisplayLeftMenu])
	{
		return YES;
	}
	
	return NO;
}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	if ([self shouldDisplayLeftMenuButtonForViewController:viewController])
		viewController.navigationItem.leftBarButtonItem = [self leftBarButton];
	else
		viewController.navigationItem.leftBarButtonItem = nil;
	
	if ([self shouldDisplayRightMenuButtonForViewController:viewController])
		viewController.navigationItem.rightBarButtonItem = [self rightBarButton];
	else
		viewController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - IBActions -

- (void)leftMenuSelected:(id)sender
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:nil];
	else
		[self openMenu:MenuLeft withCompletion:nil];
		
}

- (void)righttMenuSelected:(id)sender
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:nil];
	else
		[self openMenu:MenuRight withCompletion:nil];
}

- (void)openMenu:(Menu)menu withCompletion:(void (^)())completion
{
	[self.topViewController.view addGestureRecognizer:self.tapRecognizer];
	
	if (menu == MenuLeft)
	{
		[self.righMenu.view removeFromSuperview];
		[self.view.window insertSubview:self.leftMenu.view atIndex:0];
	}
	else
	{
		[self.leftMenu.view removeFromSuperview];
		[self.view.window insertSubview:self.righMenu.view atIndex:0];
	}
	
	[UIView animateWithDuration:MENU_SLIDE_ANIMATION_DURATION
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = (menu == MenuLeft) ? (rect.size.width - MENU_OFFSET) : ((rect.size.width - MENU_OFFSET )* -1);
						 self.view.frame = rect;
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
}

- (void)closeMenuWithCompletion:(void (^)())completion
{
	[self.topViewController.view removeGestureRecognizer:self.tapRecognizer];
	
	[UIView animateWithDuration:MENU_SLIDE_ANIMATION_DURATION
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = 0;
						 self.view.frame = rect;
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
	[self closeMenuWithCompletion:nil];
}

#pragma mark - Setter & Getter -

- (UITapGestureRecognizer *)tapRecognizer
{
	if (!tapRecognizer)
	{
		tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
	}
	
	return tapRecognizer;
}

@end
