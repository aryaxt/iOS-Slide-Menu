//
//  SlideNavigationController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
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

#import "SlideNavigationController.h"

@interface SlideNavigationController()
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UIView *menuRevealFadeAnimationView;
@property (nonatomic, assign) CGPoint draggingPoint;
@end

@implementation SlideNavigationController

#define MENU_SLIDE_ANIMATION_DURATION .3
#define MENU_QUICK_SLIDE_ANIMATION_DURATION .18
#define MENU_IMAGE @"menu-button"
#define MENU_SHADOW_RADIUS 10
#define MENU_SHADOW_OPACITY 1
#define MENU_DEFAULT_SLIDE_OFFSET 60
#define MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION 1200
#define MENU_REVEAL_ANIMATION_DEFAULT_SLIDE_MOVEMENT 100
#define MENU_REVEAL_ANIMATION_DEFAULT_FADE_MAXIMUM_ALPHA .9

static SlideNavigationController *singletonInstance;

#pragma mark - Initialization -

+ (SlideNavigationController *)sharedInstance
{
	return singletonInstance;
}

- (id)init
{
	if (self = [super init])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	if (self = [super initWithRootViewController:rootViewController])
	{
		[self setup];
	}
	
	return self;
}

- (void)setup
{
	self.menuRevealAnimationSlideMovement = MENU_REVEAL_ANIMATION_DEFAULT_SLIDE_MOVEMENT;
	self.menuRevealAnimationFadeMaximumAlpha = MENU_REVEAL_ANIMATION_DEFAULT_FADE_MAXIMUM_ALPHA;
	self.menuRevealAnimation = MenuRevealAnimationSlideAndFade;
	self.landscapeSlideOffset = MENU_DEFAULT_SLIDE_OFFSET;
	self.portraitSlideOffset = MENU_DEFAULT_SLIDE_OFFSET;
	self.avoidSwitchingToSameClassViewController = YES;
	singletonInstance = self;
	self.delegate = self;
	
	self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	self.view.layer.shadowRadius = MENU_SHADOW_RADIUS;
	self.view.layer.shadowOpacity = MENU_SHADOW_OPACITY;
	self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
	self.view.layer.shouldRasterize = YES;
	self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
	
	[self setEnableSwipeGesture:YES];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	// Avoid an ugnly shadow in background while rotating
	self.view.layer.shadowOpacity = 0;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	CGAffineTransform transform = self.view.transform;
	self.leftMenu.view.transform = transform;
	self.rightMenu.view.transform = transform;
	
	CGRect rect = self.view.frame;
	self.leftMenu.view.frame = rect;
	self.rightMenu.view.frame = rect;
	self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
	
	// we set shadowOpacity to 0 in willRotateToInterfaceOrientation, after the rotation we want to add the shadow back
	self.view.layer.shadowOpacity = MENU_SHADOW_OPACITY;
}

#pragma mark - Public Methods -

- (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion
{
	if (self.avoidSwitchingToSameClassViewController && [self.topViewController isKindOfClass:viewController.class])
	{
		[self closeMenuWithCompletion:completion];
		return;
	}
	
	if ([self isMenuOpen])
	{
		[UIView animateWithDuration:MENU_SLIDE_ANIMATION_DURATION
							  delay:0
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
			CGFloat width = self.horizontalSize;
			CGFloat moveLocation = (self.horizontalLocation> 0) ? width : -1*width;
			[self moveHorizontallyToLocation:moveLocation];
		} completion:^(BOOL finished) {
			
			[super popToRootViewControllerAnimated:NO];
			[super pushViewController:viewController animated:NO];
			
			[self closeMenuWithCompletion:^{
				if (completion)
					completion();
			}];
		}];
	}
	else
	{
		[super popToRootViewControllerAnimated:NO];
		[super pushViewController:viewController animated:YES];
		
		if (completion)
			completion();
	}
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super popToRootViewControllerAnimated:animated];
		}];
	}
	else
	{
		return [super popToRootViewControllerAnimated:animated];
	}
	
	return nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super pushViewController:viewController animated:animated];
		}];
	}
	else
	{
		[super pushViewController:viewController animated:animated];
	}
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super popToViewController:viewController animated:animated];
		}];
	}
	else
	{
		return [super popToViewController:viewController animated:animated];
	}
	
	return nil;
}

#pragma mark - Private Methods -

- (UIBarButtonItem *)barButtonItemForMenu:(Menu)menu
{
	SEL selector = (menu == MenuLeft) ? @selector(leftMenuSelected:) : @selector(righttMenuSelected:);
	UIBarButtonItem *customButton = (menu == MenuLeft) ? self.leftbarButtonItem : self.rightBarButtonItem;
	
	if (customButton)
	{
		customButton.action = selector;
		customButton.target = self;
		return customButton;
	}
	else
	{
		UIImage *image = [UIImage imageNamed:MENU_IMAGE];
        return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];
	}
}

- (BOOL)isMenuOpen
{
	return (self.horizontalLocation == 0) ? NO : YES;
}

