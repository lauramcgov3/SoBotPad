//
//  MatchController.m
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;
#import "LevelOneController.h"
#import "LevelTwoController.h"
#import "Macros.h"
#import "AppDelegate.h"
#import "LevelController.h"

@interface LevelOneController ()
//Declare Private Properties
//add a blank tile image and an image of the tile that is flipped over
@property UIImage *blankTileImage;
@property UIImage *backTileImage;



//Array of names if images
@property NSArray *names;

//Array of images
@property NSArray *images;

//Array of tile images
@property NSMutableArray *tiles;

//Dictionary of images and names
@property NSDictionary *imageDictionary;

//Dictionary of images and names for tiles
@property NSDictionary *tileDictionary;

//Array of shuffled tile IDs
@property NSMutableArray *shuffledTiles;

//How many times did the player get a match
@property NSInteger matchCounter;

//How many times did the player guess
@property NSInteger guessCounter;

//The ID of the first flipped tile
@property NSInteger tileFlipped;

//The first button object that was clicked
@property UIButton *tile1;

//The second button object that was clicked
@property UIButton *tile2;

//Instance Methods
- (void)getTiles;
- (void)setTiles;
- (void)shuffleTiles;
- (void)resetTiles;
- (void) winner;
@end

@implementation LevelOneController

//Local Variables
static bool isDisabled = false;
static bool isMatch = false;
static bool isWinner = false;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Level One";
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //Set home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home-bar"] style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    [self.navigationItem setRightBarButtonItem:homeButton];
    
    //Assign images to the blank and back image properties
    self.backTileImage = [UIImage imageNamed:@"cardbkg.jpg"];
    self.blankTileImage = [UIImage imageNamed:@"blank.png"];
    
    //Set the tile flipped variable less than zero so we know that a tile has not been clicked yet
    self.tileFlipped = -1;
    
    //set our guesses and matches to zero
    self.matchCounter = 0;
    self.guessCounter = 0;
    
    [self getTiles];
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getTiles
{
    //get & define category
    NSString *anis = @"animals";
    NSString *cols = @"colours";
    NSString *category =self.appDelegate.category;
    NSLog(@"%@", category);
    
    //Get images
    
    if ([category isEqualToString:anis])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Animals" ofType:@"plist"];
        self.animals = [NSArray arrayWithContentsOfFile:filePath];
        NSLog(@"Animals: %@", self.animals);
        self.names = [self.animals valueForKey:@"Name"];
        self.images = [self.animals valueForKey:@"Image"];
        NSLog(@"%@", self.names);
        NSLog(@"%@", self.images);
        UIImage *img1 = [UIImage imageNamed:@"animalsbkg.png"];
        [imageView setImage:img1];
        
    }
    else if ([category isEqualToString:cols])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Colours" ofType:@"plist"];
        self.colours = [NSArray arrayWithContentsOfFile:filePath];
        NSLog(@"Colours: %@", self.colours);
        self.names = [self.colours valueForKey:@"Name"];
        self.images = [self.colours valueForKey:@"Image"];
        NSLog(@"%@", self.names);
        NSLog(@"%@", self.images);
        UIImage *img1 = [UIImage imageNamed:@"colour-bkg.png"];
        [imageView setImage:img1];
    }
    
    
    self.imageDictionary = [NSDictionary dictionaryWithObjects:self.images forKeys:self.names];
    [self setTiles];
}

- (void) setTiles
{

    NSString *key1;
    NSString *key2;
    NSString *key3;
    NSString *key4;
    
    NSArray *array = [self.imageDictionary allKeys];
    int random1 = arc4random()%[array count];
    int random2 = arc4random()%[array count];
    key1 = [array objectAtIndex:random1];
    key2 = [array objectAtIndex:random1];
    key3 = [array objectAtIndex:random2];
    key4 = [array objectAtIndex:random2];
    
    
    NSString *img1;
    NSString *img2;
    NSString *img3;
    NSString *img4;
    
    img1 = [self.imageDictionary objectForKey:key1];
    img2 = [self.imageDictionary objectForKey:key2];
    img3 = [self.imageDictionary objectForKey:key3];
    img4 = [self.imageDictionary objectForKey:key4];

    
    NSArray *keys = [[NSArray alloc] initWithObjects:key1, key2, key3, key4, nil];
    self.tiles = [[NSMutableArray alloc] initWithObjects:
                  [UIImage imageNamed:img1],
                  [UIImage imageNamed:img2],
                  [UIImage imageNamed:img3],
                  [UIImage imageNamed:img4],
                  nil];
    self.tileDictionary = [NSDictionary dictionaryWithObjects:self.tiles forKeys:keys];
    
    [self shuffleTiles];
}


