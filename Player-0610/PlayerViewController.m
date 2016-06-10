//
//  PlayerViewController.m
//  Player-0610
//
//  Created by kwk on 2016. 6. 10..
//  Copyright © 2016년 kwk.self. All rights reserved.
//

#import "PlayerViewController.h"

#import "CALayer+AddMethod.h"


@interface PlayerViewController ()


- (IBAction)playAction:(id)sender;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setWantsLayer:YES];
    [self.view.layer backgroundColorRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    
    _playerController = [[PlayerController alloc]initWithMediaFileURL:[NSURL URLWithString:@"file:///Users/kwk/Downloads/sample_studio.MP4"] andRect:self.view.bounds];
    [self.view addSubview:_playerController];
}


- (IBAction)playAction:(id)sender {
    [_playerController play];
}
@end
