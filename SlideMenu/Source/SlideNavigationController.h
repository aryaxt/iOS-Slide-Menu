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
- (BOOL)slideNavigationControllerShouldSisplayRightMenu;
- (BOOL)slideNavigationControllerShouldSisplayLeftMenu;
@end

typedef  enum{
	SideLeft,
	SideRight,
}Side;

@interface SlideNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *righMenu;
@property (nonatomic, strong) UIViewController *leftMenu;

+ (SlideNavigationController *)sharedInstance;
- (void)switchViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;

@end
