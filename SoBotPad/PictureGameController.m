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


@end
@implementation PictureGameController


static bool firstGuess = true;
static bool gameWinner = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Picture Game";
    [self getSentences];
    
    UIBarButtonItem *HomeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Home"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(home)];
    [[self navigationItem] setRightBarButtonItem:HomeButton];
    
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
                NSLog(@"Title: %@", title);
                
                
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


-(IBAction)word1:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];
    self.guess2 = [sender currentTitle];
    
    if (self.guess1 == NULL) {
        return;
    }
    else if ([self.missingTitle1 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
            }
        }
    }
    else if ([self.missingTitle2 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
            }
        }
    }
}

-(IBAction)word2:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];
    self.guess2 = [sender currentTitle];
    
    if (self.guess1 == NULL) {
        return;
    }
    else if ([self.missingTitle1 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
            }
        }
    }
    else if ([self.missingTitle2 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
            }
        }
    }
}

-(IBAction)word3:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];
    self.guess2 = [sender currentTitle];
    
    if (self.guess1 == NULL) {
        return;
    }
    else if ([self.missingTitle1 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
                
            }
        }
    }
    else if ([self.missingTitle2 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
            }
        }
    }
}

-(IBAction)word4:(id)sender
{
    [self speakString:[sender currentTitle]];
    NSUInteger tag = [sender tag];

    self.guess2 = [sender currentTitle];
    
    if (self.guess1 == NULL) {
        return;
    }
    else if ([self.missingTitle1 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
            }
        }
    }
    else if ([self.missingTitle2 isEqualToString:self.guess2])
    {
        if ([self.guess1 isEqualToString:self.guess2])
        {
            self.guess2 = [sender currentTitle];
            
            if (self.guess1 == NULL) {
                return;
            }
            else if ([self.guess1 isEqualToString:self.guess2])
            {
                self.match++;
                NSString *imageName = [self.sentenceImages objectForKey:self.guess2];
                UIImage *buttonImage = [UIImage imageNamed:imageName];
                UIButton *button = [self.sentenceButtons objectAtIndex:tag];
                [button setImage:buttonImage forState: UIControlStateNormal];
                UIButton *matchButton = [self.allButtons objectAtIndex:self.guess1Tag];
                matchButton.hidden = YES;
                [self checkWinner];
            }
        }
    }
}

-(IBAction)choice1:(id)sender
{
    [self speakString:[sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
}

-(IBAction)choice2:(id)sender
{
    [self speakString: [sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
}

-(IBAction)choice3:(id)sender
{
    [self speakString: [sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
}

-(IBAction)choice4:(id)sender
{
    [self speakString: [sender currentTitle]];
    self.guess1 = [sender currentTitle];
    self.guess1Tag = [sender tag];
}


- (void) checkWinner
{
    NSLog(@"First guess: %d", firstGuess);
    if (firstGuess == true)
    {
        NSLog(@"First Guess");
        firstGuess = false;
        return;
    }
    else if (firstGuess == false)
    {
        NSLog(@"Second Guess");
        NSInteger win = 2;
        
        if (self.match == win)
        {
            NSLog(@"Winner");
            gameWinner = true;
            [self checkWinner];
        }
    }
    else if (gameWinner == true)
    {
        [self winner];
        return;
        
    }
    return;
    

}

- (void) winner
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

- (void) home
{
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self speakString:self.sentenceChosen];
}

@end