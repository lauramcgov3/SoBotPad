//
//  PictureGameController.h
//  SoBotPad
//
//  Created by Laura on 09/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface PictureGameController : UIViewController

@property (nonatomic, strong) AppDelegate *appDelegate;
//Image
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//Buttons for sentence
@property (weak, nonatomic) IBOutlet UIButton *word1;
@property (weak, nonatomic) IBOutlet UIButton *word2;
@property (weak, nonatomic) IBOutlet UIButton *word3;
@property (weak, nonatomic) IBOutlet UIButton *word4;

//Buttons for choices
@property (weak, nonatomic) IBOutlet UIButton *choice1;
@property (weak, nonatomic) IBOutlet UIButton *choice2;
@property (weak, nonatomic) IBOutlet UIButton *choice3;
@property (weak, nonatomic) IBOutlet UIButton *choice4;

// Arrays for sentences, buttons and words
@property (strong, nonatomic) NSArray *allSentences;
@property (strong, nonatomic) NSArray *sentenceButtons;
@property (strong, nonatomic) NSMutableArray *choiceButtons;
@property (strong, nonatomic) NSArray *allButtons;
@property (strong, nonatomic) NSArray *animals;
@property (strong, nonatomic) NSArray *colours;

// Dictionary of sentence images from Sentences.plist
@property (strong, nonatomic) NSDictionary *sentenceImages;

// Strings for sentence and image for that sentence chosen
@property (strong, nonatomic) NSString *sentenceChosen;
@property (strong, nonatomic) NSString *sentenceImage;

// Image views for yellow bar under sentence images
@property (weak, nonatomic) IBOutlet UIImageView *underscore1;
@property (weak, nonatomic) IBOutlet UIImageView *underscore2;
@property (weak, nonatomic) IBOutlet UIImageView *underscore3;
@property (weak, nonatomic) IBOutlet UIImageView *underscore4;


@end