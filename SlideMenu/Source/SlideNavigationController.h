//
//  SlideNavigationController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SlideNavigationControllerDelegate <NSObject>
@optional
- (BOOL)slideNavigationControllerShouldDisplayRightMenu;
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu;
@end

typedef  enum{
	MenuLeft,
	MenuRight,
}Menu;

@interface SlideNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL avoidSwitchingToSameClassViewController;
@property (nonatomic, strong) UIViewController *righMenu;
@property (nonatomic, strong) UIViewController *leftMenu;
@property (nonatomic, strong) UIBarButtonItem *leftbarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

+ (SlideNavigationController *)sharedInstance;
- (void)switchViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;

@end
