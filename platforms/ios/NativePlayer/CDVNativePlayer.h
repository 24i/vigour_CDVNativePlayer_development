//
//  CDVNativePlayer.h
//  NativePlayer
//
//  Created by Stuart Grimshaw on 17/05/16.
//
//

#import <Cordova/CDV.h>
@import AVKit;
@import AVFoundation;


@interface CDVNativePlayer : CDVPlugin

@property AVPlayerViewController *playerViewController;
- (void)create:(CDVInvokedUrlCommand*)command;
- (void)load:(CDVInvokedUrlCommand*)command;
- (void)play:(CDVInvokedUrlCommand*)command;
- (void)pause:(CDVInvokedUrlCommand*)command;
- (void)seek:(CDVInvokedUrlCommand*)command;
- (void)getProgress:(CDVInvokedUrlCommand*)command;
- (void)getBuffered:(CDVInvokedUrlCommand*)command;

@end

@interface NoDRMPlayerViewController : AVPlayerViewController
@end