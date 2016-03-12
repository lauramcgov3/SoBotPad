//
//  GamesViewController.h
//  SoBotPad
//
//  Created by Laura on 01/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesController : UIViewController

@property (nonatomic) NSString *game;

-(IBAction)matchGame:(id)sender;
-(IBAction)pictureGame:(id)sender;


@end
