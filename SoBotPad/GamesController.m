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


@implementation GamesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Games";
}

-(IBAction)matchGame:(id)sender
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


@end