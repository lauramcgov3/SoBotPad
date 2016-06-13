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
#import "TextToSpeech.h"

@implementation FeelingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
}

- (IBAction)emotion:(id)sender{
    
    NSString *input = [(UIButton *)sender currentTitle];
    NSLog(@"%@", input);
    [TextToSpeech speakString:input];
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

@end