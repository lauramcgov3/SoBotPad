//
//  SGSViewController.h
//  SGSMultipeerVideoMixer
//
//  Created by PJ Gray on 12/29/13.
//  Copyright (c) 2013 Say Goodnight Software. All rights reserved.
//

#import "VideoController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPeer.h"

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface VideoController () <MCNearbyServiceBrowserDelegate, MCSessionDelegate, VideoPeerDelegate> {
    MCPeerID *_myDevicePeerId;
    MCSession *_session;
    MCNearbyServiceBrowser *_browser;
    
    NSMutableDictionary* _peers;
}



@end

@implementation VideoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _peers = @{}.mutableCopy;
    
    _myDevicePeerId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    _session = [[MCSession alloc] initWithPeer:_myDevicePeerId securityIdentity:nil encryptionPreference:MCEncryptionNone];
    _session.delegate = self;
    
    _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_myDevicePeerId serviceType:@"multipeer-video"];
    _browser.delegate = self;
    [_browser startBrowsingForPeers];
}

- (void)viewDidAppear:(BOOL)animated {
    //    [self showAssistant];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - MCSessionDelegate Methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected: {
            NSLog(@"PEER CONNECTED: %@", peerID.displayName);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                VideoPeer* newVideoPeer = [[VideoPeer alloc] initWithPeer:peerID];
                newVideoPeer.delegate = self;
                
                _peers[peerID.displayName] = newVideoPeer;
            });
            
            break;
        }
        case MCSessionStateConnecting:
            NSLog(@"PEER CONNECTING: %@", peerID.displayName);
            break;
        case MCSessionStateNotConnected: {
            NSLog(@"PEER NOT CONNECTED: %@", peerID.displayName);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                VideoPeer* peer = _peers[peerID.displayName];
                [peer stopPlaying];
                peer = nil;
                
                [_peers removeObjectForKey:peerID.displayName];
            });
            break;
        }
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    //    NSLog(@"(%@) Read %d bytes", peerID.displayName, data.length);
    
    NSDictionary* dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    UIImage* image = [UIImage imageWithData:dict[@"image"] scale:2.0];
    NSNumber* framesPerSecond = dict[@"framesPerSecond"];
    
    VideoPeer* thisVideoPeer = _peers[peerID.displayName];
    [thisVideoPeer addImageFrame:image withFPS:framesPerSecond];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void) browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
}

- (void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    [browser invitePeer:peerID toSession:_session withContext:nil timeout:0];
}

- (void) browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

#pragma mark - VideoPeerDelegate

- (void) showImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
}

- (void) raiseFramerateForPeer:(MCPeerID *)peerID {
    NSLog(@"(%@) raise framerate", peerID.displayName);
    NSData* data = [@"raiseFramerate" dataUsingEncoding:NSUTF8StringEncoding];
    [_session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
}

- (void) lowerFramerateForPeer:(MCPeerID *)peerID {
    NSLog(@"(%@) lower framerate", peerID.displayName);
    NSData* data = [@"lowerFramerate" dataUsingEncoding:NSUTF8StringEncoding];
    [_session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}
@end

