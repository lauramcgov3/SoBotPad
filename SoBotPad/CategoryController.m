//
//  CategoryController.m
//  SoBotPad
//
//  Created by Laura on 05/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
#import <Foundation/Foundation.h>
#import "LevelController.h"
#import "CategoryController.h"
#import "GamesController.h"
#import "AppDelegate.h"

@implementation CategoryController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Categories";
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //Set home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home-bar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    [self.navigationItem setRightBarButtonItem:homeButton];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)animals:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    NSLog(@"%@", input);
    [self speakString:input];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.category setString:input];

}

-(IBAction)colours:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    NSLog(@"%@", input);
    [self speakString:input];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.category setString:input];
}

-(void)speakString:(NSString *) str
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    
    
    NSString *input = str;
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:input];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-gb"];
    utterance.rate = 0.40;
    [synthesizer speakUtterance:utterance];
    sleep(1);
}

- (void) home
{
    NSLog(@"HOME");
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}
- (void) games
{
    GamesController *gamesController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GamesController"];
    [self.navigationController pushViewController:gamesController animated:YES];
    
}


@end