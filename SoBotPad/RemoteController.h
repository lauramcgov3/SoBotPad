//
//  RemoteController.h
//  SoBotPad
//
//  Created by Laura on 06/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RemoteController : UIViewController

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic) NSString *remote;

- (IBAction)happy:(id)sender;
- (IBAction)excited:(id)sender;
- (IBAction)sad:(id)sender;
- (IBAction)angry:(id)sender;
- (IBAction)confused:(id)sender;
- (IBAction)tired:(id)sender;
- (IBAction)bored:(id)sender;
- (IBAction)afraid:(id)sender;

@end
