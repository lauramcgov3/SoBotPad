//
//  RomoAskController.m
//  SoBotPad
//
//  Created by Laura on 19/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@interface RomoAskController ()

@property NSString *question;

@end

@implementation RomoAskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.title = @"Romo Ask";
    [self.navigationController setNavigationBarHidden:YES];
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //Set home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home-bar"] style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    [self.navigationItem setRightBarButtonItem:homeButton];
    
    
    self.yesButton.hidden = YES;
    self.yesLabel.hidden = YES;
    self.noButton.hidden = YES;
    self.noLabel.hidden = YES;
    

}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                               object:nil];
}
- (void) viewDidAppear:(BOOL)animated
{
    [self sendMessage:self.title];
    [self speakString:self.question];
}




- (void) splitQuestion
{
    self.words = [self.question componentsSeparatedByString:@" "];
    [self getQuestionImages:self.words];
    
}

- (void) getQuestionImages: (NSArray *)arr
{
    
    self.questionImageViews = [[ NSArray alloc] initWithObjects:self.question1,self.question2,self.question3, self.question4, self.question5,nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.questionImages = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [NSThread sleepForTimeInterval:1.5f];
    
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
    
    [self getButtons];
}

- (void) getButtons
{
    self.yesButton.hidden = NO;
    self.yesLabel.hidden = NO;
    self.noButton.hidden = NO;
    self.noLabel.hidden = NO;
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



- (void) changeToTalk
{
    
    RomoTalkController *romoTalkController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RomoTalkController"];
    [self.navigationController pushViewController:romoTalkController animated:NO];
    
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
     }];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                                  object:nil];
}

@end
