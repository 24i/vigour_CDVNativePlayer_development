//
//  CDVNativePlayer.m
//  NativePlayer
//
//  Created by Stuart Grimshaw on 17/05/16.
//
//

#import "CDVNativePlayer.h"

@implementation CDVNativePlayer

- (void)create:(CDVInvokedUrlCommand*)command
{
    NSLog(NSStringFromSelector(_cmd), nil);
    
    NSString *urlString = [command argumentAtIndex:0];
    
    BOOL useDRM = false;
    // useDRM = true;
    
    if (useDRM)
    {
        NSLog(@"Better implement the DRM player, dude");
    }
    else
    {
        self.playerViewController = [NoDRMPlayerViewController new];
        self.playerViewController.cordovaDelegate = self;
        
        NSURL *url = [NSURL URLWithString:urlString]; //check for nil
        AVPlayer *player = [AVPlayer playerWithURL:url];
        self.playerViewController.player = player;
        
        NSLog(@"NativePlayer created");
        
        [(UIViewController*)UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:self.playerViewController
                                                                                                      animated:true
                                                                                                    completion:^{
            NSLog(@"NativePlayer presented");
            [player play];
            
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
    }
}

- (void)load:(CDVInvokedUrlCommand*)command { // not tested
    NSLog(NSStringFromSelector(_cmd), nil);
    
    NSString *urlString = [command argumentAtIndex:0];
    NSURL *url = [NSURL URLWithString:urlString]; //check for nil
    AVPlayer *player = [AVPlayer playerWithURL:url];
    self.playerViewController.player = player;
    NSLog(@"New player loaded");
    [player play];
}
- (void)play:(CDVInvokedUrlCommand*)command
{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self.playerViewController.player play];
}
- (void)pause:(CDVInvokedUrlCommand*)command
{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self.playerViewController.player pause];
}
- (void)seek:(CDVInvokedUrlCommand*)command
{
    NSLog(NSStringFromSelector(_cmd), nil);
    
    Float64 timeInSeconds = [[command argumentAtIndex:0] floatValue];
    CMTime cmTime = CMTimeMakeWithSeconds(timeInSeconds, self.playerViewController.player.currentItem.asset.duration.timescale);
    [self.playerViewController.player seekToTime:cmTime];
}
- (void)getProgress:(CDVInvokedUrlCommand*)command
{
    NSLog(NSStringFromSelector(_cmd), nil);
    int progressInSeconds = (int)CMTimeGetSeconds([self.playerViewController.player currentTime]);

    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:progressInSeconds];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void)getBuffered:(CDVInvokedUrlCommand*)command {
    NSLog(NSStringFromSelector(_cmd), nil);
}


// NativePlayerViewControllerDelegate,
- (void)playerDidResumePlay{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self sendCordovaEvent:PlayerDidResumePlay];
}
- (void)playerDidPause{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self sendCordovaEvent:PlayerDidPause];
}
- (void)playerDidFinishPlaying{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self sendCordovaEvent:PlayerDidFinishPlaying];
}
- (void)playerDidFinishSeek{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self sendCordovaEvent:PlayerDidFinishSeek];
}
- (void)playerStalled{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self sendCordovaEvent:PlayerStalled];
}
- (void)playerWindowDidClose{
    NSLog(NSStringFromSelector(_cmd), nil);
    [self sendCordovaEvent:PlayerWindowDidClose];
}

// forwarding events to Cordova
- (void)sendCordovaEvent:(int)event {
    NSLog(@"Event sent: %i", event);
    NSString* jsString = [NSString stringWithFormat:@"%@(\"%i\");", @"cordova.require('cordova-plugin-media.Media').onStatus", event];
    [self.commandDelegate evalJs:jsString];
}

@end

// NoDRMPlayerViewController
@interface NoDRMPlayerViewController()
@end


@implementation NoDRMPlayerViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self playerWillClose];
    
    [super viewDidDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"rate"])
    {
        if (self.player.rate == 0.0) {[self didPause];}
        else {[self didResumePlay];
        }
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        [self stalled];
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {}
    
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// interface to plugin
- (void)didResumePlay
{
    [self.cordovaDelegate playerDidResumePlay];
}
- (void)didPause
{
    [self.cordovaDelegate playerDidPause];
}
- (void)didFinishPlaying:(NSNotification*)notification
{
    [self.cordovaDelegate playerDidFinishPlaying];
}
- (void)didFinishSeek:(int)position
{
    [self.cordovaDelegate playerDidFinishSeek];
}
- (void)stalled
{
    [self.cordovaDelegate playerStalled];
}
- (void)playerWillClose
{
    [self.cordovaDelegate playerWindowDidClose];
}

@end








//