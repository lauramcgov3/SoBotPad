//
//  GamesViewController.m
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

@import AVFoundation;
#import <Foundation/Foundation.h>
#import "GamesController.h"
#import "MenuController.h"
#import "TextToSpeech.h"


@implementation GamesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set title of view
    self.title = @"Games";
    
    // Set the back button to an arrow
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

-(void)goBack
{
    // Navigates back to the previous controller
    [self.navigationController popViewControllerAnimated:YES];
}

// Game button action
-(IBAction)gameButton:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    [TextToSpeech speakString:input];
}


@end