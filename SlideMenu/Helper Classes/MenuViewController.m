//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

@implementation MenuViewController
@synthesize cellIdentifier;

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
	
	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = @"Home";
			break;
			
		case 1:
			cell.textLabel.text = @"Profile";
			break;
			
		case 2:
			cell.textLabel.text = @"Friends";
			break;
			
		case 3:
			cell.textLabel.text = @"Sign Out";
			break;
			
		case 4:
			cell.textLabel.text = @"No Animation";
			break;
			
		case 5:
			cell.textLabel.text = @"Slide Animation";
			break;
			
		case 6:
			cell.textLabel.text = @"Fade Animation";
			break;
			
		case 7:
			cell.textLabel.text = @"Slide And Fade Animation";
			break;
			
		case 8:
			cell.textLabel.text = @"Scale Animation";
			break;
			
		case 9:
			cell.textLabel.text = @"Scale And Fade Animation";
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
															 bundle: nil];
	
	UIViewController *vc ;
	id <SlideNavigationContorllerAnimator> revealAnimator;
	
	switch (indexPath.row)
	{
		case 0:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
			break;
			
		case 1:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
			break;
			
		case 2:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FriendsViewController"];
			break;
			
		case 3:
			[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
			return;
			break;
			
		case 4:
			revealAnimator = nil;
			break;
			
		case 5:
			revealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
			break;
			
		case 6:
			revealAnimator = [[SlideNavigationContorllerAnimatorFade alloc] init];
			break;
			
		case 7:
			revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] init];
			break;
			
		case 8:
			revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
			break;
			
		case 9:
			revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] init];
			break;
			
		default:
			return;
	}
	
	if (vc)
		[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
	else
		[[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
			[SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
		}];
}

@end