- (void)shuffleTiles
{
    
    NSUInteger tileCount = [self.tiles count];
    
    
    self.shuffledTiles = [[NSMutableArray alloc] init];
    
    for (int tileID = 0; tileID < (tileCount/2); tileID++)
    {
        [self.shuffledTiles addObject:[NSNumber numberWithInt:tileID]];
        [self.shuffledTiles addObject:[NSNumber numberWithInt:tileID]];
    }
    
    for (NSUInteger i = 0; i < tileCount; ++i) {
        NSInteger nElements = tileCount - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self.shuffledTiles exchangeObjectAtIndex:i withObjectAtIndex:n];
        [self.tiles exchangeObjectAtIndex:i withObjectAtIndex:n];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)tileClicked:(id)sender
{
    
    if(isDisabled == true)
        return;
    
    
    NSInteger senderID = [sender tag];
    NSLog(@"Sender ID: %ld", (long)senderID);
    
    
    UIImage *flippedImage = [self.tiles objectAtIndex:senderID];
    
    
        for (NSString* key in self.tileDictionary) {
            if ([[self.tileDictionary objectForKey:key] isEqual:flippedImage]){
                AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:key ];
                utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-gb"];
                utterance.rate = 0.40;
                [synthesizer speakUtterance:utterance];
            }
    
        }
        NSError* error;
        if (error)
            NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
    
    if(self.tileFlipped >= 0 && senderID != self.tileFlipped)
    {
        self.tile2 = sender;
        
        UIImage *lastImage = [self.tiles objectAtIndex:self.tileFlipped];
        UIImage *tileImage = [self.tiles objectAtIndex:senderID];
        
        
        [sender setImage: tileImage forState:UIControlStateNormal];
        self.guessCounter++;
        if([tileImage isEqual:lastImage])
        {
            [self.tile1 setEnabled:false];
            [self.tile2 setEnabled:false];
            self.matchCounter++;
            isMatch = true;
            
            if(self.matchCounter == (self.tiles.count/2))
            {
                NSLog(@"Winner if");
                isWinner = true;
            }
            
        }
        
        if (isMatch == true && isWinner==false)
        {
            [self sendMessage:@"match"];
        }
        else if (isMatch == false)
        {
            [self sendMessage:@"mismatch"];
        }
        else if(self.matchCounter == (self.tiles.count/2))
        {
            [self winner];
            [self sendMessage:@"winner"];
        }
        
        isWinner = false;
        isDisabled = true;
        //set up a timer to flip the tiles over after 1 sec.
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(resetTiles)
                                       userInfo:nil
                                        repeats:NO];
        self.tileFlipped = -1;
    }
    else
    {
        
        self.tileFlipped = senderID;
        self.tile1 = sender;
        UIImage *tileImage = [self.tiles objectAtIndex:senderID];
        [sender setImage: tileImage forState:UIControlStateNormal];
    }
    
}

- (void)resetTiles
{
    
    if(isMatch==true)
    {
        self.tile1.hidden = YES;
        self.tile2.hidden = YES;
    }
    else if (isMatch==false)
    {
        [self.tile1 setImage: self.backTileImage forState:UIControlStateNormal];
        [self.tile2 setImage: self.backTileImage forState:UIControlStateNormal];
    }
    isDisabled = false;
    isMatch = false;
}

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


- (void) winner
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Winner!"
                                  message:@"Level One Complete"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* level = [UIAlertAction
                         actionWithTitle:@"Level 2"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self changeLevel];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self cancel];
                                 
                             }];
    
    [alert addAction:level];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) changeLevel
{
    LevelTwoController *levelTwoController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LevelTwoController"];
    [self.navigationController pushViewController:levelTwoController animated:YES];
    
}

- (void) cancel
{
    LevelController *levelController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LevelController"];
    [self.navigationController pushViewController:levelController animated:YES];
    
}

- (void) home
{
    NSLog(@"HOME");
    MenuController *menuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuController"];
    [self.navigationController pushViewController:menuController animated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end

