iOS-Slide-Menu [![Version](http://cocoapod-badges.herokuapp.com/v/iOS-Slide-Menu/badge.png)](http://cocoadocs.org/docsets/iOS-Slide-Menu)
---------

**NOTE: If your application supports both landscape and portrait and supports iOS versions below 8, use version 1.4.5**

iOS Slide Menu built on top of UINavigationController, with configurable buttons, reveal animations, and tap/swiper gesture recognizers.

- [Setup](https://github.com/aryaxt/iOS-Slide-Menu#setup)
- [Enable/Disable Left/Right Menu](https://github.com/aryaxt/iOS-Slide-Menu#configuring-left-and-right-menu-for-different-viewcontrollers)
- [Public Properties](https://github.com/aryaxt/iOS-Slide-Menu#public-properties)
- [Public Methods](https://github.com/aryaxt/iOS-Slide-Menu#public-methods)
- [Custom Animations](https://github.com/aryaxt/iOS-Slide-Menu#custom-animations)
- [Notifications](https://github.com/aryaxt/iOS-Slide-Menu#notifications)

![alt tag](https://raw.github.com/aryaxt/iOS-Slide-Menu/master/slideMenuAnimation.gif)

Version 1.4.5 Notes
---------
Enabling shouldRecognizeSimultaneouslyWithGestureRecognizer was causing issues, if you are seeing unexpected gesture behavior delete the pod and reinstall as that method has been removed

Version 1.4.0 Notes
---------
```switchToViewController:withCompletion:``` method has been deprecated. In order to get the exact same behavior use ```popToRootAndSwitchToViewController:withCompletion```

New features:
- Allows limiting pan gesture to the sides of the view
- Allows turning shadow on/off
- Allows turning slide-out animation on/off when switching between viewControllers
- Minor bug fixes

Version 1.3.0 Notes
---------
If you are updating from previous versions you'll get compile errors, due to changes to RevealAnimations.
Animation configuration is now handled differently, and is separated from the SlideNavigationController.
Please see bwlow for more information.

Setup
---------
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	LeftMenuViewController *leftMenu = [[LeftMenuViewController alloc] init];
        RightMenuViewController *rightMenu = [[RightMenuViewController alloc] init];
	
	[SlideNavigationController sharedInstance].rightMenu = rightMenu;
	[SlideNavigationController sharedInstance].leftMenu = leftMenu;
	
    // Override point for customization after application launch.
    return YES;
}
```
Configuring Left and Right menu for different Viewcontrollers
---------
You decide whether to enable or disable slide functionality on **each viewController** by implementing the following delegate methods of SlideNavigationControllerDelegate. These methods are optional, and if not implemented the menu functionality will be disabled for that particulat viewController.
```
@interface MyViewController : UIViewController <SlideNavigationControllerDelegate>
@end
```
```
@implementation MyViewController

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
        return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return YES;
}

@end
```

Public properties
---------
###### avoidSwitchingToSameClassViewController
Default value is set to YES.
If set to YES when switching to a new ViewController if the new viewcontroller is the same type as the current viewcontroller it'll close the menu instead of switching to the viewController.

If set to NO it'll switch to the viewController regardless of types

This can be usefull when you have a menu item, and when the user selects an already selected menu item you don't want to navigate to a new instance of the viewController
###### enableSwipeGesture
When set to YES user can swipe to open the menu

When set to NO swipe is disabled, and use can only open the menu using the UIBarButtonItem added to the navigationBar
######panGestureSideOffset
This property allows you to limit the gesture to the sides of the view. For instance setting this value to 50 means touches are limited to 50 pixels to the right and 50 pixels to the left of the view. This could be useful if you are expecting slide-to-delete functionality on UITableViews.

Default value of panGestureSideOffset is set to 0. Setting panGestureSideOffset to 0 means touches are detected in the whole view if enableSwipeGesture is set to true.
###### enableShadow
A boolean that allows you to turn shadow on/off. On default shadow is set to true
###### rightMenu
The viewController of the right menu in the navigationController
###### leftMenu
The viewController of the left menu in the navigationController
###### leftBarButtonItem
Default value is null. When this button is set navigationController uses this UIBarButtonItem as the leftItem. this property is intended to be used when a custom UIBarButton is needed (UIBarButtonItem initialized with a custom view)
###### rightBarButtonItem
Behaves exactly the same as leftbarButtonItem, but it's used as the right button for the menu
###### portraitSlideOffset
Default value of portraitSlideOffset is 60. This means when the menu is open, the width of the visible portion of the navigation controller is 60 pixels in portrait mode
###### landscapeSlideOffset
Default value of portraitSlideOffset is 60. This means when the menu is open, the width of the visible portion of the navigation controller is 60 pixels in landscape mode
###### menuRevealAnimationDuration
Default value of animation duration is .3, this property allows configuring animation duration
###### menuRevealAnimationOption
Defaults to UIViewAnimationOptionCurveEaseOut, you can change this property to configure animation options
###### menuRevealAnimator
menuRevealAnimator is used to animate the left/right menu during reveal. The default value is nil, that means no animations occure when opening/closing the menu. 

There are existing animation classes that can be used. These animation classes can be configured through init method options.

- SlideNavigationContorllerAnimatorSlide
- SlideNavigationContorllerAnimatorFade
- SlideNavigationContorllerAnimatorScale
- SlideNavigationContorllerAnimatorScaleAndFade
- SlideNavigationContorllerAnimatorSlideAndFade

```
SlideNavigationContorllerAnimatorSlideAndFade *alideAndFadeAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor redColor] andSlideMovement:100];
[SlideNavigationController sharedInstance].menuRevealAnimator = alideAndFadeAnimator;
```
Public Methods
---------
###### + (SlideNavigationController *)sharedInstance;
Returns the singleton instance of SlideNavigationController

###### - (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;
This method is deprecated

###### - (void)popToRootAndSwitchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;
Pops to root view controller and calls the completion.

###### - (void)popToRootAndSwitchToViewController:(UIViewController *)viewController withSlideOutAnimation:(BOOL)slideOutAnimation andCompletion:(void (^)())completion;
Similar to previous method, but allows turning on/off slide-out-animation during the switch

###### - (void)popAllAndSwitchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;
Replaces the ViewController stack with a new stack that includes the new ViewController, and calls completion

###### - (void)popAllAndSwitchToViewController:(UIViewController *)viewController withSlideOutAnimation:(BOOL)slideOutAnimation andCompletion:(void (^)())completion;
Similar to previous method, but allows turning on/off slide-out-animation during the switch

###### - (void)openMenu:(Menu)menu withCompletion:(void (^)())completion;
Opens a given menu and calls the completion block oppon animation completion

###### - (void)closeMenuWithCompletion:(void (^)())completion;
Closes the menu and calls the completion block oppon animation completion

###### - (void)toggleLeftMenu;
Toggles the left menu open or close depending on the existing state. This was made public in order to pass the selector to a custom UIBarButtonItem (ex: UIBarButtonItem with a button as a custom view)

```
UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
[button setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
[button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
[SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
```

###### - (void)bounceMenu:(Menu)menu withCompletion:(void (^)())completion;
Bounces either right or left menu, and calls the completion block oppon animation completion
###### - (void)toggleRightMenu;
Works exactly the same as toggleLeftMenu, but used to toggle left menu

###### - (BOOL)isMenuOpen;
Returns a boolean stating whether the menu is open or not

Custom Animations
---------
SlideNavigationController allows custom reveal animations. In order to add custom animations create a new class implementing SlideNavigationContorllerAnimator protocol. For more information take a look at the existing animation classes.

###### - (void)prepareMenuForAnimation:(Menu)menu;
This method gets called right before the menu is about to reveal
###### - (void)animateMenu:(Menu)menu withProgress:(CGFloat)progress;
This method gets called as the menu reveal occurs, and passes the progress to be used for animations(progress is between 0 and 1)
###### - (void)clear;
This method gets called if for any resons the instance of animator is being changed. For instance, the animator is changed from SlideNavigationContorllerAnimatorFade to SlideNavigationContorllerAnimatorSlide. In this method you should cleanup the state of the menu if neede. For instance if you added a view to the menu for reveal animation, you should remove it when clear gets called.
Public Methods

Notifications
---------
###### SlideNavigationControllerDidOpen
This notification is posted EVERY time the menu goes inot a complete open state
Userinfo contains a value with key "menu", which could have 2 values "left" and "right"

###### SlideNavigationControllerDidClose
This notification is posted EVERY time the menu goes inot a complete close state
Userinfo contains a value with key "menu", which could have 2 values "left" and "right"

###### SlideNavigationControllerDidReveal
This notification is posted once everytim a menu reveals
Userinfo contains a value with key "menu", which could have 2 values "left" and "right"