- (BOOL)shouldDisplayMenu:(Menu)menu forViewController:(UIViewController *)vc
{
	if (menu == MenuRight)
	{
		if ([vc respondsToSelector:@selector(slideNavigationControllerShouldDisplayRightMenu)] &&
			[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayRightMenu])
		{
			return YES;
		}
	}
	if (menu == MenuLeft)
	{
		if ([vc respondsToSelector:@selector(slideNavigationControllerShouldDisplayLeftMenu)] &&
			[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayLeftMenu])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)openMenu:(Menu)menu withDuration:(float)duration andCompletion:(void (^)())completion
{
	[self.topViewController.view addGestureRecognizer:self.tapRecognizer];
	
	[self prepareMenuForReveal:menu];
	
	[UIView animateWithDuration:duration
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 CGRect rect = self.view.frame;
						 CGFloat width = self.horizontalSize;
						 rect.origin.x = (menu == MenuLeft) ? (width - self.slideOffset) : ((width - self.slideOffset )* -1);
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
}

- (void)openMenu:(Menu)menu withCompletion:(void (^)())completion
{
	[self openMenu:menu withDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

- (void)closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion
{
	[self.topViewController.view removeGestureRecognizer:self.tapRecognizer];
	
	[UIView animateWithDuration:duration
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = 0;
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
}

- (void)closeMenuWithCompletion:(void (^)())completion
{
	[self closeMenuWithDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

- (void)moveHorizontallyToLocation:(CGFloat)location
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;
	Menu menu = (self.horizontalLocation >= 0 && location >= 0) ? MenuLeft : MenuRight;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		rect.origin.x = 0;
		rect.origin.y = (orientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
	}
	else
	{
		rect.origin.x = (orientation == UIInterfaceOrientationPortrait) ? location : location*-1;
		rect.origin.y = 0;
	}
	
	self.view.frame = rect;
	[self updateMenuAnimation:menu];
}

- (void)updateMenuAnimation:(Menu)menu
{
	if (self.menuRevealAnimation == MenuRevealAnimationNone)
		return;
	
	UIViewController *menuViewController = (menu == MenuLeft) ? self.leftMenu : self.rightMenu;
	
	CGFloat progress = (menu == MenuLeft)
		? (self.horizontalLocation / self.maxXForDragging)
		: (self.horizontalLocation / self.minXForDragging);

	if (self.menuRevealAnimation == MenuRevealAnimationFade || self.menuRevealAnimation == MenuRevealAnimationSlideAndFade)
	{
		[menuViewController.view addSubview:self.menuRevealFadeAnimationView];
		self.menuRevealFadeAnimationView.alpha = self.menuRevealAnimationFadeMaximumAlpha - (self.menuRevealAnimationFadeMaximumAlpha *progress);
	}
	
	if (self.menuRevealAnimation == MenuRevealAnimationSlide || self.menuRevealAnimation == MenuRevealAnimationSlideAndFade)
	{
		NSInteger location = (menu == MenuLeft)
			? (self.menuRevealAnimationSlideMovement * -1) + (self.menuRevealAnimationSlideMovement * progress)
			: (self.menuRevealAnimationSlideMovement * (1-progress));
		
		if (menu == MenuLeft)
			location = (location > 0) ? 0 : location;
		
		if (menu == MenuRight)
			location = (location < 0) ? 0 : location;
		
		CGRect rect = menuViewController.view.frame;
		
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		{
			rect.origin.y = (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
		}
		else
		{
			rect.origin.x = (self.interfaceOrientation == UIInterfaceOrientationPortrait) ? location : location*-1;
		}
		
		menuViewController.view.frame = rect;
	}
}

- (void)prepareMenuForReveal:(Menu)menu
{
	UIViewController *menuViewController = (menu == MenuLeft) ? self.leftMenu : self.rightMenu;
	UIViewController *removingMenuViewController = (menu == MenuLeft) ? self.rightMenu : self.leftMenu;
	
	// If already has been added to the view (has superview) it means it has been initialized so avoid reinitializing
	if (menuViewController.view.superview)
		return;
	
	if (self.menuRevealAnimation == MenuRevealAnimationFade || self.menuRevealAnimation == MenuRevealAnimationSlideAndFade)
	{
		menuViewController.view.alpha = self.menuRevealAnimationFadeMaximumAlpha;
		self.menuRevealFadeAnimationView.frame = menuViewController.view.bounds;
	}
	
	if (self.menuRevealAnimation == MenuRevealAnimationSlide || self.menuRevealAnimation == MenuRevealAnimationSlideAndFade)
	{
		CGRect rect = menuViewController.view.frame;
		
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		{
			if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
			{
				rect.origin.y = (menu == MenuLeft) ? self.menuRevealAnimationSlideMovement*-1 : self.menuRevealAnimationSlideMovement;
			}
			else
			{
				rect.origin.y = (menu == MenuRight) ? self.menuRevealAnimationSlideMovement*-1 : self.menuRevealAnimationSlideMovement;
			}
		}
		else
		{
			if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
			{
				rect.origin.x = (menu == MenuLeft) ? self.menuRevealAnimationSlideMovement*-1 : self.menuRevealAnimationSlideMovement;
			}
			else
			{
				rect.origin.x = (menu == MenuRight) ? self.menuRevealAnimationSlideMovement*-1 : self.menuRevealAnimationSlideMovement;
			}
		}
		
		menuViewController.view.frame = rect;
	}
	
	[removingMenuViewController.view removeFromSuperview];
	[self.view.window insertSubview:menuViewController.view atIndex:0];
}

- (CGFloat)horizontalLocation
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		return (orientation == UIInterfaceOrientationLandscapeRight)
			? rect.origin.y
			: rect.origin.y*-1;
	}
	else
	{
		return (orientation == UIInterfaceOrientationPortrait)
			? rect.origin.x
			: rect.origin.x*-1;
	}
}

- (CGFloat)horizontalSize
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		return rect.size.height;
	}
	else
	{
		return rect.size.width;
	}
}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	if ([self shouldDisplayMenu:MenuLeft forViewController:viewController])
		viewController.navigationItem.leftBarButtonItem = [self barButtonItemForMenu:MenuLeft];
	
	if ([self shouldDisplayMenu:MenuRight forViewController:viewController])
		viewController.navigationItem.rightBarButtonItem = [self barButtonItemForMenu:MenuRight];
}

- (CGFloat)slideOffset
{
	return (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		? self.landscapeSlideOffset
		: self.portraitSlideOffset;
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

#pragma mark - Gesture Recognizing -

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
	[self closeMenuWithCompletion:nil];
}

- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer
{
	CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
    CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
	NSInteger movement = translation.x - self.draggingPoint.x;
	
	[self prepareMenuForReveal:(self.horizontalLocation > 0 || (self.horizontalLocation == 0 && translation.x > 0) ) ? MenuLeft : MenuRight];
	
    if (aPanRecognizer.state == UIGestureRecognizerStateBegan)
	{
		self.draggingPoint = translation;
    }
	else if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
	{
		NSInteger newHorizontalLocation = [self horizontalLocation];
		newHorizontalLocation += movement;
		
		if (newHorizontalLocation >= self.minXForDragging && newHorizontalLocation <= self.maxXForDragging)
			[self moveHorizontallyToLocation:newHorizontalLocation];
		
		self.draggingPoint = translation;
	}
	else if (aPanRecognizer.state == UIGestureRecognizerStateEnded)
	{
        NSInteger currentX = [self horizontalLocation];
		NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
		NSInteger positiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x * -1;
		
		// If the speed is high enough follow direction
		if (positiveVelocity >= MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION)
		{
			Menu menu = (velocity.x > 0) ? MenuLeft : MenuRight;
			
			// Moving Right
			if (velocity.x > 0)
			{
				if (currentX > 0)
				{
					if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
						[self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
				else
				{
					[self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
			}
			// Moving Left
			else
			{
				if (currentX > 0)
				{
					[self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
				else
				{
					if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
						[self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
			}
		}
		else
		{
			if (currentXOffset < (self.horizontalSize - self.slideOffset)/2)
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
		return (self.horizontalSize - self.slideOffset)  * -1;
	}
	
	return 0;
}

- (NSInteger)maxXForDragging
{
	if ([self shouldDisplayMenu:MenuLeft forViewController:self.topViewController])
	{
		return self.horizontalSize - self.slideOffset;
	}
	
	return 0;
}

#pragma mark - Setter & Getter -

- (UITapGestureRecognizer *)tapRecognizer
{
	if (!_tapRecognizer)
	{
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
	}
	
	return _tapRecognizer;
}

- (UIPanGestureRecognizer *)panRecognizer
{
	if (!_panRecognizer)
	{
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
	}
	
	return _panRecognizer;
}

- (void)setEnableSwipeGesture:(BOOL)markEnableSwipeGesture
{
	_enableSwipeGesture = markEnableSwipeGesture;
	
	if (_enableSwipeGesture)
	{
		[self.view addGestureRecognizer:self.panRecognizer];
	}
	else
	{
		[self.view removeGestureRecognizer:self.panRecognizer];
	}
}

- (UIView *)menuRevealFadeAnimationView
{
	if (!_menuRevealFadeAnimationView)
	{
		_menuRevealFadeAnimationView = [[UIView alloc] init];
		_menuRevealFadeAnimationView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_menuRevealFadeAnimationView.backgroundColor = [UIColor blackColor];
		_menuRevealFadeAnimationView.frame = self.view.bounds;
	}
	
	return _menuRevealFadeAnimationView;
}

- (void)setMenuRevealAnimationFadeColor:(UIColor *)menuRevealAnimationFadeColor
{
	_menuRevealAnimationFadeColor = menuRevealAnimationFadeColor;
	self.menuRevealFadeAnimationView.backgroundColor = menuRevealAnimationFadeColor;
}

@end
