//
//  PlayerListController.m
//  NewPlayer
//
//  Created by kwk on 2016. 5. 31..
//  Copyright © 2016년 kwk.self. All rights reserved.
//

#import "URLListViewController.h"

#import "AppDelegate.h"
#import "PlayerViewController.h"


@interface URLListViewController ()

@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) PlayerViewController *playerViewController;

- (IBAction)addAction:(id)sender;
- (IBAction)removeAction:(id)sender;

- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@end

@implementation URLListViewController

static void *URLListContext = &URLListContext;

#pragma mark Init and Dealloc

- (void)viewDidLoad {
    _appDelegate = [[NSApplication sharedApplication] delegate];
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    _playerViewController = [storyboard instantiateControllerWithIdentifier:@"playerViewController"];
    
    
    NSView* playerView = _playerViewController.view;
    _playerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:playerView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[playerView]-0-]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(self.view, playerView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[playerView]-0-|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(self.view, playerView)]];
    
    [playerView setAlphaValue:0.9f];
    //    [urlListView setHidden:YES];
    
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(doubleClickEvent:)];
    
    _urlList = [URLList sharedURLList];
    [_urlList addObserver:self forKeyPath:@"cursor" options:0 context:URLListContext];
}

- (void)dealloc {
    [_urlList removeObserver:self forKeyPath:@"cursor" context:URLListContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context == URLListContext) {
        if([keyPath isEqualToString:@"cursor"]) {
            [self loadURLListInTableView];
        }
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark TableView Controller

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_urlList countOfURLs];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if([tableColumn.identifier isEqualToString:@"name"]) {
        return [[_urlList getURL:row] lastPathComponent];
    } else if ([tableColumn.identifier isEqualToString:@"number"]) {
        return [NSString stringWithFormat:@"%ld", row + 1];
    } else {
        NSNumber *fileSizeNumber;
        [[_urlList getURL:row] getResourceValue:&fileSizeNumber
                                                      forKey:NSURLFileSizeKey
                                                       error:nil];
        long long fileSize = [fileSizeNumber longLongValue];
        NSString *displayFileSize = [NSByteCountFormatter stringFromByteCount:fileSize
                                                                   countStyle:NSByteCountFormatterCountStyleFile];
        return [NSString stringWithFormat:@"%@", displayFileSize];
    }
}

- (void)loadURLListInTableView {
    [_tableView reloadData];
    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[_urlList getRowFromCurrentCursor]] byExtendingSelection:NO];
}


#pragma mark URLList Controller

- (void)add {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSArray* fileTypes = @[@"mp3", @"mp4", @"mov"];
    
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = YES;
    panel.allowedFileTypes = fileTypes;
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if(result == NSFileHandlingPanelOKButton) {
            NSArray* _fileURLs = [panel URLs];
            
            if([_fileURLs count] > 0) {
                for(NSURL* object in _fileURLs) {
                    [_urlList addURL:object];
                }
            }
            [_urlList setCurrentCursor:0];
        }
    }];
    
    if ([_tableView numberOfRows] > 0) {
        [_tableView scrollRowToVisible:[_tableView numberOfRows] - 1];
    }
}

- (void)remove {
    if([_tableView selectedRow] != -1) {
        [_urlList removeURL:[_tableView selectedRow]];
    }
    [self loadURLListInTableView];
}

- (void)previous {
    [_urlList movingCursorToPreviousLocation];
//    [self currentURLReadyToPlayFromURLList];
}

- (void)next {
    [_urlList movingCursorToNextLocation];
//    [self currentURLReadyToPlayFromURLList];
}


#pragma mark URLList Controller Button

- (IBAction)addAction:(id)sender {
    [self add];
}

- (IBAction)removeAction:(id)sender {
    [self remove];
}

- (IBAction)previousAction:(id)sender {
    [self previous];
}

- (IBAction)nextAction:(id)sender {
    [self next];
}


#pragma mark Mouse event

- (void)doubleClickEvent:(id)sender {
    if([_tableView selectedRow] != -1) {
        [_urlList setCurrentCursor:[_tableView selectedRow]];
        
//        [self currentURLReadyToPlayFromURLList];
    }
}

@end


