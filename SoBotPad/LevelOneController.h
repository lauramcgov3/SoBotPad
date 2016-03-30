//
//  MatchController.h
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>


@interface LevelOneController : UIViewController
{
    // Background image outlet
    IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) AppDelegate *appDelegate;

// Tile button
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonViews;

// Animals and colours arrays
@property (strong, nonatomic) NSArray *animals;
@property (strong, nonatomic) NSArray *colours;

// Tile action
-(IBAction)tileClicked:(id)sender;

@end
