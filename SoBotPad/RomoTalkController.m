//
//  RomoTalkController.m
//  SoBotPad
//
//  Created by Laura on 13/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//


// Imports for class
@import AVFoundation;
#import <Foundation/Foundation.h>
#import "RomoTalkController.h"
#import "PictureGameController.h"
#import "Macros.h"
#import "AppDelegate.h"
#import "TextToSpeech.h"

@interface RomoTalkController ()

// Interface variables
@property NSString *talk;

@end

@implementation RomoTalkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Shared application for Multipeer Connectivity
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Set title of view
    self.title = @"Romo Talk";
    
    // Hide the navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back-key.png"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //Set home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"home-bar"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(home)];
    [self.navigationItem setRightBarButtonItem:homeButton];
    
    // Add notification center for Multipeer Connectivity
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                               object:nil];
    
    // Hide home and play again buttons
    self.playAgain.hidden = YES;
    self.playAgainLabel.hidden = YES;
    self.homeButton.hidden = YES;
    self.homeLabel.hidden = YES;
}

// Method to go back to previous screen
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    // Send title of view and speak the reply from Romo
    [self sendMessage:self.title];
    [TextToSpeech speakString:self.talk];
}

// Method for handling received messages - dictates behaviour
- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    NSData *receivedData = [[notification userInfo]objectForKey:SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
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

// Split sentence into words
- (void) splitQuestion
{
    self.words = [self.talk componentsSeparatedByString:@" "];
    [self getTalkImages:self.words];
}

// Method to get images for talking
- (void) getTalkImages: (NSArray *)arr
{
    // All talk image views
    self.talkImageViews = [[ NSArray alloc] initWithObjects:self.talk1,self.talk2,self.talk3, self.talk4, self.talk5,nil];
    
    // Get words and images from words.plist
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.talkImages = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [NSThread sleepForTimeInterval:1.5f];
    
    // Assign images to image views
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
    [self sendDone];
}

- (void) sendDone
{
    // Notify Romo that images are loaded
    [TextToSpeech speakString:self.talk];
    [NSThread sleepForTimeInterval:2.0f];
    [self sendMessage:@"buttons loaded"];
}

- (void) getButtons
{
    // Show play again and home buttons and labels
    [NSThread sleepForTimeInterval:0.5f];
    self.playAgain.hidden = NO;
    self.playAgainLabel.hidden = NO;
    self.homeButton.hidden = NO;
    self.homeLabel.hidden = NO;
}

// Play again button action
- (IBAction)playAgain:(id)sender
{
    [TextToSpeech speakString:@"Play again"];
    [self changeToGame];
}

// Home button action
- (IBAction)homeButton:(id)sender
{
    [TextToSpeech speakString:@"Home"];
    [self home];
}

// Method to send message
-(void)sendMessage: (NSString *)str
{
    
    NSString *message = str;
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

// Method to go home
- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
}

// Method to back to Picture Game
- (void) changeToGame
{
    PictureGameController *pictureGameController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PictureGameController"];
    [self.navigationController pushViewController:pictureGameController animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Remove notification center for Multipeer Connectivity
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                                  object:nil];
}

@end