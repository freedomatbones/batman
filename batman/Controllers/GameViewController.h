//
//  GameViewController.h
//  batman
//
//  Created by 山口 大輔 on 2015/03/07.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

// backgroundView - gameView - myIV - enemyIV - gameLayerView

#import "ViewController.h"
#import "HPView.h"
#import "BackgroundView.h"
#import <UAProgressView.h>
#import "GameConfig.h"
#import "Person.h"
#import "Score.h"

@interface GameViewController : ViewController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>{
    
    ////////////////////////////////////////////////////////////////////////////
    // 書くオブジェクトを配置するView
    UIView *gameView;
    
    // スレッド管理系
    NSOperationQueue *queue;
    BackgroundView *backgroundView; // 背景のスレッドはBackgroundViewで管理
    NSTimer *timeTimer;
    NSTimer *myAttack1ProgressTimer;
    NSTimer *myAttack2ProgressTimer;
    NSTimer *myMoveTimer;
    NSTimer *enemyMoveTimer;
    NSTimer *myShotTimer;
    NSTimer *enemyShotTimer;
    
    // 敵の次の目的地
    NSValue *enemyDestination; // NSValue<CGPoint>敵の次の目的地
    
    // 攻撃した物体を保持NSMutableArray<UIView>
    NSMutableArray *myShots; // 弱攻撃
    NSMutableArray *enemyShots;
    
    // なんかあった時にレイヤーを設定する用のView
     UIView *gameLayerView;
    
    //ゲームオーバView
    UIView *gameoverLayer;
    
    HPView *hp;
    
    UIImageView *myIV;
    UIImageView *enemyIV;
    ///////////////////////////////////////////////////

    
    double moveX;
    double moveY;
    
    Score *score;
    
    // タイマー
    NSDate *timeStart; // ゲーム開始時刻
    NSDate *poseStart; // ポーズ開始時刻 nilならタイムしてない
    NSTimeInterval poseInterval; // ポーズしていた時間
    UIButton *labelButton;
}

// 画面遷移前に受け取る
@property (nonatomic) GameConfig* gameConfig;
@property (nonatomic) Person* myPerson;
@property (nonatomic) Person* enemyPerson;

@end

