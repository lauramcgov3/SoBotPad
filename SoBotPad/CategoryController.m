//
//  CategoryController.m
//  SoBotPad
//
//  Created by Laura on 05/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

// Imports for class

#import <Foundation/Foundation.h>
#import "LevelController.h"
#import "CategoryController.h"
#import "GamesController.h"
#import "AppDelegate.h"
#import "TextToSpeech.h"

@implementation CategoryController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title of view
    self.title = @"Categories";
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back-key.png"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //Set home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"home-bar.png"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(home)];
    [self.navigationItem setRightBarButtonItem:homeButton];
}

// Method to go back to previous view
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Action for animals button
-(IBAction)animals:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    [TextToSpeech speakString:input];
    
    // Passes category to levels
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.category setString:input];

}

// Action for colours button
-(IBAction)colours:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    [TextToSpeech speakString:input];
    
    // Passes category to levels
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.category setString:input];
}

// Method to go home
- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}

@end