//
//  JoyStickController.m
//  SoBotPad
//
//  Created by Laura on 22/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//


#import "JoyStickController.h"

#define STICK_CENTER_TARGET_POS_LEN 20.0f

@implementation JoyStickView

-(void) initStick
{
    imgStickNormal = [UIImage imageNamed:@"stick-normal.png"];
    imgStickHold = [UIImage imageNamed:@"stick-hold.png"];
    //    stickView.image = imgStickNormal;
    mCenter.x = 80;
    mCenter.y = 80u;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initStick];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        // Initialization code
        [self initStick];
    }
    
    return self;
}

- (void)dealloc {
    
    //[super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)notifyDir:(CGPoint)dir
{
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSValue *vdir = [NSValue valueWithCGPoint:dir];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              vdir, @"dir", nil];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"StickChanged" object:nil userInfo:userInfo];
    
    //[pool release];
}

- (void)stickMoveTo:(CGPoint)deltaToCenter
{
    CGRect fr = stickButtonView.frame;
    NSLog(@"FR: %@", NSStringFromCGRect(fr));
    fr.origin.x = deltaToCenter.x;
    fr.origin.y = deltaToCenter.y;
    stickButtonView.frame = fr;
}

- (void)touchEvent:(NSSet *)touches
{
    
    if([touches count] != 1)
        return ;
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self)
        return ;
    
    CGPoint touchPoint = [touch locationInView:view];
    CGPoint dtarget, dir;
    dir.x = touchPoint.x - mCenter.x;
    dir.y = touchPoint.y - mCenter.y;
    double len = sqrt(dir.x * dir.x + dir.y * dir.y);
    
    if(len < 10.0 && len > -10.0)
    {
        // center pos
        dtarget.x = 0.0;
        dtarget.y = 0.0;
        dir.x = 0;
        dir.y = 0;
    }
    else
    {
        double len_inv = (1.0 / len);
        dir.x *= len_inv;
        dir.y *= len_inv;
        dtarget.x = dir.x * STICK_CENTER_TARGET_POS_LEN;
        dtarget.y = dir.y * STICK_CENTER_TARGET_POS_LEN;
    }
    [self stickMoveTo:dtarget];
    
    [self notifyDir:dir];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    stickButtonView.image = [UIImage imageNamed:@"stick-hold.png"];
    [self touchEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEvent:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    stickButtonView.image = [UIImage imageNamed:@"stick-normal.png"];
    CGPoint dtarget, dir;
    dir.x = dtarget.x = 0.0;
    dir.y = dtarget.y = 0.0;
    [self stickMoveTo:dtarget];
    
    [self notifyDir:dir];
}

@end

