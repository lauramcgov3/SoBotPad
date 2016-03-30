//
//  MatchGameController.m
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import "LevelController.h"
#import "GamesController.h"
#import "MenuController.h"
#import "CategoryController.h"
#import "TextToSpeech.h"


@implementation LevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Levels";
    NSLog(@"%@", self.title);
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //Set home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home-bar"] style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    [self.navigationItem setRightBarButtonItem:homeButton];
}

// Method to return to previous view
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Action for buttons
-(IBAction)level:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [TextToSpeech speakString:input];
}

// Method to go home
- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
}


@end