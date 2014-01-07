iOS-Slide-Menu
==============

iOS Slide Menu built on top of UINavigationController.

Features: 
- Righ Menu
- Left Menu
- Configurable Buttons
- Allows Enable/Disable menu by implmenting delegate methods
- Tap/Swipe gesture recognizer to Open/Close the Menus

![alt tag](https://raw.github.com/aryaxt/iOS-Slide-Menu/master/slideMenuAnimation.gif)

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

Configuring menu offset
---------
Menu offset can be configured for both portrait and landscape mode
```
[SlideNavigationController sharedInstance].landscapeSlideOffset = 400;
[SlideNavigationController sharedInstance].portraitSlideOffset = 60;
```
Menu Reveal Animations
---------
There are three types of animations that can be applied when revealing the menu

```
MenuRevealAnimationNone
MenuRevealAnimationFade
MenuRevealAnimationSlide
MenuRevealAnimationSlideAndFade

[SlideNavigationController sharedInstance].menuRevealAnimation = MenuRevealAnimationSlideAndFade;
```

The opacity applied during a fade animation can be configured using a property on SlideNavigationController called menuRevealAnimationFadeMaximumAlpha. This value can be anywhere between 0 and 1, and it represents the darkes a menu can become. The color of fade layer can also be configured using the property called menuRevealAnimationFadeColor
```
[SlideNavigationController sharedInstance].menuRevealAnimationFadeColor = [UIColor greenColor];
[SlideNavigationController sharedInstance].menuRevealAnimationFadeMaximumAlpha = .5;
```

The movement of menu during a slide animation can also be configured
```
[SlideNavigationController sharedInstance].menuRevealAnimationSlideMovement = 50;
```

