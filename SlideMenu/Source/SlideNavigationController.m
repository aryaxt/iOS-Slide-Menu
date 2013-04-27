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
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint draggingPoint;
@end

@implementation SlideNavigationController
@synthesize righMenu;
@synthesize leftMenu;
@synthesize tapRecognizer;
@synthesize panRecognizer;
@synthesize draggingPoint;

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
	
	[self.view addGestureRecognizer:self.panRecognizer];
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

- (BOOL)shouldDisplayMenu:(Menu)menu forViewController:(UIViewController *)vc
{
	if (menu == MenuRight)
	{
		if ([vc respondsToSelector:@selector(slideNavigationControllerShouldSisplayRightMenu)] &&
			[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldSisplayRightMenu])
		{
			return YES;
		}
	}
	if (menu == MenuLeft)
	{
		if ([vc respondsToSelector:@selector(slideNavigationControllerShouldSisplayLeftMenu)] &&
			[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldSisplayLeftMenu])
		{
			return YES;
		}
		
		return NO;
	}
	
	return NO;
}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	if ([self shouldDisplayMenu:MenuLeft forViewController:viewController])
		viewController.navigationItem.leftBarButtonItem = [self leftBarButton];
	else
		viewController.navigationItem.leftBarButtonItem = nil;
	
	if ([self shouldDisplayMenu:MenuRight forViewController:viewController])
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

#pragma mark - Gesture Recognizing -

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
	[self closeMenuWithCompletion:nil];
}

- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer
{
	static NSInteger velocityForFollowingDirection = 1000;
	
	CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
    CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
	
    if (aPanRecognizer.state == UIGestureRecognizerStateBegan)
	{
		self.draggingPoint = translation;
    }
	else if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
	{
		NSInteger movement = translation.x - self.draggingPoint.x;
		CGRect rect = self.view.frame;
		rect.origin.x += movement;
		
		if (rect.origin.x >= self.minXForDragging && rect.origin.x <= self.maxXForDragging)
		self.view.frame = rect;
		
		self.draggingPoint = translation;
	}
	else if (aPanRecognizer.state == UIGestureRecognizerStateEnded)
	{
        NSInteger currentX = self.view.frame.origin.x;
		NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
		NSInteger positiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x * -1;
		
		// If the speed is high enough follow direction
		if (positiveVelocity >= velocityForFollowingDirection)
		{
			// Moving Right
			if (velocity.x > 0)
			{
				if (currentX > 0)
				{
					[self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withCompletion:nil];
				}
				else
				{
					[self closeMenuWithCompletion:nil];
				}
			}
			// Moving Left
			else
			{
				if (currentX > 0)
				{
					[self closeMenuWithCompletion:nil];
				}
				else
				{
					[self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withCompletion:nil];
				}
			}
		}
		else
		{
			if (currentXOffset < self.view.frame.size.width/2)
				[self closeMenuWithCompletion:nil];
			else
				[self openMenu:(currentX > 0) ? MenuLeft : MenuRight withCompletion:nil];
		}
    }
}

- (NSInteger)minXForDragging
{
	if ([self shouldDisplayMenu:MenuRight forViewController:self.topViewController])
	{
		return (self.view.frame.size.width - MENU_OFFSET)  * -1;
	}
	
	return 0;
}

- (NSInteger)maxXForDragging
{
	if ([self shouldDisplayMenu:MenuLeft forViewController:self.topViewController])
	{
		return self.view.frame.size.width - MENU_OFFSET;
	}
	
	return 0;
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

- (UIPanGestureRecognizer *)panRecognizer
{
	if (!panRecognizer)
	{
		panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
	}
	
	return panRecognizer;
}

@end
