//
//  RightMenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "RightMenuViewController.h"

@implementation RightMenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightMenu.jpg"]];
	self.tableView.backgroundView = imageView;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightMenuCell"];
	
	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = @"None";
			break;
			
		case 1:
			cell.textLabel.text = @"Slide";
			break;
			
		case 2:
			cell.textLabel.text = @"Fade";
			break;
			
		case 3:
			cell.textLabel.text = @"Slide And Fade";
			break;
			
		case 4:
			cell.textLabel.text = @"Scale";
			break;
			
		case 5:
			cell.textLabel.text = @"Scale And Fade";
			break;
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id <SlideNavigationContorllerAnimator> revealAnimator;
	CGFloat animationDuration = 0;
	
	switch (indexPath.row)
	{
		case 0:
			revealAnimator = nil;
			animationDuration = .19;
			break;
			
		case 1:
			revealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
			animationDuration = .19;
			break;
			
		case 2:
			revealAnimator = [[SlideNavigationContorllerAnimatorFade alloc] init];
			animationDuration = .18;
			break;
			
		case 3:
			revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
			animationDuration = .19;
			break;
			
		case 4:
			revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
			animationDuration = .22;
			break;
			
		case 5:
			revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
			animationDuration = .22;
			break;
			
		default:
			return;
	}
	
	[[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
		[SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
		[SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
	}];
}

@end
