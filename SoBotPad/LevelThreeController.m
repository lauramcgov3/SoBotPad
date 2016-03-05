//
//  MatchController.m
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;
#import "LevelThreeController.h"
#import "LevelFourController.h"
#import "Macros.h"

@interface LevelThreeController ()
//Declare Private Properties
//add a blank tile image and an image of the tile that is flipped over
@property UIImage *blankTileImage;
@property UIImage *backTileImage;



//Array of names
@property NSArray *names;

//Array of images
@property NSArray *images;

//Array of tile images
@property NSMutableArray *tiles;


//----------------------
//Dictionary of images and names
@property NSDictionary *imageDictionary;

//Dictionary of images and names
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

@implementation LevelThreeController
//Local Variables
static bool isDisabled = false;
static bool isMatch = false;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Level Three";
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *level = self.level;
    NSLog(@"%@", level);
    
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

- (void) getTiles
{
    //Get images
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Animals" ofType:@"plist"];
    self.animals = [NSArray arrayWithContentsOfFile:filePath];
    
    self.names = [self.animals valueForKey:@"Name"];
    self.images = [self.animals valueForKey:@"Image"];
    
    
    
    self.imageDictionary = [NSDictionary dictionaryWithObjects:self.images forKeys:self.names];
    NSLog(@"%@", self.imageDictionary);
    
        [self setTiles];
}

- (void)setTiles
{
    NSString *key1;
    NSString *key2;
    NSString *key3;
    NSString *key4;
    NSString *key5;
    NSString *key6;
    NSString *key7;
    NSString *key8;
    
    NSArray *array = [self.imageDictionary allKeys];
    int random1 = arc4random()%[array count];
    int random2 = arc4random()%[array count];
    int random3 = arc4random()%[array count];
    int random4 = arc4random()%[array count];
    key1 = [array objectAtIndex:random1];
    key2 = [array objectAtIndex:random1];
    key3 = [array objectAtIndex:random2];
    key4 = [array objectAtIndex:random2];
    key5 = [array objectAtIndex:random3];
    key6 = [array objectAtIndex:random3];
    key7 = [array objectAtIndex:random4];
    key8 = [array objectAtIndex:random4];
    
    NSString *img1;
    NSString *img2;
    NSString *img3;
    NSString *img4;
    NSString *img5;
    NSString *img6;
    NSString *img7;
    NSString *img8;
    
    img1 = [self.imageDictionary objectForKey:key1];
    img2 = [self.imageDictionary objectForKey:key2];
    img3 = [self.imageDictionary objectForKey:key3];
    img4 = [self.imageDictionary objectForKey:key4];
    img5 = [self.imageDictionary objectForKey:key5];
    img6 = [self.imageDictionary objectForKey:key6];
    img7 = [self.imageDictionary objectForKey:key7];
    img8 = [self.imageDictionary objectForKey:key8];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:key1,
                     key2,
                     key3,
                     key4,
                     key5,
                     key6,
                     key7,
                     key8,
                     nil];
    self.tiles = [[NSMutableArray alloc] initWithObjects:
                  [UIImage imageNamed:img1],
                  [UIImage imageNamed:img2],
                  [UIImage imageNamed:img3],
                  [UIImage imageNamed:img4],
                  [UIImage imageNamed:img5],
                  [UIImage imageNamed:img6],
                  [UIImage imageNamed:img7],
                  [UIImage imageNamed:img8],
                  nil];
    self.tileDictionary = [NSDictionary dictionaryWithObjects:self.tiles forKeys:keys];
    NSLog(@" Tile dict: %@", self.tileDictionary);
    NSLog(@"Self tiles: %@", self.tiles);
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
    //NSLog(@"%@", sender);
    
    
    NSInteger senderID = [sender tag];
    NSLog(@"Sender ID: %ld", (long)senderID);
    
    
    UIImage *flippedImage = [self.tiles objectAtIndex:senderID];
    NSLog(@"Flipped image: %@", flippedImage);
    
    
    for (NSString* key in self.tileDictionary) {
        NSLog(@"%@", [self.tileDictionary objectForKey:key]);
        if ([[self.tileDictionary objectForKey:key] isEqual:flippedImage]){
            NSString* imageName = key;
            NSLog(@"Key: %@", imageName);
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
    
    NSLog(@"%ld", (long)self.tileFlipped);
    
    if(self.tileFlipped >= 0 && senderID != self.tileFlipped)
    {
        self.tile2 = sender;
        
        NSLog(@"HERE");
        
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
        }
        isDisabled = true;
        //set up a timer to flip the tiles over after 1 sec.
        [NSTimer scheduledTimerWithTimeInterval:3.0
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
        [self sendMessage:@"match"];
    }
    else if (isMatch==false)
    {
        [self.tile1 setImage: self.backTileImage forState:UIControlStateNormal];
        [self.tile2 setImage: self.backTileImage forState:UIControlStateNormal];
        [self sendMessage:@"mismatch"];
    }
    isDisabled = false;
    isMatch = false;
        if(self.matchCounter == (self.tiles.count/2))
            [self winner];
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
    [self sendMessage:@"winner"];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Winner!"
                                  message:@"Level Three Complete"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* level = [UIAlertAction
                             actionWithTitle:@"Level 4"
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
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:level];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) changeLevel
{
    LevelFourController *levelFourController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LevelFourController"];
    [self.navigationController pushViewController:levelFourController animated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end

