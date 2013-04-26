//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"menuCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	switch (indexPath.row)
	{
		case 0:
			cell.detailTextLabel.text = @"Home";
			break;
			
		case 1:
			cell.detailTextLabel.text = @"Profile";
			break;
			
		case 2:
			cell.detailTextLabel.text = @"Friends";
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
															 bundle: nil];
	
	UIViewController *vc = (MenuViewController*)[mainStoryboard
														  instantiateViewControllerWithIdentifier: @"ProfileViewController"];
	
	[[SlideNavigationController sharedInstance] switchViewController:vc withCompletion:nil];
}

@end
