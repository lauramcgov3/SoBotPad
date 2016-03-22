//
//  MatchGameController.m
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
#import "LevelController.h"
#import "GamesController.h"
#import "MenuController.h"
#import "CategoryController.h"


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

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)level1:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
}
-(IBAction)level2:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
}
-(IBAction)level3:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
}
-(IBAction)level4:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
}
-(IBAction)level5:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
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


@end