//
//  RomoAskController.h
//  SoBotPad
//
//  Created by Laura on 19/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface RomoAskController : UIViewController

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (strong, nonatomic) NSArray *questionImageViews;
@property (strong, nonatomic) NSArray *words;

@property (strong, nonatomic) NSDictionary *questionImages;

@property (weak, nonatomic) IBOutlet UIButton* yesButton;
@property (weak, nonatomic) IBOutlet UIButton* noButton;
@property (weak, nonatomic) IBOutlet UILabel *yesLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;


@property (weak, nonatomic) IBOutlet UIImageView *question1;
@property (weak, nonatomic) IBOutlet UIImageView *question2;
@property (weak, nonatomic) IBOutlet UIImageView *question3;
@property (weak, nonatomic) IBOutlet UIImageView *question4;
@property (weak, nonatomic) IBOutlet UIImageView *question5;
- (IBAction)yesButton:(id)sender;
-(IBAction)noButton:(id)sender;

@end