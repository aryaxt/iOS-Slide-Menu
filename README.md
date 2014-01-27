iOS-Slide-Menu
---------
iOS Slide Menu built on top of UINavigationController, with configurable buttons, reveal animations, and tap/swiper gesture recognizers.

- [Setup](https://github.com/aryaxt/iOS-Slide-Menu#setup)
- [Switch ViewController](https://github.com/aryaxt/iOS-Slide-Menu#switch-between-viewcontrollers)
- [Enable/Disable Left/Right Menu](https://github.com/aryaxt/iOS-Slide-Menu#configuring-left-and-right-menu-for-different-viewcontrollers)
- [Public Properties](https://github.com/aryaxt/iOS-Slide-Menu#public-properties)
- [Public Methods](https://github.com/aryaxt/iOS-Slide-Menu#public-methods)
- [Custom Animations](https://github.com/aryaxt/iOS-Slide-Menu#custom-animations)

![alt tag](https://raw.github.com/aryaxt/iOS-Slide-Menu/master/slideMenuAnimation.gif)

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
        RightMenuViewController *righMenu = [[RightMenuViewController alloc] init];
	
	[SlideNavigationController sharedInstance].righMenu = rightMenu;
	[SlideNavigationController sharedInstance].leftMenu = leftMenu;
	
    // Override point for customization after application launch.
    return YES;
}
```
Switch Between ViewControllers
----------
Let's say a menu item was selected
```
SomeViewController *vc = [[SomeViewController alloc] init];
[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
```
Configuring Left and Right menu for different Viewcontrollers
---------
You decide whether to enable or disable slide functionality on each viewController by implementing the following delegate methods of SlideNavigationControllerDelegate. These methods are optional, and if not implemented the menu functionality will be disabled for that particulat viewController.
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
Pops to root ViewController, then pushes the new ViewController and finally calls the completion

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

