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

@implementation LevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Match Game";
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
    //self.level = input;
}
-(IBAction)level3:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    //self.level = input;
}
-(IBAction)level4:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    //self.level = input;
}
-(IBAction)level5:(id)sender;
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    //self.level = input;
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