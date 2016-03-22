//
//  RemoteViewController.h
//  SoBotPad
//
//  Created by Laura on 21/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RemoteController : UIViewController
{
    CGPoint playerOrigin;
    IBOutlet UIView *player;
}

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIButton *forward;
@property (strong, nonatomic) IBOutlet UIButton *backward;
@property (strong, nonatomic) NSString *startLocation;


@end
