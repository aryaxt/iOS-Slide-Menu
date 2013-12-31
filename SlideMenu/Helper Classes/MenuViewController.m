//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController
@synthesize cellIdentifier;

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
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
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
															 bundle: nil];
	
	UIViewController *vc ;
	
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
	}
	
	[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

@end
