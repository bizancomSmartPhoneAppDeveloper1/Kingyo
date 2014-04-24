//
//  ViewController.m
//  kingyo
//
//  Created by bizan.com.mac03 on 2014/03/01.
//  Copyright (c) 2014年 bizan.com.mac03. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    fishArray = [NSArray arrayWithObjects:
                 self.fish1,self.fish2,self.fish3,self.fish4,self.fish5,
                 self.fish6,self.fish7,self.fish8,self.fish9,self.fish10,nil];
    
    [self dispTitle];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(mainloop) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate //横に倒しても回転しない
{
    return NO;
}

-(void)dispTitle
{
    gameflag = NO;
    
    self.startBtn.hidden = NO;
    self.titleView.hidden = NO;
    
    self.endingView.hidden = YES;
    self.replayBtn.hidden = YES;
    
}

-(void)startGame
{
    [self initGame];
    
    self.startBtn.hidden = YES;
    self.titleView.hidden = YES;
    
    score = 0;
    remaining = 5;
    self.scoreLabel.text = [NSString stringWithFormat:@"0匹"];
    [self.poiCount setImage:[UIImage imageNamed:[NSString stringWithFormat:@"prest%d.png",remaining]]];
    self.poi.center = CGPointMake(225, 385);
    
    gameflag = YES;
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event //タッチし始めた時
{
    //タッチした位置(touches)を調べる
    UITouch *touch = [touches anyObject];
    //画面上での位置に変換して(location)に入れる
    CGPoint location = [touch locationInView:self.view];
    
    //touchesBeganで必要な処理
    [super touchesBegan:touches withEvent:event];
    
    if (gameflag == NO)
    {
        return;
    }
    
    if (0 < stopCounter) //すくい上げている時は、ゲームを止める
    {
        return;
    }
    
    //ポイをタップした位置に移動する
    self.poi.center = CGPointMake(location.x - 50, location.y - 50);
    
    //ボイの絵を変化させる
    [self.poi setImage:[UIImage imageNamed:@"poi2.png"]];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event //タッチして動かした時
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    //touchesMovedを行った時に必要な処理
    [super touchesMoved:touches withEvent:event];
    
    if (gameflag == NO)
    {
        return;
    }
    
    if (0 < stopCounter)
    {
        return;
    }
    
    self.poi.center = CGPointMake(location.x - 50, location.y - 50);
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event //タッチしていた指を離した時
{
    //touchesEndedを行った時に必要な処理
    [super touchesEnded:touches withEvent:event];
    
    if (gameflag == NO)
    {
        return;
    }
    
    if (0 < stopCounter)
    {
        return;
    }
    
    getFish = [NSMutableArray array];
    
    for (int i = 0; i < fishArray.count; i++)
    {
        UIImageView *w_fish = [fishArray objectAtIndex:i];
        
            //金魚とポイの距離を調べる
        float dx = abs(w_fish.center.x - self.poi.center.x);//absで(w_fish.center.x - self.poi.center.x)の絶対値を求める
        float dy = abs(w_fish.center.y - self.poi.center.y);
        float dist = sqrtf(dx * dx + dy * dy); //sqrtfで平方根を求める
        
        //金魚とポイの距離が４０以下なら
        if (dist < 40)
        {
            [getFish addObject:w_fish]; //すくい上げたリストに入れる
            w_fish.alpha = 1.0;
            CGAffineTransform tf = w_fish.transform;
            w_fish.transform = CGAffineTransformScale(tf, 2, 2); //tfを縦横２倍にする
            
            score++;
            self.scoreLabel.text = [NSString stringWithFormat:@"%d匹",score];
        }
    }
    
    //ポイの絵を変化させる
    [self.poi setImage:[UIImage imageNamed:@"poi1.png"]];
    self.poi.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    stopCounter = 30; //すくい上げたので、カウンターを停止させる
    
}

-(void)initGame //ゲームの初期化
{
    stopCounter = 0;
    
    for (int i = 0; i < fishArray.count; i++)
    {
        UIImageView *w_fish = [fishArray objectAtIndex:i];
        
        //金魚にタグ付けする
        w_fish.tag = i;
        
        [self initFish:w_fish];
    }
    
}

-(void)initFish:(UIImageView *)w_fish //金魚の初期化
{
    //金魚のタグを調べる
    int wid = w_fish.tag;
    
    //金魚の位置をランダムにする
    int x = arc4random() % 280 + 20;
    int y = arc4random() % 400 + 40;
    
    w_fish.center = CGPointMake(x, y);
    
    //金魚の向き、スピードをランダムにして、番号を使って保存する
    float spd = arc4random() % 12 + 1;
    float angle = arc4random() % 360;
    float rad = angle * M_PI / 180.0; //M_PIは、円周率を表す　angle*M_PI/180.0で、angle度回転するという意味
    vx[wid] = cosf(rad) * spd;
    vy[wid] = sin(rad) * spd;
    angles[wid] = angle;
    
    //金魚の向きを決定した角度に向ける
    w_fish.transform = CGAffineTransformMakeRotation(angle * M_PI / 180.0);
    
    //水中にいる時は、金魚を半透明にする
    w_fish.alpha = 0.5;
    
}

-(void)mainloop //ゲーム中に繰り返す処理
{
    if (gameflag == NO)
    {
        return;
    }
    
    if (stopCounter == 0)
        //金魚を少し移動させた位置を調べる
    {
        for (int i = 0; i < fishArray.count; i++)
        {
            UIImageView *w_fish = [fishArray objectAtIndex:i];
            
            //番号から移動スピードを調べて(vx,vy)、少し移動させた位置を求める
            float wx = w_fish.center.x + vx[w_fish.tag];
            float wy = w_fish.center.y + vy[w_fish.tag];
            
            //位置が水槽からはみ出していたら、反対側に移動する
            if (340 < wx)
            {
                wx = -10;
            }
            if (wx < -20)
            {
                wx = 330;
            }
            if (500 < wy)
            {
                wy = -10;
            }
            if (wy < -20)
            {
                wy = 490;
            }
            
            //金魚を指定した位置に移動させる
            w_fish.center = CGPointMake(wx, wy);
        }
    }
    else if (0 < stopCounter)
    {
        //すくい上げた時は、ゲームを一時停止して、カウントダウン
        stopCounter--;
        
        if (stopCounter == 0) //カウントがゼロになったら
        {
            for (int i = 0; i < getFish.count; i++) //すくい上げたリストの金魚を元の大きさにして別の所に再登場させる
            {
                UIImageView *w_fish = [getFish objectAtIndex:i];
                w_fish.transform = CGAffineTransformIdentity;
                [self initFish:w_fish];
            }
            
            //ポイをもとの大きさに戻す
            self.poi.transform = CGAffineTransformIdentity;
            
            remaining--; //残り回数を減らす
            [self.poiCount setImage:[UIImage imageNamed:[NSString stringWithFormat:@"prest%d.png",remaining]]];
            
            if (remaining == 0)
            {
                gameflag = NO;
                self.replayBtn.hidden = NO;
                self.endingView.hidden = NO;
            }
        }
    }
}


- (IBAction)replayGame:(UIButton *)sender
{
    [self dispTitle];
}

- (IBAction)startGame:(UIButton *)sender
{
    [self startGame];
}

@end
