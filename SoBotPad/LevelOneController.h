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

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonViews;

@property (strong, nonatomic) NSArray *animals;


-(IBAction)tileClicked:(id)sender;

@end
