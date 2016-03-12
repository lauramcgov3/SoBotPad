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

@property UIButton *missing1;
@property UIButton *missing2;

@end
@implementation PictureGameController


//static bool isLoaded = false;

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


}

- (void) getSentences
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Sentences" ofType:@"plist"];
    self.sentences = [NSArray arrayWithContentsOfFile:filePath];
    
    int random1 = arc4random()%[self.sentences count];
    NSDictionary *sentenceObject = [self.sentences objectAtIndex:random1];
    
    self.sentenceImage = [sentenceObject objectForKey:@"Image"];
    
    self.imageView.image = [UIImage imageNamed:self.sentenceImage];
    
    self.sentence = [sentenceObject objectForKey:@"Sentence"];
    [self splitSentence:self.sentence];
    
}

- (void) splitSentence: (NSString *) str
{
    NSArray * words = [str componentsSeparatedByString:@" "];
    [self setImages:words];
}

- (void) setImages: (NSArray *) arr
{
    self.buttons = [[NSArray alloc] initWithObjects:self.word1,self.word2,self.word3, self.word4,nil];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    self.sentenceWords = [NSDictionary dictionaryWithContentsOfFile:filePath];


    for (int i = 0; i<[arr count];)
    {
        for (int j = 0; j<[self.buttons count]; j++)
        {
            NSString *word = [arr objectAtIndex:i];
            NSString *imageName = [self.sentenceWords objectForKey:word];
            UIImage *buttonImage = [UIImage imageNamed:imageName];
            UIButton *button = [self.buttons objectAtIndex:j];
            [button setTitle:word forState:UIControlStateNormal];
            [button setImage:buttonImage forState: UIControlStateNormal];
            i++;
            
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:7.0
                                     target:self
                                   selector:@selector(removeButtons)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) removeButtons
{
    int random2 = arc4random()%[self.buttons count];
    int random3 = arc4random()%[self.buttons count];
    
    NSLog(@"%d", random2);
    NSLog(@"%d", random3);
    
    
    if (random2 != random3) {
        NSLog(@"IF");
        self.missing1 = [self.buttons objectAtIndex:random2];
        self.missing2 = [self.buttons objectAtIndex:random3];
        
        [self.missing1 setImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
        [self.missing2 setImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
    }
    else if (random2 == random3)
        [self removeButtons];
}

- (void) getChoices
{
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"Animals" ofType:@"plist"];
    self.animals = [NSArray arrayWithContentsOfFile:filePath1];
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"Colours" ofType:@"plist"];
    self.colours = [NSArray arrayWithContentsOfFile:filePath2];
}

-(IBAction)word1:(id)sender
{
    [self speakString:[sender currentTitle]];
}

-(IBAction)word2:(id)sender
{
    [self speakString: [sender currentTitle]];
}

-(IBAction)word3:(id)sender
{
    [self speakString: [sender currentTitle]];
}

-(IBAction)word4:(id)sender
{
    [self speakString: [sender currentTitle]];
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
    [self speakString:self.sentence];
}

@end