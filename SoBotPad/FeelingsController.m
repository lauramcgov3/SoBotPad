//
//  RemoteController.m
//  SoBotPad
//
//  Created by Laura on 06/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

@import AVFoundation;
#import <Foundation/Foundation.h>
#import "FeelingsController.h"
#import "Macros.h"
#import "AppDelegate.h"

@implementation FeelingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.title = @"Feelings";
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)happy:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    NSLog(@"%@", input);
    [self speakString:input];
    [self sendMessage:input];
}

- (IBAction)excited:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}

- (IBAction)sad:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}

- (IBAction)angry:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}

- (IBAction)confused:(id)sender
{
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}

- (IBAction)tired:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}

- (IBAction)bored:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}

- (IBAction)afraid:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}
- (IBAction)disgust:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    [self speakString:input];
    [self sendMessage:input];
}

-(void)sendMessage: (NSString *)str
{
    NSString *message = str;
    NSLog(@"%@", message);
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
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