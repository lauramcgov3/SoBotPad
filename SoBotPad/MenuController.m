//
//  ViewController.m
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//
@import AVFoundation;

#import "MenuController.h"
#import "MenuCellViewController.h"
#import "GamesController.h"
#import "RemoteController.h"
#import "SettingsController.h"

@interface MenuCellView ()

@end

@implementation MenuCellView

    
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,55,55);
    self.imageView.center = CGPointMake(self.imageView.center.x, self.imageView.center.y);
}

@end


@interface MenuController ()

@property NSString *menuItem;

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    
    // Set title
    self.title = @"Home";
    [self speakString:self.title];
    
    // Load Menu Items
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MenuItems" ofType:@"plist"];
    self.menuItems = [NSArray arrayWithContentsOfFile:filePath];
    self.tableView.separatorColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:0.25];
    
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
    
    // Configure Cell
    [cell.textLabel setText:[menuItem objectForKey:@"Menu"]];
    cell.imageView.image = [UIImage imageNamed:[menuItem objectForKey:@"Image"]];
    //cell.imageView.frame = self.imageView.frame;
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Items
    NSDictionary *menuItem = [self.menuItems objectAtIndex:[indexPath row]];
    self.menuItem =  [menuItem objectForKey:@"Menu"];
    NSLog(@"%@", [menuItem objectForKey:@"Menu"]);
    
    if ([self.menuItem isEqualToString:@"Games"])
    {
        
        [self speakString:self.menuItem];
        GamesController *gamesController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamesController"];
        
        [self.navigationController pushViewController:gamesController animated:NO];
        
    }
    else if ([self.menuItem isEqualToString:@"Remote"])
    {
        [self speakString:self.menuItem];
        
        RemoteController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RemoteController"];
        
        [self.navigationController pushViewController:settingsController animated:NO];
    }
    else if ([self.menuItem isEqualToString:@"Settings"])
    {
        [self speakString:self.menuItem];
        
        SettingsController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsController"];
        
        [self.navigationController pushViewController:settingsController animated:NO];
    }
}

-(void)speakString:(NSString *) str
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    
    
    NSString *input = str;
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:input];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-gb"];
    utterance.rate = 0.40;
    [synthesizer speakUtterance:utterance];
    //sleep(1);
}


@end
