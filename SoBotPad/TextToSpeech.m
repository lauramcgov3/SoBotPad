//
//  TextToSpeech.m
//  SoBotPad
//
//  Created by Laura on 30/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextToSpeech.h"
@import AVFoundation;

@implementation TextToSpeech

// Text to speech function
+(void)speakString:(NSString *) str
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    
    
    NSString *input = str;
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:input];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = 0.40;
    [synthesizer speakUtterance:utterance];
}
@end