//
//  RomoTalkController.h
//  SoBotPad
//
//  Created by Laura on 13/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface RomoTalkController : UIViewController

@property (nonatomic, strong) AppDelegate *appDelegate;

// Image views and words for "talking"
@property (strong, nonatomic) NSArray *talkImageViews;
@property (strong, nonatomic) NSArray *words;

// Dictionary of talk images
@property (strong, nonatomic) NSDictionary *talkImages;

// Yes and no buttons and labels
@property (weak, nonatomic) IBOutlet UIButton *playAgain;
@property (weak, nonatomic) IBOutlet UILabel *playAgainLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;

// Image views for "talking"
@property (weak, nonatomic) IBOutlet UIImageView *talk1;
@property (weak, nonatomic) IBOutlet UIImageView *talk2;
@property (weak, nonatomic) IBOutlet UIImageView *talk3;
@property (weak, nonatomic) IBOutlet UIImageView *talk4;
@property (weak, nonatomic) IBOutlet UIImageView *talk5;

// Play again button action
-(IBAction)playAgain:(id)sender;

@end