//
//  RemoteViewController.m
//  SoBotPad
//
//  Created by Laura on 21/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import "TextToSpeech.h"
#import <Foundation/Foundation.h>
#import "RemoteController.h"
#import "Macros.h"
#import "AppDelegate.h"

@interface RemoteController ()
{
    CGPoint originalCenter;
}

@end

@implementation RemoteController

@synthesize slider;


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Remote";
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (onStickChanged:)
                               name: @"StickChanged"
                             object: nil];

    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    CGAffineTransform sliderRotation = CGAffineTransformIdentity;
    sliderRotation = CGAffineTransformRotate(sliderRotation, -(M_PI / 2));
    self.slider.transform = sliderRotation;
}

- (void)viewDidAppear:(BOOL)animated {
    [self sendMessage:self.title];
    [TextToSpeech speakString:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onStickChanged:(id)notification
{
    NSDictionary *dict = [notification userInfo];
    NSValue *vdir = [dict valueForKey:@"dir"];
    CGPoint dir = [vdir CGPointValue];
    
    CGPoint newpos = playerOrigin;
    newpos.x = 30.0 * dir.x + playerOrigin.x;
    newpos.y = 30.0 * dir.y + playerOrigin.y;
    int wholeX = (int) newpos.x;
    int wholeY = (int) newpos.y;
    NSString *coordinates = [NSString stringWithFormat:@"%d %d", wholeX, wholeY];
    CGRect fr = player.frame;
    fr.origin = newpos;
    player.frame = fr;
    [self sendMessage:coordinates];
}

- (IBAction)feelings:(id)sender
{
    NSString *feelings = [sender currentTitle];
    [TextToSpeech speakString:feelings];
}


-(void)sendMessage: (NSString *)str
{
    NSString *message = str;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSString *tiltValue = [NSString stringWithFormat:@"%d", (int)sender.value];
    NSString *title = @"tilt:";
    NSString *decimal = @".00";
    NSString *tilt = [NSString stringWithFormat:@"%@ %@%@", title, tiltValue, decimal];
    [self sendMessage:tilt];
}

- (void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"reset");
    [self sendMessage:@"reset"];
}

@end
