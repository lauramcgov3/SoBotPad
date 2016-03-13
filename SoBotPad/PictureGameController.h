//
//  PictureGameController.h
//  SoBotPad
//
//  Created by Laura on 09/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureGameController : UIViewController

//Image
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//Buttons for sentence
@property (weak, nonatomic) IBOutlet UIButton *word1;
@property (weak, nonatomic) IBOutlet UIButton *word2;
@property (weak, nonatomic) IBOutlet UIButton *word3;
@property (weak, nonatomic) IBOutlet UIButton *word4;

@property (weak, nonatomic) IBOutlet UIButton *choice1;
@property (weak, nonatomic) IBOutlet UIButton *choice2;
@property (weak, nonatomic) IBOutlet UIButton *choice3;
@property (weak, nonatomic) IBOutlet UIButton *choice4;

@property (strong, nonatomic) NSArray *allSentences;
@property (strong, nonatomic) NSArray *sentenceButtons;
@property (strong, nonatomic) NSArray *choiceButtons;
@property (strong, nonatomic) NSArray *allButtons;
@property (strong, nonatomic) NSArray *animals;
@property (strong, nonatomic) NSArray *colours;
@property (strong, nonatomic) NSDictionary *sentenceImages;
@property (strong, nonatomic) NSString *sentenceChosen;
@property (strong, nonatomic) NSString *sentenceImage;



@end