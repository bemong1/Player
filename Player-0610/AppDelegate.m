//
//  AppDelegate.m
//  Player-0610
//
//  Created by kwk on 2016. 6. 10..
//  Copyright © 2016년 kwk.self. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)open {
    NSLog(@"test");
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSArray* fileTypes = @[@"mp3", @"mp4", @"mov"];
    
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = YES;
    panel.allowedFileTypes = fileTypes;
    
    panel.canResolveUbiquitousConflicts = NO;
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if(result == NSFileHandlingPanelOKButton) {
            //            [_urlList clear];
            NSArray* _fileURLs = [panel URLs];
            
            if([_fileURLs count] > 0) {
                
            }
        }
    }];
}

- (IBAction)openAction:(id)sender {
    [self open];
}

@end
