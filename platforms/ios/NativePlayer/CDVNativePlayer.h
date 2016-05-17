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

enum {
    PlayerDidResumePlay,
    PlayerDidPause,
    PlayerDidFinishPlaying,
    PlayerDidFinishSeek,
    PlayerStalled,
    PlayerWindowDidClose,
};

@protocol NativePlayerViewControllerDelegate <NSObject>
@required
- (void)playerDidResumePlay;
- (void)playerDidPause;
- (void)playerDidFinishPlaying;
- (void)playerDidFinishSeek:(int)resumePositionInSeconds;
- (void)playerStalled;
- (void)playerWindowDidClose;
@end


// NoDRMPlayerViewController //
@interface NoDRMPlayerViewController : AVPlayerViewController
@property (nonatomic, weak) id <NativePlayerViewControllerDelegate> cordovaDelegate;
@end

@interface CDVNativePlayer : CDVPlugin <NativePlayerViewControllerDelegate>
@property NoDRMPlayerViewController *playerViewController;
- (void)create:(CDVInvokedUrlCommand*)command;
- (void)load:(CDVInvokedUrlCommand*)command;
- (void)play:(CDVInvokedUrlCommand*)command;
- (void)pause:(CDVInvokedUrlCommand*)command;
- (void)seek:(CDVInvokedUrlCommand*)command;
- (void)getProgress:(CDVInvokedUrlCommand*)command;
- (void)getBuffered:(CDVInvokedUrlCommand*)command;
@end

