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
#import "Macros.h"
#import "AppDelegate.h"

@interface RomoTalkController ()

@property NSString *question;

@end

@implementation RomoTalkController

static bool first = true;
static bool second = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.title = @"Romo Talk";
    
    //Set home button
    UIBarButtonItem *HomeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Home"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(home)];
    [[self navigationItem] setRightBarButtonItem:HomeButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                               object:nil];

    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self sendMessage:self.title];
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
         if ([receivedMessage isEqualToString:@"do you like dogs ?"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you like sleeping ?"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you like cats ?"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"do you like playing ?"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"dogs are my favourite animal"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"sleep gives me more energy"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"i really hate cats !"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
         else if ([receivedMessage isEqualToString:@"i could play all day"])
         {
             NSLog(@"Received: %@", receivedMessage);
             self.question = receivedMessage;
             [self splitQuestion];
         }
     }];

}

- (void) splitQuestion
{
    self.words = [self.question componentsSeparatedByString:@" "];
    NSLog(@"Question words: %@", self.words);
    [self getQuestionImages:self.words];
    
}

- (void) getQuestionImages: (NSArray *)arr
{
    NSLog(@"%@", arr);
    
    self.questionImageViews = [[ NSArray alloc] initWithObjects:self.question1,self.question2,self.question3, self.question4, self.question5,nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.questionImages = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"Question images: %@", self.questionImages);
    
    for (int i = 0; i<[arr count];)
    {
        for (int j = 0; j<[self.questionImageViews count]; j++)
        {
            NSString *word = [arr objectAtIndex:i];
            NSString *imageName = [self.questionImages objectForKey:word];
            UIImageView *imageView = [self.questionImageViews objectAtIndex:j];
            imageView.image = [UIImage imageNamed:imageName];
            NSLog(@"here");
            i++;
            
        }
    }
    
    if (first == false)
    {
        self.yesButton.hidden = YES;
        self.yesLabel.hidden = YES;
        self.noButton.hidden = YES;
        self.noLabel.hidden = YES;
        second = true;
    }
    else if (second == true)
    {
        NSLog(@"second");
    }
    
    
    first = false;
}

- (IBAction)yesButton:(id)sender
{
    NSString *yes = @"yes";
    
    NSString *word = [self.words objectAtIndex:3];
    
    NSString *combined = [NSString stringWithFormat:@"%@ %@", yes, word];
    NSLog(@"Combined: %@", combined);
    
    [self sendMessage:combined];
}

- (IBAction)noButton:(id)sender
{
    NSString *no = @"no";
    
    NSString *word = [self.words objectAtIndex:3];
    
    NSString *combined = [NSString stringWithFormat:@"%@ %@", no, word];
    NSLog(@"Combined: %@", combined);
    
    [self sendMessage:combined];
}

-(void)sendMessage: (NSString *)str
{
    NSLog(@"Message: %@", str);
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



- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}
@end
