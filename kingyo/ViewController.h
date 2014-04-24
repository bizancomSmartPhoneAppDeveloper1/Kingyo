//
//  ViewController.h
//  kingyo
//
//  Created by bizan.com.mac03 on 2014/03/01.
//  Copyright (c) 2014年 bizan.com.mac03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    //金魚の移動量と角度
    float vx[10];
    float vy[10];
    float angles[10];
    
    //すくい上げた時にしばらくゲームを止めるカウンター
    int stopCounter;
    
    //ゲーム中かどうか調べる
    BOOL gameflag;
    
    int score;
    
    int remaining;
    
    //金魚リスト
    NSArray *fishArray;
    
    //すくった金魚のリスト
    NSMutableArray *getFish;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *poi;
@property (weak, nonatomic) IBOutlet UIImageView *fish1;
@property (weak, nonatomic) IBOutlet UIImageView *fish2;
@property (weak, nonatomic) IBOutlet UIImageView *fish3;
@property (weak, nonatomic) IBOutlet UIImageView *fish4;
@property (weak, nonatomic) IBOutlet UIImageView *fish5;
@property (weak, nonatomic) IBOutlet UIImageView *fish6;
@property (weak, nonatomic) IBOutlet UIImageView *fish7;
@property (weak, nonatomic) IBOutlet UIImageView *fish8;
@property (weak, nonatomic) IBOutlet UIImageView *fish9;
@property (weak, nonatomic) IBOutlet UIImageView *fish10;
@property (weak, nonatomic) IBOutlet UIImageView *poiCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *endingView;
@property (weak, nonatomic) IBOutlet UIImageView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)replayGame:(UIButton *)sender;
- (IBAction)startGame:(UIButton *)sender;

@end
