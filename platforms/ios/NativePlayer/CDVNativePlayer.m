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
        self.playerViewController = [AVPlayerViewController new];
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

- (void)load:(CDVInvokedUrlCommand*)command {
    NSLog(NSStringFromSelector(_cmd), nil);
}
- (void)play:(CDVInvokedUrlCommand*)command {
    NSLog(NSStringFromSelector(_cmd), nil);
    [self.playerViewController.player play];
}
- (void)pause:(CDVInvokedUrlCommand*)command {
    NSLog(NSStringFromSelector(_cmd), nil);
    [self.playerViewController.player pause];
}
- (void)seek:(CDVInvokedUrlCommand*)command {
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

// events
- (void)didResumePlay
{
    NSLog(NSStringFromSelector(_cmd), nil);
    [(UIWebView*)self.webViewEngine stringByEvaluatingJavaScriptFromString:@"playing"]; // replace with event
}
- (void)didPause
{
    NSLog(NSStringFromSelector(_cmd), nil);
    [(UIWebView*)self.webViewEngine stringByEvaluatingJavaScriptFromString:@"paused"]; // replace with event
}
- (void)didFinishSeek:(int)position
{
    NSLog(NSStringFromSelector(_cmd), nil);
    [(UIWebView*)self.webViewEngine stringByEvaluatingJavaScriptFromString:@"seek"]; // replace with event
}
- (void)stalled
{
    NSLog(NSStringFromSelector(_cmd), nil);
    [(UIWebView*)self.webViewEngine stringByEvaluatingJavaScriptFromString:@"stalled"]; // replace with event
}

@end

@implementation NoDRMPlayerViewController

- (void)viewDidLoad
{
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"rate"]){
        
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        
    }
}

@end








//