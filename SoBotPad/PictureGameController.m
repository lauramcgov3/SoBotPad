//
//  PictureGameController.m
//  SoBotPad
//
//  Created by Laura on 09/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PictureGameController.h"
#import "MenuController.h"
#import "RomoTalkController.h"
#import "Macros.h"
#import "AppDelegate.h"

@interface PictureGameController ()

@property NSArray *words;
@property UIButton *missing1;
@property UIButton *missing2;
@property NSString *guess1;
@property NSString *guess2;
@property NSInteger guess1Tag;
@property NSString* missingTitle1;
@property NSString* missingTitle2;
@property NSArray* choiceImages;
@property NSInteger match;
@property NSString *question;


@end
@implementation PictureGameController

// Static bools
static bool firstGuess = true;
static bool gameWinner = false;
static bool isMatch = false;
static bool firstMatch = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    // Set page title
    self.title = @"Picture Game";
    
    //Call first method
    [self getSentences];
    
    //Set home button
    UIBarButtonItem *HomeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Home"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(home)];
    [[self navigationItem] setRightBarButtonItem:HomeButton];
    
    // Initialise match count
    self.match = 0;
    
    
}

- (void) getSentences
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Sentences" ofType:@"plist"];
    self.allSentences = [NSArray arrayWithContentsOfFile:filePath];
    
    int random1 = arc4random()%[self.allSentences count];
    NSDictionary *sentenceObject = [self.allSentences objectAtIndex:random1];
    
    self.sentenceImage = [sentenceObject objectForKey:@"Image"];
    
    self.imageView.image = [UIImage imageNamed:self.sentenceImage];
    
    self.sentenceChosen = [sentenceObject objectForKey:@"Sentence"];
    [self splitSentence:self.sentenceChosen];
    
}

- (void) splitSentence: (NSString *) str
{
    self.words = [str componentsSeparatedByString:@" "];
    [self setImages:self.words];
}

