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
#import "GamesController.h"
#import "CategoryController.h"

@implementation CategoryController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Categories";
}

-(IBAction)animals:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    self.category = input;
    NSLog(@"%@", self.category);
    [self speakString:input];
    
}

-(IBAction)colours:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    self.category = input;
    NSLog(@"%@", self.category);
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