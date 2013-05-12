iOS-Slide-Menu
==============

iOS Slide Menu built on top of UINavigationController.

Features: 
- Righ Menu
- Left Menu
- Configurable Buttons
- Allows Enable/Disable menu by implmenting delegate methods
- Tap/Swipe gesture recognizer to Open/Close the Menus

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
