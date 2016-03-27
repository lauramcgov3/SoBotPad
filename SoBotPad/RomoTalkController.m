//
//  RomoTalkController.m
//  SoBotPad
//
//  Created by Laura on 13/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

@import AVFoundation;
#import <Foundation/Foundation.h>
#import "RomoTalkController.h"
#import "PictureGameController.h"
#import "Macros.h"
#import "AppDelegate.h"

@interface RomoTalkController ()

@property NSString *talk;

@end

@implementation RomoTalkController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.title = @"Romo Talk";
    [self.navigationController setNavigationBarHidden:YES];
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //Set home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home-bar"] style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    [self.navigationItem setRightBarButtonItem:homeButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                               object:nil];
    
    self.playAgain.hidden = YES;
    self.playAgainLabel.hidden = YES;
    self.homeButton.hidden = YES;
    self.homeLabel.hidden = YES;
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self sendMessage:self.title];
    [self speakString:self.talk];
}


- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo]objectForKey:SESSION_KEY_PEER_ID];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo]objectForKey:SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"peerDisplayName = %@", peerDisplayName);
    NSLog(@"receivedMessage = %@", receivedMessage);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:
     ^{
         if ([receivedMessage isEqualToString:@"dogs are my favourite animal"])
         {
             self.talk = receivedMessage;
             NSLog(@"Talk: %@", self.talk);
             [self splitQuestion];
             return;
         }
         else if ([receivedMessage isEqualToString:@"sleep gives me more energy"])
         {
             self.talk = receivedMessage;
             NSLog(@"Talk: %@", self.talk);
             [self splitQuestion];
             return;
         }
         else if ([receivedMessage isEqualToString:@"i really hate cats !"])
         {
             self.talk = receivedMessage;
             NSLog(@"Talk: %@", self.talk);
             [self splitQuestion];
             return;
         }
         else if ([receivedMessage isEqualToString:@"i could play all day"])
         {
             self.talk = receivedMessage;
             NSLog(@"Talk: %@", self.talk);
             [self splitQuestion];
             return;
         }
         else if ([receivedMessage isEqualToString:@"this is how i run"])
         {
             self.talk = receivedMessage;
             NSLog(@"Talk: %@", self.talk);
             [self splitQuestion];
             return;
         }
         else if ([receivedMessage isEqualToString:@"robots cannot go swimming !"])
         {
             self.talk = receivedMessage;
             NSLog(@"Talk: %@", self.talk);
             [self splitQuestion];
             return;
         }
         else if ([receivedMessage isEqualToString:@"done"])
         {
             [self getButtons];
             return;
         }
         else
         {
             [self getButtons];
         }
         
     }];

}

- (void) splitQuestion
{
    self.words = [self.talk componentsSeparatedByString:@" "];
    [self getQuestionImages:self.words];
    
}

- (void) getQuestionImages: (NSArray *)arr
{
    
    self.talkImageViews = [[ NSArray alloc] initWithObjects:self.talk1,self.talk2,self.talk3, self.talk4, self.talk5,nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.talkImages = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [NSThread sleepForTimeInterval:1.5f];
    
    for (int i = 0; i<[arr count];)
    {
        for (int j = 0; j<[self.talkImageViews count]; j++)
        {
            NSString *word = [arr objectAtIndex:i];
            NSString *imageName = [self.talkImages objectForKey:word];
            UIImageView *imageView = [self.talkImageViews objectAtIndex:j];
            imageView.image = [UIImage imageNamed:imageName];
            i++;
        }
    }
    NSLog(@"Done");
    [self sendDone];
    
}

- (void) sendDone
{
    [self speakString:self.talk];
    [NSThread sleepForTimeInterval:2.0f];
    [self sendMessage:@"buttons loaded"];
}

- (void) getButtons
{
    self.playAgain.hidden = NO;
    self.playAgainLabel.hidden = NO;
    self.homeButton.hidden = NO;
    self.homeLabel.hidden = NO;

}


- (IBAction)playAgain:(id)sender
{
    [self speakString:@"Play again"];
    [self changeToGame];
}

- (IBAction)homeButton:(id)sender
{
    [self speakString:@"Home"];
    [self home];
}

-(void)sendMessage: (NSString *)str
{
    
    NSString *message = str;
    NSLog(@"Message: %@", message);
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
    
    return;
}

-(void)speakString: (NSString *)str
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    
    
    NSString *input = str;
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:input];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-gb"];
    utterance.rate = 0.40;
    [synthesizer speakUtterance:utterance];
}

- (void) home
{
    
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}



- (void) changeToGame
{
    
    PictureGameController *pictureGameController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PictureGameController"];
    [self.navigationController pushViewController:pictureGameController animated:NO];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                                  object:nil];
}


@end
