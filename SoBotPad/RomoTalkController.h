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

@property (strong, nonatomic) NSArray *talkImageViews;
@property (strong, nonatomic) NSArray *words;

@property (strong, nonatomic) NSDictionary *talkImages;

@property (weak, nonatomic) IBOutlet UIButton *playAgain;
@property (weak, nonatomic) IBOutlet UILabel *playAgainLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *talk1;
@property (weak, nonatomic) IBOutlet UIImageView *talk2;
@property (weak, nonatomic) IBOutlet UIImageView *talk3;
@property (weak, nonatomic) IBOutlet UIImageView *talk4;
@property (weak, nonatomic) IBOutlet UIImageView *talk5;


-(IBAction)playAgain:(id)sender;

@end