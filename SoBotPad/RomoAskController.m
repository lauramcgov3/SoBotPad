//
//  RomoTalkController.m
//  SoBotPad
//
//  Created by Laura on 13/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

@import AVFoundation;
#import <Foundation/Foundation.h>
#import "RomoAskController.h"
#import "RomoTalkController.h"
#import "Macros.h"
#import "AppDelegate.h"
#import "TextToSpeech.h"

@interface RomoAskController ()

@property NSString *question;

@end

@implementation RomoAskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Set title of view
    self.title = @"Romo Ask";
    
    // Hide navigation bar
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
    
    // Notification center for Multipeer Connectivity
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                               object:nil];
    
    // Hide yes and no buttons and labels
    self.yesButton.hidden = YES;
    self.yesLabel.hidden = YES;
    self.noButton.hidden = YES;
    self.noLabel.hidden = YES;
    

}

// Method to go back a screen
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

// When the view loads
- (void) viewDidAppear:(BOOL)animated
{
    // Message is sent to alert Romo
    [self sendMessage:self.title];
}

// Method to handle received messages - dictates behaviour
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
         if ([receivedMessage isEqualToString:@"do you like dogs ?"])
         {
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you like sleeping ?"])
         {
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you like cats ?"])
         {
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you like playing ?"])
         {
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you like running ?"])
         {
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you go swimming ?"])
         {
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else
         {
             [self getButtons];
         }
     }];
    
}

// Method to split question into words
- (void) splitQuestion
{
    self.words = [self.question componentsSeparatedByString:@" "];
    [self getQuestionImages:self.words];
    
}

// Method to get images for question words
- (void) getQuestionImages: (NSArray *)arr
{
    // Image views
    self.questionImageViews = [[ NSArray alloc] initWithObjects:self.question1,self.question2,self.question3, self.question4, self.question5,nil];
    
    // Get words and images from Words.plist
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.questionImages = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [NSThread sleepForTimeInterval:1.5f];
    
    // Set images to image views
    for (int i = 0; i<[arr count];)
    {
        for (int j = 0; j<[self.questionImageViews count]; j++)
        {
            NSString *word = [arr objectAtIndex:i];
            NSString *imageName = [self.questionImages objectForKey:word];
            UIImageView *imageView = [self.questionImageViews objectAtIndex:j];
            imageView.image = [UIImage imageNamed:imageName];
            i++;
            
        }
    }
    [NSThread sleepForTimeInterval:1.2f];
    [self getButtons];
}

- (void) getButtons
{
    // Shows the yes and no buttons and labels
    self.yesButton.hidden = NO;
    self.yesLabel.hidden = NO;
    self.noButton.hidden = NO;
    self.noLabel.hidden = NO;
    
    // Say the question once the images have loaded
    [TextToSpeech speakString:self.question];
}

// Action for yes button
- (IBAction)yesButton:(id)sender
{
    NSString *yes = @"yes";
    
    NSString *word = [self.words objectAtIndex:3];
    
    NSString *combined = [NSString stringWithFormat:@"%@ %@", yes, word];
    
    [self sendMessage:combined];
    [TextToSpeech speakString:yes];
}

// Action for no button
- (IBAction)noButton:(id)sender
{
    NSString *no = @"no";
    
    NSString *word = [self.words objectAtIndex:3];
    
    NSString *combined = [NSString stringWithFormat:@"%@ %@", no, word];
    
    [self sendMessage:combined];
    [TextToSpeech speakString:no];
}

// Send message method
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

// Change to next screen when done
- (void) changeToTalk
{
    RomoTalkController *romoTalkController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RomoTalkController"];
    [self.navigationController pushViewController:romoTalkController animated:NO];
    
}

// Method for going home
- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Remove notification center for Multipeer Connectivity
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                                  object:nil];
}

@end
