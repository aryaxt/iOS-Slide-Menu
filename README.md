iOS-Slide-Menu
==============

iOS Slide Menu built on top of UINavigationController

Setup
___________
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	LeftMenuViewController *leftMenu = [[LeftMenuViewController alloc] init];
  RightMenuViewController *leftMenu = [[RightMenuViewController alloc] init];
	
	[SlideNavigationController sharedInstance].righMenu = rightMenu;
	[SlideNavigationController sharedInstance].leftMenu = leftMenu;
	
    // Override point for customization after application launch.
    return YES;
}
```

Switch Between ViewController
Let's say a menu item was selected
```
SomeViewController *vc = [[SomeViewController alloc] init];
[[SlideNavigationController sharedInstance] switchViewController:vc withCompletion:nil];
```
Configuring Left and Right menu for different Viewcontrollers
```
@interface MyViewController : UIViewController <SlideNavigationControllerDelegate>
@end
```
```
@implementation MyViewController

- (BOOL)slideNavigationControllerShouldSisplayLeftMenu
{
  return YES;
}

- (BOOL)slideNavigationControllerShouldSisplayRightMenu
{
	return YES;
}

@end
```
