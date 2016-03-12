//
//  PictureGameController.h
//  SoBotPad
//
//  Created by Laura on 09/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureGameController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *word1;
@property (weak, nonatomic) IBOutlet UIButton *word2;
@property (weak, nonatomic) IBOutlet UIButton *word3;
@property (weak, nonatomic) IBOutlet UIButton *word4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSArray *sentences;
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSArray *animals;
@property (strong, nonatomic) NSArray *colours;
@property (strong, nonatomic) NSDictionary *sentenceWords;
@property (strong, nonatomic) NSString *sentence;
@property (strong, nonatomic) NSString *sentenceImage;



@end