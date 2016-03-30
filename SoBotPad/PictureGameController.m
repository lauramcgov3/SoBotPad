//
//  PictureGameController.m
//  SoBotPad
//
//  Created by Laura on 09/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

// Imports for class
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PictureGameController.h"
#import "MenuController.h"
#import "RomoAskController.h"
#import "Macros.h"
#import "AppDelegate.h"
#import "TextToSpeech.h"

@interface PictureGameController ()

// Interface variables
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

@end

@implementation PictureGameController

bool isMatch = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    // Set page title
    self.title = @"Picture Game";
    
    //Ensure navigate bar is not hidden
    [self.navigationController setNavigationBarHidden:NO];
    
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
    
    // Configure image with black border
    self.imageView.layer.borderWidth = 7.0;
    self.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    // Set underscores hidden when view loads
    self.underscore1.hidden = YES;
    self.underscore2.hidden = YES;
    self.underscore3.hidden = YES;
    self.underscore4.hidden = YES;
}

// Method to go back to previous controller
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Speak sentence
    [TextToSpeech speakString:self.sentenceChosen];
}

- (void) viewWillAppear:(BOOL)animated
{
    //Call first method
    [self getSentences];
}

- (void) getSentences
{
    // Get sentences from Sentences.plist
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Sentences" ofType:@"plist"];
    self.allSentences = [NSArray arrayWithContentsOfFile:filePath];
    
    // Choose a random sentence object
    int random1 = arc4random()%[self.allSentences count];
    NSDictionary *sentenceObject = [self.allSentences objectAtIndex:random1];
    
    // Get the image for random sentence object & set
    self.sentenceImage = [sentenceObject objectForKey:@"Image"];
    self.imageView.image = [UIImage imageNamed:self.sentenceImage];
    
    // Get sentence for random sentence object - speak & send
    self.sentenceChosen = [sentenceObject objectForKey:@"Sentence"];
    [self sendMessage:self.sentenceChosen];
    [self splitSentence:self.sentenceChosen];
}

// Method to split sentence into words
- (void) splitSentence: (NSString *) str
{
    self.words = [str componentsSeparatedByString:@" "];
    [self setImages:self.words];
}

// Method to set images for words
- (void) setImages: (NSArray *) arr
{
    // Buttons for sentence words
    self.sentenceButtons = [[NSArray alloc] initWithObjects:self.word1,self.word2,self.word3, self.word4,nil];
    
    // Get words from Words.plist
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.sentenceImages = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // Assign images and titles to sentence image views
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
    
    // Timer before removing buttons to fill in
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(removeButtons)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) removeButtons
{
    // Select two random words to fill other spaces
    [NSThread sleepForTimeInterval:1.5f];
    int random2 = arc4random()%[self.sentenceButtons count];
    int random3 = arc4random()%[self.sentenceButtons count];
    
    // Images views for underscore images
    NSArray *underscores = [[NSArray alloc] initWithObjects:self.underscore1,self.underscore2,self.underscore3,self.underscore4, nil];
    
    // Ensure two random buttons aren't the same
    if (random2 != random3)
    {
        // Select two random buttons
        self.missing1 = [self.sentenceButtons objectAtIndex:random2];
        self.missing2 = [self.sentenceButtons objectAtIndex:random3];
        self.missingTitle1 = [self.missing1 currentTitle];
        self.missingTitle2 = [self.missing2 currentTitle];
        
        // Show underscore for missing images
        UIImageView *setunderscore1 = [underscores objectAtIndex:random2];
        UIImageView *setunderscore2 = [underscores objectAtIndex:random3];
        setunderscore1.hidden = NO;
        setunderscore2.hidden = NO;
        
        // Replace current image of missing with placeholder image
        [self.missing1 setImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
        [self.missing2 setImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
        [self getChoices];
    }
    else if (random2 == random3)
        // Re-do method if buttons match
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
    self.choiceButtons = [[NSMutableArray alloc] initWithObjects: self.choice1,self.choice2,self.choice3,self.choice4, nil];
    
    //Assign titles of choice buttons
    NSString *choiceTitle1 = [choice1Dict objectForKey:@"Name"];
    NSString *choiceTitle2 = [choice2Dict objectForKey:@"Name"];
    NSString *choiceTitle3 = self.missingTitle1;
    NSString *choiceTitle4 = self.missingTitle2;
    NSArray *choiceButtonTitles = [[NSArray alloc] initWithObjects: choiceTitle1,choiceTitle2,choiceTitle3, choiceTitle4, nil];
    
    // Put all buttons in array
    self.allButtons = [[NSArray alloc] initWithObjects:self.word1,self.word2,self.word3,self.word4,self.choice1,self.choice2,self.choice3,self.choice4, nil];
    
    // Randomise choice buttons
    NSUInteger count = [self.choiceButtons count];
    if (count < 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.choiceButtons exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    // Assign images and titles for choice buttons
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

// Action on choice button
- (IBAction)choiceButton:(id)sender
{
    self.missing1.highlighted = YES;
    self.missing2.highlighted = YES;
    NSString *title = [sender currentTitle];
    NSLog(@"Choice title: %@", title);
    self.guess1 = title;
    NSLog(@"Guess 1: %@", self.guess1);
    
   self.guess1Tag = [sender tag];
    [TextToSpeech speakString:title];
}

// Action on sentence button when pressed down
- (IBAction)sentenceButton:(id)sender
{
    NSString *title = [sender currentTitle];
    NSUInteger tag = [sender tag];
    self.guess2 = title;
    [TextToSpeech speakString:title];
    
    if ([self.guess1 isEqualToString:self.guess2])
    {
        // Increment match int
        self.match++;
        
        //Set match to true
        isMatch = true;
        
        // Get image name, get image, set button to image
        NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
        UIImage *buttonImage = [UIImage imageNamed:imageName];
        UIButton *button = [self.sentenceButtons objectAtIndex:tag];
        [button setImage:buttonImage forState: UIControlStateNormal];
        UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
        
        // Hide button that has been matched
        matchButton.hidden = YES;
        
        // Set missing buttons to not hightlighted
        [self.missing1 setHighlighted:NO];
        [self.missing2 setHighlighted:NO];
    }
    else if (![self.guess1 isEqualToString:self.guess2])
    {
        // If not a match, un-highlight buttons
        isMatch = false;
        [self.missing1 setHighlighted:NO];
        [self.missing2 setHighlighted:NO];
    }
}

// Action on sentence button when released
- (IBAction)finishSentenceButton:(id)sender
{
    NSInteger win = 2;
    
    if (self.match == win)
    {
        [self changeToRomoAsk];
    }
    else if (isMatch == true)
    {
        [self sendMessage:@"match"];
    }
    else if (isMatch == false)
    {
        [self sendMessage:@"mismatch"];
    }
}


// Action for listen again button
-(IBAction)listenAgain:(id)sender
{
    [TextToSpeech speakString:self.sentenceChosen];
}

// Send message over mutlipeer function
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
}

// Home button action
- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
}

// Change to Romo Ask view when game is won
- (void) changeToRomoAsk
{
    RomoAskController *romoAskController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RomoAskController"];
    [self.navigationController pushViewController:romoAskController animated:YES];
}

// When view disappears
- (void) viewWillDisappear:(BOOL)animated
{
    // Remove notification center for multipeer connectivity
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                                  object:nil];
}

@end