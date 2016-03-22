//
//  RemoteViewController.m
//  SoBotPad
//
//  Created by Laura on 21/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

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


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Remote";
    [self sendMessage:self.title];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (onStickChanged:)
                               name: @"StickChanged"
                             object: nil];

    //Set back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-key.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

- (void)viewDidAppear:(BOOL)animated {
    //    [self showAssistant];
    [self sendMessage:self.title];
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
    NSLog(@"X: %d", wholeX);
    NSLog(@"Y: %d", wholeY);
    NSString *coordinates = [NSString stringWithFormat:@"%d %d", wholeX, wholeY];
    NSLog(@"Coordinates: %@", coordinates);
    CGRect fr = player.frame;
    fr.origin = newpos;
    player.frame = fr;
    [self sendMessage:coordinates];
}


-(void)sendMessage: (NSString *)str
{
    NSLog(@"Message: %@", str);
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


@end
