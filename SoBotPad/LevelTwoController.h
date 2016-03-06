//
//  MatchController.h
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>


@interface LevelTwoController : UIViewController
{
    IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonViews;

@property (strong, nonatomic) NSArray *animals;
@property (strong, nonatomic) NSArray *colours;

@property (nonatomic) NSString *level;

-(void)home;

-(IBAction)tileClicked:(id)sender;

@end
