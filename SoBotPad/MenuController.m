//
//  ViewController.m
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

// Imports for class
@import AVFoundation;
#import "MenuController.h"
#import "MenuCellViewController.h"
#import "GamesController.h"
#import "RemoteController.h"
#import "SettingsController.h"
#import "TextToSpeech.h"

// Cell view interface
@interface MenuCellView ()

@end

@interface MenuController ()

// Interface variables
@property NSString *menuItem;

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Remote back button
    self.navigationItem.hidesBackButton = YES;
    
    //Ensure navigation bar is not hidden when returning to the home screen
    [self.navigationController setNavigationBarHidden:NO];
    
    // Set title
    self.title = @"Home";
    
    // Speak title
    [TextToSpeech speakString:self.title];
    
    
    // Load Menu Items from Menu-Items.plist
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Menu-Items" ofType:@"plist"];
    self.menuItems = [NSArray arrayWithContentsOfFile:filePath];
}


#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Menu
    NSDictionary *menuItem = [self.menuItems objectAtIndex:[indexPath row]];
    
    // Configure cell text
    [cell.textLabel setText:[menuItem objectForKey:@"Menu"]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:27.0];
    
    // Configure cell image
    cell.imageView.image = [UIImage imageNamed:[menuItem objectForKey:@"Image"]];
    CGPoint centerImageView = cell.imageView.center;
    centerImageView.x = self.view.center.x;
    cell.imageView.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2);
    
    // Configure cell background colour and border
    cell.backgroundColor = [UIColor colorWithRed:7.0f/255.0f green:7.0f/255.0f blue:99.0f/255.0f alpha:1.0f];
    cell.layer.borderColor = [[UIColor cyanColor] CGColor];
    cell.layer.borderWidth = 10.f;
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Items
    NSDictionary *menuItem = [self.menuItems objectAtIndex:[indexPath row]];
    self.menuItem =  [menuItem objectForKey:@"Menu"];
    
    
    // If..else controls where the app goes when a menu item is selected
    if ([self.menuItem isEqualToString:@"Games"])
    {
        
        [TextToSpeech speakString:self.menuItem];
        GamesController *gamesController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamesController"];
        
        [self.navigationController pushViewController:gamesController animated:NO];
        
    }
    else if ([self.menuItem isEqualToString:@"Remote"])
    {
        [TextToSpeech speakString:self.menuItem];
        
        RemoteController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RemoteController"];
        
        [self.navigationController pushViewController:settingsController animated:NO];
    }
    else if ([self.menuItem isEqualToString:@"Settings"])
    {
        [TextToSpeech speakString:self.menuItem];
        
        SettingsController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsController"];
        
        [self.navigationController pushViewController:settingsController animated:NO];
    }
}


@end
