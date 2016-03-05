//
//  SettingsController.m
//  SobotGame
//
//  Created by Laura on 29/02/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsController.h"
#import "Macros.h"

@interface SettingsController ()

@property (weak, nonatomic) IBOutlet UILabel *label_devicesFound;

- (void) peerDidChangeStateWithNotification:(NSNotification *)notification;

@end

@implementation SettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Settings";
    //[self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [[self.appDelegate mcManager]setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[self.appDelegate mcManager]advertiseItself:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:NOTIFICATION_MC_DID_CHANGE_STATE
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_browseForDevices:(id)sender
{
    [[self.appDelegate mcManager]setupMCBrowser];
    [[[self.appDelegate mcManager]browser]setDelegate:self];
    [self presentViewController:[[self.appDelegate mcManager]browser]
                       animated:YES
                     completion:nil];
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo]objectForKey:SESSION_KEY_PEER_ID];
    MCSessionState state = [[[notification userInfo]objectForKey:SESSION_KEY_STATE]intValue];
    NSLog(@"peer name = %@", peerID.displayName);
    NSLog(@"peer state = %ld", (long)state);
}

- (void) dismissBrowserView
{
    [self.appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate methods
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserView];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserView];
}

@end
