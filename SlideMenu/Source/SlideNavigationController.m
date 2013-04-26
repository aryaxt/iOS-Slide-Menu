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
	singletonInstance = self;
	self.delegate = self;
}

- (id)init
{
	if (self = [super init])
	{
		singletonInstance = self;
	}
	
	return self;
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
			
			[UIView animateWithDuration:MENU_SLIDE_ANIMATION_DURATION animations:^{
				rect.origin.x = 0;
				self.view.frame = rect;
				
				[self popToRootViewControllerAnimated:NO];
				[self pushViewController:viewController animated:NO];
				
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
	[self.righMenu.view removeFromSuperview];
	[self.view.window insertSubview:self.leftMenu.view atIndex:0];
	
	[UIView animateWithDuration:MENU_SLIDE_ANIMATION_DURATION
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = (self.isMenuOpen) ? 0 : rect.size.width - MENU_OFFSET;
						 self.view.frame = rect;
						 
	 }];
}

- (void)righttMenuSelected:(id)sender
{
	[self.leftMenu.view removeFromSuperview];
	[self.view.window insertSubview:self.righMenu.view atIndex:0];
	
	[UIView animateWithDuration:MENU_SLIDE_ANIMATION_DURATION
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = (self.isMenuOpen) ? 0 : (rect.size.width - MENU_OFFSET )* -1;
						 self.view.frame = rect;
						 
					 }];
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{

}

#pragma mark - Setter & Getter -

- (UITapGestureRecognizer *)tapRecognizer
{
	if (tapRecognizer)
	{
		tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
	}
	
	return tapRecognizer;
}

@end