- (void) setImages: (NSArray *) arr
{
    self.sentenceButtons = [[NSArray alloc] initWithObjects:self.word1,self.word2,self.word3, self.word4,nil];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.sentenceImages = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    
    for (int i = 0; i<[arr count];)
    {
        for (int j = 0; j<[self.sentenceButtons count]; j++)
        {
            NSString *word = [arr objectAtIndex:i];
            NSString *imageName = [self.sentenceImages objectForKey:word];
            UIImage *buttonImage = [UIImage imageNamed:imageName];
            UIButton *button = [self.sentenceButtons objectAtIndex:j];
            [button setTitle:word forState:UIControlStateNormal];
            [button setImage:buttonImage forState: UIControlStateNormal];
            i++;
            
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(removeButtons)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) removeButtons
{
    int random2 = arc4random()%[self.sentenceButtons count];
    int random3 = arc4random()%[self.sentenceButtons count];
    
    
    if (random2 != random3) {
        self.missing1 = [self.sentenceButtons objectAtIndex:random2];
        self.missing2 = [self.sentenceButtons objectAtIndex:random3];
        self.missingTitle1 = [self.missing1 currentTitle];
        self.missingTitle2 = [self.missing2 currentTitle];
        
        
        [self.missing1 setImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
        [self.missing2 setImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
        [self getChoices];
    }
    else if (random2 == random3)
        [self removeButtons];
}

- (void) getChoices
{
    // Get all images in app
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"Animals" ofType:@"plist"];
    self.animals = [NSArray arrayWithContentsOfFile:filePath1];
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"Colours" ofType:@"plist"];
    self.colours = [NSArray arrayWithContentsOfFile:filePath2];
    
    //Get images for choice buttons
    int random4 = arc4random()%[self.animals count];
    int random5 = arc4random()%[self.self.colours count];
    NSDictionary *choice1Dict = [self.animals objectAtIndex:random4];
    NSDictionary *choice2Dict = [self.colours objectAtIndex:random5];
    NSString *choice1 = [choice1Dict objectForKey:@"Image"];
    NSString *choice2 = [choice2Dict objectForKey:@"Image"];
    NSString *choice3 = [self.sentenceImages objectForKey:self.missingTitle1];
    NSString *choice4 = [self.sentenceImages objectForKey:self.missingTitle2];
    self.choiceImages = [[NSArray alloc] initWithObjects:choice1,choice2,choice3,choice4, nil];
    self.choiceButtons = [[NSArray alloc] initWithObjects: self.choice1,self.choice2,self.choice3,self.choice4, nil];
    
    //Assign titles of choice buttons
    NSString *choiceTitle1 = [choice1Dict objectForKey:@"Name"];
    NSString *choiceTitle2 = [choice2Dict objectForKey:@"Name"];
    NSString *choiceTitle3 = self.missingTitle1;
    NSString *choiceTitle4 = self.missingTitle2;
    NSArray *choiceButtonTitles = [[NSArray alloc] initWithObjects: choiceTitle1,choiceTitle2,choiceTitle3, choiceTitle4, nil];
    
    self.allButtons = [[NSArray alloc] initWithObjects:self.word1,self.word2,self.word3,self.word4,self.choice1,self.choice2,self.choice3,self.choice4, nil];
    
    // Assign images for choice buttons
    
    for (int i = 0; i<[self.choiceImages count];)
    {
        for (int j = 0; j<[self.choiceButtons count];)
        {
            for (int k = 0; k<[choiceButtonTitles count]; k++)
            {
                NSString *title = [choiceButtonTitles objectAtIndex:k];
                NSString *imageName = [self.choiceImages objectAtIndex:i];
                UIImage *image = [UIImage imageNamed:imageName];
                UIButton *choiceButton = [self.choiceButtons objectAtIndex:j];
                [choiceButton setImage:image forState:UIControlStateNormal];
                [choiceButton setTitle:title forState:UIControlStateNormal];
                j++;
                i++;
            }
        }
    }
    
}

- (IBAction)finishWord1:(id)sender
{
    //NSInteger match = 1;
    if (gameWinner == true)
    {
        [self speakWinner];
        [self sendMessage:@"won"];
        [self sendMessage:self.sentenceChosen];
        [self changeToRomo];
        return;
    }
    else if (isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (isMatch == false)
    {
        [self sendMessage:@"mismatch"];
    }
    else if (isMatch == false && firstMatch == true)
    {
        [self sendMessage:@"mismatch"];
    }
    
    
}

- (IBAction)finishWord2:(id)sender
{
    NSInteger match = 1;
    if (gameWinner == true)
    {
        [self speakWinner];
        [self sendMessage:@"won"];
        [self sendMessage:self.sentenceChosen];
        [self changeToRomo];
        return;
    }
    else if (isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (isMatch == false)
    {
        [self sendMessage:@"mismatch"];
    }
    else if (self.match == match && isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (self.match == match && isMatch == false)
    {
        [self sendMessage:@"mismatch"];
    }
    
}

- (IBAction)finishWord3:(id)sender
{
    NSInteger match = 1;
    if (gameWinner == true)
    {
        [self speakWinner];
        [self sendMessage:@"won"];
        [self sendMessage:self.sentenceChosen];
        [self changeToRomo];
        return;
    }
    else if (isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (isMatch == false)
    {
        [self sendMessage:@"mismatch"];
    }
    else if (self.match == match && isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (self.match == match && isMatch == false)
    {
        [self sendMessage:@"mismatch"];
    }
    
}

- (IBAction)finishWord4:(id)sender
{
    NSInteger nomatch = 0;
    NSInteger match = 1;
    if (gameWinner == true)
    {
        [self speakWinner];
        [self sendMessage:@"won"];
        [self sendMessage:self.sentenceChosen];
        [self changeToRomo];
        return;
    }
    else if (self.match == match && isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (self.match == match && isMatch == false)
    {
        [self sendMessage:@"mismatch"];
    }
    else if (self.match == nomatch && isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (self.match == nomatch && isMatch == true)
    {
        [self sendMessage:@"mismatch"];
    }
    
}


-(IBAction)word1:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];
    
    self.guess2 = [sender currentTitle];
    [self buttonAction:&tag];
}

-(IBAction)word2:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];
    
    self.guess2 = [sender currentTitle];
    [self buttonAction:&tag];
    
}

-(IBAction)word3:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];
    
    self.guess2 = [sender currentTitle];
    [self buttonAction:&tag];
}

-(IBAction)word4:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];
    
    self.guess2 = [sender currentTitle];
    [self buttonAction:&tag];
}

-(IBAction)choice1:(id)sender
{
    [self speakString:[sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
    [self.missing1 setHighlighted:YES];
    [self.missing2 setHighlighted:YES];
}

-(IBAction)choice2:(id)sender
{
    [self speakString: [sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
    [self.missing1 setHighlighted:YES];
    [self.missing2 setHighlighted:YES];

}

-(IBAction)choice3:(id)sender
{
    [self speakString: [sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
    [self.missing1 setHighlighted:YES];
    [self.missing2 setHighlighted:YES];

}

-(IBAction)choice4:(id)sender
{
    [self speakString: [sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
    [self.missing1 setHighlighted:YES];
    [self.missing2 setHighlighted:YES];
}

- (void) buttonAction: (NSUInteger *)tag
{
    
    // If not a match for missingTitle1
    if (![self.missingTitle1 isEqualToString:self.guess2] && ![self.guess1 isEqualToString:self.guess2])
    {
        // Set missing buttons to not hightlighted
        [self.missing1 setHighlighted:NO];
        [self.missing2 setHighlighted:NO];
        
        // Check result
        [self checkResult];
    }

    // If not a match for missingTitle2
    else if (![self.missingTitle2 isEqualToString:self.guess2] && ![self.guess1 isEqualToString:self.guess2])
    {
        // Set missing buttons to not highlighted
        [self.missing1 setHighlighted:NO];
        [self.missing2 setHighlighted:NO];
        
        // Check result
        [self checkResult];
    }
    
    // If match for missingTitle1
    else if ([self.missingTitle1 isEqualToString:self.guess2] && [self.guess1 isEqualToString:self.guess2])
    {
        // Increment match int
        self.match++;
        
        // Get image name, get image, set button to image
        NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
        UIImage *buttonImage = [UIImage imageNamed:imageName];
        UIButton *button = [self.sentenceButtons objectAtIndex:*tag];
        [button setImage:buttonImage forState: UIControlStateNormal];
        UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
        
        // Hide the button that has been matched
        matchButton.hidden = YES;
        
        //Set missing buttons to not hightlighted
        [self.missing1 setHighlighted:NO];
        [self.missing2 setHighlighted:NO];
        
        // Check result
        [self checkResult];
    }
    
    // If match for missingTitle2
    else if ([self.missingTitle2 isEqualToString:self.guess2] && [self.guess1 isEqualToString:self.guess2])
    {
        // Increment match int
        self.match++;
        
        // Get image name, get image, set button to image
        NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
        UIImage *buttonImage = [UIImage imageNamed:imageName];
        UIButton *button = [self.sentenceButtons objectAtIndex:*tag];
        [button setImage:buttonImage forState: UIControlStateNormal];
        UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
        
        // Hide button that has been matched
        matchButton.hidden = YES;
        
        // Set missing buttons to not hightlighted
        [self.missing1 setHighlighted:NO];
        [self.missing2 setHighlighted:NO];
        
        // Check result
        [self checkResult];
        
    }
}


- (void) checkResult
{
    // If it is the first guess
    if (firstGuess == true)
    {
        NSLog(@"First guess: %d", firstGuess);
        
        //Possible results
        NSInteger nomatch = 0;
        NSInteger match = 1;
        
        //Set to second guess
        firstGuess = false;
        
        // Compare match value to possible results
        if (self.match == nomatch)
        {
            // If no match
            NSLog(@"No match");
            isMatch = false;
        }
        else if (self.match == match)
        {
            // If match
            NSLog(@"Match");
            isMatch = true;
            firstMatch = true;
        }
    }
    // If it is the second guess
    else if (firstGuess == false)
    {
        NSLog(@"Second guess: %d", firstGuess);
        
        //Possible results
        NSInteger win = 2;
        NSInteger match = 1;
        NSInteger nomatch = 0;
        
        // Compare match value to possible results
        if (self.match == nomatch)
        {
            // If no match
            NSLog(@"No match");
            [self sendMessage:@"mismatch"];
            gameWinner = false;
            isMatch = false;
        }
        else if (self.match == match)
        {
            // If match but not winer
            NSLog(@"Match but not winner");
            gameWinner = false;
            isMatch = true;
            firstMatch = true;
        }
        else if (self.match == win)
        {
            // Winner
            NSLog(@"Win");
            gameWinner = true;
            isMatch = false;
        }
    }
}

- (void) speakWinner
{
    [self speakString:self.sentenceChosen];
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
    sleep(1);
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
}

- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo]objectForKey:SESSION_KEY_PEER_ID];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo]objectForKey:SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"peerDisplayName = %@", peerDisplayName);
    NSLog(@"receivedMessage = %@", receivedMessage);
}

- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}

- (void) changeToRomo
{
    RomoTalkController *romoTalkController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RomoTalkController"];
    [self.navigationController pushViewController:romoTalkController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self speakString:self.sentenceChosen];
}

@end