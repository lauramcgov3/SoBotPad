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

@property (nonatomic, strong) IBOutlet UISlider *slider;

- (IBAction)sliderValueChanged:(UISlider *)sender;



@end
