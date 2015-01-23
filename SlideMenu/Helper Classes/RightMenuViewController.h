//
//  RightMenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationControllerAnimator.h"
#import "SlideNavigationControllerAnimatorFade.h"
#import "SlideNavigationControllerAnimatorSlide.h"
#import "SlideNavigationControllerAnimatorScale.h"
#import "SlideNavigationControllerAnimatorScaleAndFade.h"
#import "SlideNavigationControllerAnimatorSlideAndFade.h"

@interface RightMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
