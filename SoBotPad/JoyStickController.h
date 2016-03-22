//
//  JoyStickController.h
//  SoBotPad
//
//  Created by Laura on 22/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoyStickView : UIView
{
    IBOutlet UIImageView *baseStickView;
    IBOutlet UIImageView *stickButtonView;
    
    UIImage *imgStickNormal;
    UIImage *imgStickHold;
    
    CGPoint mCenter;
}

@end
