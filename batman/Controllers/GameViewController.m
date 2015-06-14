//
//  GameViewController.m
//  batman
//
//  Created by 山口 大輔 on 2015/03/07.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "GameViewController.h"
#import "ResultViewController.h"
#import "SoundPlayer.h"

@interface GameViewController ()

@property UAProgressView *progressView1;
@property UAProgressView *progressView2;
@property UIImageView *dPadView;

@property (nonatomic, assign) BOOL shot1;
@property (nonatomic, assign) CGFloat localProgress1;
@property (nonatomic, assign) BOOL shot2;
@property (nonatomic, assign) CGFloat localProgress2;

@end

@implementation GameViewController

const int GRID_X_LENGTH = 5;

typedef NS_ENUM(NSInteger, AttackType)
{
    LIGHT = 1,
    MIDDLE = 10,
    STRONG = 30,
    KILL = 100
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景設定
    backgroundView = [[BackgroundView alloc] initWithFrame:self.view.frame];
    backgroundView.layer.zPosition = 0;
    [self.view addSubview: backgroundView];
    
    [self initGame];
}

- (void)viewDidAppear:(BOOL)animated {
    [self gameReadyGo];
}

- (void)viewWillAppear:(BOOL)animated {
//    [SoundPlayer playMusic:self.gameConfig.sound];
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueResult"]) {
        ResultViewController *viewCon = segue.destinationViewController;
        viewCon.score = score;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////
/* 初期化処理 *///////////////////////////////////////////////////////////////////

- (void)clearGame {
    [gameView removeFromSuperview];
    gameView = nil;
    _progressView1 = nil;
    _progressView2 = nil;
    _dPadView = nil;
    _shot1 = nil;
    _shot2 = nil;
    
    queue = nil;
   // backgroundView = nil;
    myAttack1ProgressTimer = nil;
    myAttack2ProgressTimer = nil;
    myMoveTimer = nil;
    enemyMoveTimer = nil;
    myShotTimer = nil;
    enemyShotTimer = nil;
    enemyDestination = nil;
    myShots = nil; // 弱攻撃
    enemyShots = nil;
    gameLayerView = nil;
    hp = nil;
    myIV = nil;
    enemyIV = nil;
//    myEmitterLayer = nil;
//    enemyEmitterLayer = nil;
    score = nil;
    timeStart = nil; // ゲーム開始時刻
    poseStart = nil; // ポーズ開始時刻 nilならタイムしてない
    labelButton = nil;
}


- (void)initGame {
    [SoundPlayer playMusic:self.gameConfig.sound];
    queue = [[NSOperationQueue alloc] init];

    // 画面の土台
    gameView = [[UIView alloc] initWithFrame:self.view.frame];
    gameView.opaque = NO;
    gameView.layer.zPosition = 10;
    [self.view addSubview:gameView];
    
    // エフェクトや画面全体を染める時用のView
    gameLayerView = [[UIView alloc] initWithFrame:self.view.frame];
    gameLayerView.opaque = NO;
    gameLayerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    gameLayerView.layer.zPosition = 100;
    [gameView addSubview:gameLayerView];
    
    // HPBar設定
    hp = [[HPView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    hp.myLabel.text    = _myPerson.name;
    hp.enemyLabel.text = _enemyPerson.name;
    hp.layer.zPosition = 30;
    [gameView addSubview: hp];
    
    //初期化
    myShots    = [[NSMutableArray alloc]init];
    enemyShots = [[NSMutableArray alloc]init];
    
    
    
    
    
    [self initMyObject];
    
    [self createEnemy];
    
    _progressView1 = [[UAProgressView alloc]initWithFrame: CGRectMake(100, 100, 50, 50)];
    _progressView1.center = CGPointMake(self.view.bounds.size.width-_progressView1.frame.size.width,
                                        self.view.bounds.size.height-_progressView1.frame.size.height*2);
    _progressView1.layer.zPosition = 30;
    [self setupProgressView1];
    [gameView addSubview: _progressView1];
    
    _progressView2 = [[UAProgressView alloc]initWithFrame: CGRectMake(100, 100, 50, 50)];
    _progressView2.center = CGPointMake(self.view.bounds.size.width-_progressView2.frame.size.width*2,
                                        self.view.bounds.size.height-_progressView2.frame.size.height*1);
    _progressView2.layer.zPosition = 30;
    [self setupProgressView2];
    [gameView addSubview: _progressView2];
    
    UIImage *dPad = [UIImage imageNamed:@"img_d-pad.png"];
    _dPadView = [[UIImageView alloc] initWithImage:dPad];
    _dPadView.frame = CGRectMake(self.view.bounds.origin.x + 20,
                                 self.view.bounds.size.height - 150,
                                 130,
                                 130);
    _dPadView.tag = 11;
    _dPadView.layer.zPosition = 30;
    _dPadView.userInteractionEnabled = YES;
    [gameView addSubview: _dPadView];
    
    [self disabledTouch];
}

////////////////////////////////////////////////////////////////////////////////
// 初期化処理
/* タイマー設置 */
- (void)setupTimer {
    // ゲームスタート
    timeStart = [NSDate date];
    
    // 標準ボタン例文
    labelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    labelButton.frame = CGRectMake(10, 10, 100, 30);
    [labelButton addTarget:self action:@selector(pushButtonPose:)
  forControlEvents:UIControlEventTouchDown];
    
    labelButton.layer.borderWidth = 1.0f;
    labelButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    labelButton.layer.cornerRadius = 5.0f;
    
    labelButton.frame = CGRectMake(40, 40, self.view.frame.size.width/7, 35);
    labelButton.center = CGPointMake(self.view.center.x, 35);
    
    [labelButton setTitle:@"00:00" forState:UIControlStateNormal];
    
    [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [gameView addSubview:labelButton];
    
    // timer 開始
    timeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timeTimer forMode:NSRunLoopCommonModes];
}

/* タイマー更新 */
- (void)updateTimer:(NSTimer *)timer {
    if ( poseStart == nil ) {
        NSTimeInterval timeInterval = [timeStart timeIntervalSinceNow];
        NSTimeInterval gameInterval = timeInterval - poseInterval;
        int minute = fmod((-gameInterval / 60.0) ,60.0);
        int second = fmod(-gameInterval ,60.0);
        NSString *text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        [UIView setAnimationsEnabled:NO];
        [labelButton setTitle:text forState:UIControlStateNormal];
        [labelButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}

// Ready
- (void)gameReadyGo {
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    [@[@"Ready", @"Go!"] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, gameLayerView.frame.size.width, gameLayerView.frame.size.height);
        label.center = gameLayerView.center;
        label.alpha = 0.0f;
        label.font = [UIFont fontWithName:@"Assassin$" size:60];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = obj;
        [gameLayerView addSubview:label];
        [labels addObject:label];
    }];
    
    // 2秒間キーフレームアニメーションを実行する（逆再生＆リピート）
    [UIView animateKeyframesWithDuration:4.0
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
                                  // 0.8秒間（2.0 * 0.4）かけて背景を黄色に
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.25
                                                                animations:^{
                                                                    ((UILabel*)labels[0]).alpha = 1.0f;
                                                                }];
                                  
                                  // 0.8秒間（2.0 * 0.4）後に1.2秒間（2.0 * 0.6）かけて背景を緑色に
                                  [UIView addKeyframeWithRelativeStartTime:0.25
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    ((UILabel*)labels[0]).alpha = 0.0f;
                                                                }];
                                  // 0.8秒間（2.0 * 0.4）後に1.2秒間（2.0 * 0.6）かけて背景を緑色に
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.75
                                                                animations:^{
                                                                    ((UILabel*)labels[1]).alpha = 1.0f;
                                                                }];
                                  // 0.8秒間（2.0 * 0.4）後に1.2秒間（2.0 * 0.6）かけて背景を緑色に
                                  [UIView addKeyframeWithRelativeStartTime:0.75
                                                          relativeDuration:1.0
                                                                animations:^{
                                                                    ((UILabel*)labels[1]).alpha = 0.0f;
                                                                }];
                              } completion:^(BOOL finished){
                                  [self gameStart];
                              }];
}

// GameStart
- (void)gameStart {
    // NSLog(@"gameStart: %@", [NSThread currentThread]);
    gameLayerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    gameLayerView.alpha = 0;
    [self enableTouch];
    [self setupTimer];
    [self startThread]; // ゲームスタート※全て下準備が終わってから実行!!
}

// pose押下メソッド
-(void)pushButtonPose:(UIButton*)button{
    if ( poseStart == nil ) {
        [self endThread];
        [SoundPlayer pauseMusic];
        [SoundPlayer playSE:PAUSE_START_SE];
        poseStart = [NSDate date];
//        
//        ///////////////////////
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PAUSE" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        // addActionした順に左から右にボタンが配置されます
        [alertController addAction:[UIAlertAction actionWithTitle:@"TOPに戻る" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //[self cancelPauseButtonPushed];
            [SoundPlayer playSE:PAUSE_END_SE];
            [self segueTop];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"ゲームに戻る" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [SoundPlayer playSE:PAUSE_END_SE];
            [self cancelPauseButtonPushed];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// ポーズ解除
- (void)cancelPauseButtonPushed {
    [SoundPlayer pauseMusic];
    NSTimeInterval tmpPoseInterval = [poseStart timeIntervalSinceNow];
    poseInterval += tmpPoseInterval;
    poseStart = nil;
    [self startThread];
}

////////////////////////////////////////////////////////////////////////////////
// スレッド管理
- (void)startThread {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    [backgroundView start];
    
    // 攻撃ボタンのプログレスバー用タイマー
    myAttack1ProgressTimer = [NSTimer timerWithTimeInterval:0.1
                                                              target:self
                                                            selector:@selector(updateMyAttack1Progress:)
                                                            userInfo:nil
                                                             repeats:YES];
    [runLoop addTimer:myAttack1ProgressTimer forMode:NSRunLoopCommonModes];
    
    myAttack2ProgressTimer = [NSTimer timerWithTimeInterval:0.1
                                                              target:self
                                                            selector:@selector(updateMyAttack2Progress:)
                                                            userInfo:nil
                                                             repeats:YES];
    [runLoop addTimer:myAttack2ProgressTimer forMode:NSRunLoopCommonModes];
    
    // 自分移動用タイマー設定
    myMoveTimer = [NSTimer timerWithTimeInterval:0.02
                                                   target:self
                                                 selector:@selector(myMove:)
                                                 userInfo:nil
                                                  repeats:YES];
    [runLoop addTimer:myMoveTimer forMode:NSRunLoopCommonModes];
    
    // 相手移動用タイマー設定
    enemyMoveTimer = [NSTimer timerWithTimeInterval:0.005
                                                      target:self
                                                    selector:@selector(moveEnemy:)
                                                    userInfo:nil
                                                     repeats:YES];
    [runLoop addTimer:enemyMoveTimer forMode:NSRunLoopCommonModes];
    
    [self startMyShots];
    [self startEnemyShots];
}

- (void)endThread {
    // NSLog(@"endThread: %@", [NSThread currentThread]);
    [timeTimer invalidate];
    [backgroundView end];
    [myAttack1ProgressTimer invalidate];
    [myAttack2ProgressTimer invalidate];
    [myMoveTimer invalidate];
    [enemyMoveTimer invalidate];
    [self stopMyShots];
    [self stopEnemyShots];
    
    while ([timeTimer isValid]
           || [myAttack1ProgressTimer isValid]
           || [myAttack2ProgressTimer isValid]
           || [myMoveTimer isValid]
           || [enemyMoveTimer isValid] )
    {
        // NSLog(@"止まってない");
    }
    myAttack1ProgressTimer = nil;
    myAttack2ProgressTimer = nil;
    myMoveTimer = nil;
    enemyMoveTimer = nil;
}

// 操作無効化 ////////////////////////////////////////////////////////////////////
- (void)disabledTouch {
    _progressView1.userInteractionEnabled = NO;
    _progressView2.userInteractionEnabled = NO;
    // _dPadView.userInteractionEnabled = NO;
    labelButton.enabled = NO;
}

// 操作有効化 ////////////////////////////////////////////////////////////////////
- (void)enableTouch {
    _progressView1.userInteractionEnabled = YES;
    _progressView2.userInteractionEnabled = YES;
    // _dPadView.userInteractionEnabled = YES;
    labelButton.enabled = YES;
}

/* 攻撃ボタン1 *//////////////////////////////////////////////////////////////////
- (void)setupProgressView1 {
    UIImage *img = [UIImage imageNamed:@"icon_throwing‐knife.png"];
    CGSize sz = CGSizeMake(35, 35);
    UIGraphicsBeginImageContext(CGSizeMake(sz.width, sz.height));
    [img drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setFrame:CGRectMake(0, 0, 50, 50)];
    imgView.tintColor = UIColor.blackColor;
    imgView.layer.cornerRadius = 50 / 2.0;
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeCenter;
    UIColor *bcolor = [UIColor whiteColor];
    bcolor = [bcolor colorWithAlphaComponent:0.5];
    imgView.backgroundColor = bcolor;
    self.progressView1.centralView = imgView;
    _localProgress1 = 1.0f;
    [self.progressView1 setProgress:_localProgress1];
    self.progressView1.fillOnTouch = YES;

    // タップされたときに呼ばれる？
    self.progressView1.didSelectBlock = ^(UAProgressView *progressView){
        if (_localProgress1 == 1.0f) {
            _shot1 = YES;
        }
    };
    
    // 進捗変更時に呼ばれる
    self.progressView1.progressChangedBlock = ^(UAProgressView *progressView, float progress){
        
        UIColor *color = (progress == 1.0f ? [UIColor blackColor] : [UIColor grayColor]);
        
        UIImage *img = [UIImage imageNamed:@"icon_throwing‐knife.png"];
        CGSize sz = CGSizeMake(35, 35);
        UIGraphicsBeginImageContext(CGSizeMake(sz.width, sz.height));
        [img drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.contentMode = UIViewContentModeCenter;
        [imgView setFrame:CGRectMake(0, 0, 50, 50)];
        imgView.tintColor = color;
        progressView.centralView = imgView;
        
        progressView.fillOnTouch = (progress == 1.0f);
        
        UIColor *bcolor = [UIColor whiteColor];
        bcolor = [bcolor colorWithAlphaComponent:0.5];
        imgView.backgroundColor = bcolor;
        imgView.layer.cornerRadius = 50 / 2.0;
        imgView.clipsToBounds = YES;
    };
}

- (void)updateMyAttack1Progress:(NSTimer *)timer {
    NSUInteger count = [myShots count];
    if (count < 3) {
        _localProgress1 = 1.0;
        [self.progressView1 setProgress:_localProgress1];
        self.progressView1.fillOnTouch = YES;
    } else {
        _localProgress1 = 0.0;
        [self.progressView1 setProgress:_localProgress1];
        self.progressView1.fillOnTouch = NO;
    }
    
    if (_shot1) {        
        _shot1 = !_shot1;
        [self shotTapped1];
    }
    
}

- (void)shotTapped1 {
    [self createMyShot:LIGHT];
}

/* 攻撃ボタン2 *//////////////////////////////////////////////////////////////////
- (void)setupProgressView2 {
    UIImage *img = [UIImage imageNamed:@"icon_rocket.png"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setFrame:CGRectMake(0, 0, 50, 50)];
    imgView.tintColor = UIColor.blackColor;
    imgView.layer.cornerRadius = 50 / 2.0;
    imgView.clipsToBounds = YES;
    UIColor *bcolor = [UIColor whiteColor];
    bcolor = [bcolor colorWithAlphaComponent:0.5];
    imgView.backgroundColor = bcolor;
    self.progressView2.centralView = imgView;
    _localProgress2 = 1.0f;
    [self.progressView2 setProgress:_localProgress2];
    self.progressView2.fillOnTouch = YES;

    // 色が変化した時に呼ばれる？
    self.progressView2.fillChangedBlock = ^(UAProgressView *progressView, BOOL filled, BOOL animated){
        if (_localProgress2 == 1.0f) {
            UIColor *color = (filled ? [UIColor whiteColor] : [UIColor grayColor]);
            UIImage *img = [UIImage imageNamed:@"icon_rocket.png"];
            img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            [imgView setFrame:CGRectMake(0, 0, 50, 50)];
            imgView.tintColor = color;
            
            UIColor *bcolor = [UIColor whiteColor];
            bcolor = [bcolor colorWithAlphaComponent:0.5];
            imgView.backgroundColor = bcolor;
            imgView.layer.cornerRadius = 50 / 2.0;
            imgView.clipsToBounds = YES;
            // 押して離した瞬間
            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    progressView.centralView = imgView;
                }];
            }
            // 押した瞬間
            else {
                
            }
        }
    };
    
    // タップされたときに呼ばれる？
    self.progressView2.didSelectBlock = ^(UAProgressView *progressView){
        if (_localProgress2 == 1.0f) {
            _shot2 = YES;
            progressView.fillOnTouch = NO;
        }
    };
    
    // 進捗変更時に呼ばれる
    self.progressView2.progressChangedBlock = ^(UAProgressView *progressView, float progress){
        
        UIColor *color = (progress == 1.0f ? [UIColor blackColor] : [UIColor grayColor]);
        
        UIImage *img = [UIImage imageNamed:@"icon_rocket.png"];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        [imgView setFrame:CGRectMake(0, 0, 50, 50)];
        imgView.tintColor = color;
        progressView.centralView = imgView;
        
        progressView.fillOnTouch = (progress == 1.0f);
        
        UIColor *bcolor = [UIColor whiteColor];
        bcolor = [bcolor colorWithAlphaComponent:0.5];
        imgView.backgroundColor = bcolor;
        imgView.layer.cornerRadius = 50 / 2.0;
        imgView.clipsToBounds = YES;
    };
}

- (void)updateMyAttack2Progress:(NSTimer *)timer {
    if (_localProgress2 != 1.0f) {
        _localProgress2 = ( (int)((_localProgress2 * 100.0f) + 2.02) % 101 ) / 100.0f;
        [self.progressView2 setProgress:_localProgress2];
    }
    
    if (_shot2) {
        _shot2 = !_shot2;
        _localProgress2 = 0.0f;
        [self shotTapped2];
    }
}

- (void)shotTapped2 {
    [self createMyShot:MIDDLE];
}

/* 自分を表示させる */
- (void)initMyObject {
    myIV = [[UIImageView alloc]initWithImage:_myPerson.image];
    
    myIV.userInteractionEnabled = YES;
    myIV.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 100);
    double scale = 0.4;
    myIV.transform = CGAffineTransformMakeScale(scale, scale);
    myIV.layer.zPosition = 20;
    [gameView addSubview:myIV];
}

////////////////////////////////////////////////////////////////////////////////
/* 移動イベント */////////////////////////////////////////////////////////////////









/* 敵作成 *//////////////////////////////////////////////////////////////////////
- (void) createEnemy {
    enemyIV = [[UIImageView alloc]initWithImage:_enemyPerson.image];
    enemyIV.userInteractionEnabled = YES;
    double maxWidth = self.view.frame.size.width / GRID_X_LENGTH;
    enemyIV.frame = [self resize:enemyIV.frame maxX:maxWidth maxY:100.0];
    enemyIV.center = CGPointMake(self.view.center.x, 100);
    enemyIV.layer.zPosition = 20;
    [gameView addSubview:enemyIV];
}












////////////////////////////////////////////////////////////////////////////////
// イベント
////////////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    CGPoint location = [touch locationInView: self.view];
    switch (view.tag) {
        case 11:
            [self updateMove:view withTouchPoint:location];
            break;
            
        default:
            break;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    CGPoint location = [touch locationInView: self.view];
    switch (view.tag) {
        case 11:
            [self updateMove:view withTouchPoint:location];
            break;
            
        default:
            break;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    switch (view.tag) {
        case 11:
            [self updateMove:view];
            break;
            
        default:
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////
// Game Action
////////////////////////////////////////////////////////////////////////////////

/* 自身の弾を撃ち出す */
-(void)createMyShot:(AttackType)attackType {
    if (attackType == LIGHT) {
        [SoundPlayer playSE:ATTACK_SE1];
        UIImageView *uv = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self.myPerson.weaponImgA CGImage]]];
        // アニメーションの初期化　アニメーションのキーパスを"transform"にする
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        // 回転の開始と終わりの角度を設定　単位はラジアン
        anim.fromValue = [NSNumber numberWithDouble:0];
        anim.toValue = [NSNumber numberWithDouble:2 * M_PI];
        // 回転軸の設定
        anim.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
        //１回転あたりのアニメーション時間　単位は秒
        anim.duration = 2;
        // アニメーションのリピート回数
        anim.repeatCount = MAXFLOAT;
        // アニメーションをレイヤーにセット
        [uv.layer addAnimation:anim forKey:nil];
        
        uv.layer.zPosition = 20;
        double widthMax = 40.0;
        CGRect rect = [self resize:uv.frame maxX:widthMax maxY:100.0];
        rect.origin.x = myIV.center.x - rect.size.width/2;
        rect.origin.y = myIV.frame.origin.y;
        uv.frame = rect;
        uv.tag = attackType; // 攻撃力;
        [gameView addSubview:uv];
        [myShots addObject: uv];
    } else if (attackType == MIDDLE) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC),dispatch_get_current_queue(), ^{
            [SoundPlayer playSE:ATTACK_SE2];
            UIImageView *uv = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self.myPerson.weaponImgB CGImage]]];
            uv.layer.zPosition = 20;
            CGRect rect = [self resize:uv.frame maxX:40.0 maxY:50.0];
            rect.origin.x = myIV.frame.origin.x + myIV.frame.size.width*1/3 - rect.size.width/2;
            rect.origin.y = myIV.frame.origin.y;
            uv.frame = rect;
            uv.tag = attackType; // 攻撃力;
            [gameView addSubview:uv];
            [myShots addObject: uv];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            [SoundPlayer playSE:ATTACK_SE2];
            UIImageView *uv = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self.myPerson.weaponImgB CGImage]]];
            uv.layer.zPosition = 20;
            CGRect rect = [self resize:uv.frame maxX:40.0 maxY:50.0];
            rect.origin.x = myIV.frame.origin.x + myIV.frame.size.width*2/3 - rect.size.width/2;
            rect.origin.y = myIV.frame.origin.y;
            uv.frame = rect;
            uv.tag = attackType; // 攻撃力;
            [gameView addSubview:uv];
            [myShots addObject: uv];
        });
    }
}

////////////////////////////////////////////////////////////////////////////////
// Game Controll
////////////////////////////////////////////////////////////////////////////////
/* タッチ座標リセット */
- (void)updateMove:(UIView *) uv {
    moveX = 0.0;
    moveY = 0.0;
}

/* タッチ座標設定 */
- (void)updateMove:(UIView *) uv withTouchPoint: (CGPoint)touchPoint {
    double diffX = touchPoint.x - uv.center.x;
    double diffY = touchPoint.y - uv.center.y;
    moveX = diffX / (uv.frame.size.width / 2.0);
    moveY = diffY / (uv.frame.size.height / 2.0);
}

/* プレイヤー弾丸動作開始 */
- (void)startMyShots {
    // 自分攻撃オブジェクト用タイマー設定(折り返しの度に再設定される)
    myShotTimer = [NSTimer timerWithTimeInterval:0.003
                                                   target:self
                                                 selector:@selector(moveMyShots:)
                                                 userInfo:nil
                                                  repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:myShotTimer forMode:NSRunLoopCommonModes];
    
    // アニメーション再開
    [myShots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIView *uv, NSUInteger idx, BOOL *stop) {
        CALayer *layer = uv.layer;
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }];
}

/* プレイヤー弾丸動作停止 */
- (void)stopMyShots {
    [myShotTimer invalidate];
    while ([myShotTimer isValid])
    {
        // NSLog(@"myShotTimer 止まってない");
    }
    myShotTimer = nil;
    
    for(UIView *s in myShots){
        [s.layer removeAllAnimations];
    }
//    // アニメーション停止
//    [myShots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIView *uv, NSUInteger idx, BOOL *stop) {
//        CALayer *layer = uv.layer;
//        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//        layer.speed = 0.0;
//        layer.timeOffset = pausedTime;
//    }];
}

/* 敵弾丸動作開始 */
- (void)startEnemyShots {
    // NSLog(@"startEnemyShots: %@", [NSThread currentThread]);
    // 自分攻撃オブジェクト用タイマー設定(折り返しの度に再設定される)
    enemyShotTimer = [NSTimer timerWithTimeInterval:0.003
                                                      target:self
                                                    selector:@selector(moveEnemyShots:)
                                                    userInfo:nil
                                                     repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:enemyShotTimer forMode:NSRunLoopCommonModes];
    
    // アニメーション再開
    [enemyShots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIView *uv, NSUInteger idx, BOOL *stop) {
        CALayer *layer = uv.layer;
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }];
}

/* 敵弾丸停止 */
- (void)stopEnemyShots {
    [enemyShotTimer invalidate];
    while ([enemyShotTimer isValid])
    {
        // NSLog(@"myShotTimer 止まってない");
    }
    enemyShotTimer = nil;
    
    // アニメーション停止
    [enemyShots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIView *uv, NSUInteger idx, BOOL *stop) {
        CALayer *layer = uv.layer;
//        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//        layer.speed = 0.0;
//        layer.timeOffset = pausedTime;
        [layer removeAllAnimations];
    }];
}

/* 敵が攻撃 */
- (void)createEnemyShot {
    [SoundPlayer playSE:ENEMY_SHOT_SE];
    UIImageView *uv = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self.enemyPerson.weaponImgA CGImage]]];
    
    uv.clipsToBounds = YES;
    CGRect rect = [self resize:uv.frame maxX:10.0 maxY:60.0];
    rect.origin.x = enemyIV.center.x - rect.size.width/2;
    rect.origin.y = enemyIV.frame.origin.y;
    uv.frame = rect;
    CGFloat angle =  180.0 * M_PI / 180.0;
    uv.transform = CGAffineTransformMakeRotation(angle);
    uv.layer.zPosition = 20;
    if ( self.gameConfig.difficulty == NORMAL ) {
        uv.tag = STRONG; // 攻撃力;
    } else if (self.gameConfig.difficulty == HARD ) {
        uv.tag = KILL; // 攻撃力;
    }
    [gameView addSubview:uv];
    [enemyShots addObject: uv];
}



////////////////////////////////////////////////////////////////////////////////
// タイマーに呼ばれる処理
////////////////////////////////////////////////////////////////////////////////
// プレイヤーを動かす
- (void)myMove:(NSTimer *)timer{
    // 移動倍率
    double scall = 10.0;
    // 移動ピクセル数
    double x = moveX * scall;
    double y = moveY * scall;
    // 移動先四方の座標
    double right  = myIV.frame.origin.x + myIV.frame.size.width + x;
    double left   = myIV.frame.origin.x + x;
    double top    = myIV.frame.origin.y + y;
    double bottom = myIV.frame.origin.y + myIV.frame.size.height + y;
    // 画面外には移動させない
    if (self.view.frame.origin.x + self.view.frame.size.width < right
        || left < self.view.frame.origin.x) {
        x = 0;
    }
    if (self.view.frame.origin.y + self.view.frame.size.height < bottom
        || top < self.view.frame.origin.y + self.view.frame.size.height/2) {
        y = 0;
    }
    // 移動実行
    myIV.center = CGPointMake(myIV.center.x + x, myIV.center.y + y);
}

/* 敵を動かす */
- (void)moveEnemy:(NSTimer *)timer {
    // 目的地なし
    if (enemyDestination == nil) {
        // NSLog(@"enemyDestination == nil");
        CGPoint moveCenterTmp = [self randomCGPointCenter:enemyIV.frame];
        enemyDestination = [NSValue valueWithCGPoint:moveCenterTmp];
    }
    CGPoint moveCenter = [enemyDestination CGPointValue];
    double moveCenterX = moveCenter.x;
    
    // 目的地が同じなら無効
    if (floor(moveCenterX) == floor(enemyIV.center.x)) {
        enemyDestination = nil;
        return;
    }
    
    // 移動
    if (moveCenterX < enemyIV.center.x) {
        enemyIV.center = CGPointMake(enemyIV.center.x - 1, enemyIV.center.y);
    }else if (enemyIV.center.x < moveCenterX) {
        enemyIV.center = CGPointMake(enemyIV.center.x + 1, enemyIV.center.y);
    }else{
//        enemyDestination = nil;
//        [self createEnemyShot];
    }
    
    // 目的地に到達したら攻撃
    if (floor(moveCenterX) == floor(enemyIV.center.x)) {
        // NSLog(@"floor(moveCenterX) == floor(enemyIV.center.x)");
        enemyIV.center = CGPointMake(moveCenterX, enemyIV.center.y);
        enemyDestination = nil;
        [self createEnemyShot];
    }
}

/* プレイヤーの弾丸を動かし、ダメージ判定、終了判定を行う */
- (void)moveMyShots:(NSTimer*)timer {
    //    NSLog(@"myShotsBefore%ld", myShots.count);
    NSMutableArray *removeUv = [[NSMutableArray alloc] init];
    [myShots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIView *uv, NSUInteger idx, BOOL *stop) {
        uv.center = CGPointMake(uv.center.x, uv.center.y - 1);
        if (CGRectIntersectsRect(uv.frame, enemyIV.frame)){
            [uv removeFromSuperview];
            [removeUv addObject:uv];
            if ((hp.enemyPV.progress - (uv.tag / 100.0)) <= 0 ) {
                [SoundPlayer playSE:KO_SE];
            } else {
              uv.tag == LIGHT ?
                  [SoundPlayer playSE:LOW_HIT_SE] : [SoundPlayer playSE:HIT_BOMB_SE];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                hp.enemyPV.progress = hp.enemyPV.progress - (uv.tag / 100.0);
                if ( hp.enemyPV.progress <= 0 ) {
                    [self segueResult];// ここに実行したいコード
                }
            });
            uv = nil;
        }
        if (!CGRectContainsPoint(self.view.frame, uv.frame.origin)){
            [removeUv addObject:uv];
            [uv removeFromSuperview];
            uv = nil;
        }
    }];
    
    [myShots removeObjectsInArray:removeUv];
}

/* 敵の弾を動かし、ダメージ判定、終了判定を行う */
- (void)moveEnemyShots:(NSTimer*)timer {
    //NSLog(@"enemyShotsBefore%ld", enemyShots.count);
    NSMutableArray *removeUv = [[NSMutableArray alloc] init];
    [enemyShots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIView *uv, NSUInteger idx, BOOL *stop) {
        uv.center = CGPointMake(uv.center.x, uv.center.y + 1);
        // 光の輪っか分画像が大きいので調整してる
        CGRect myTmpRect = CGRectMake(myIV.frame.origin.x+10, myIV.frame.origin.y+10, myIV.frame.size.width-20, myIV.frame.size.height-20);
        if (CGRectIntersectsRect(uv.frame, myTmpRect)){
            //お互いが重なったときの処理をifの中に書きます
            [uv removeFromSuperview];
            [removeUv addObject:uv];
            uv.tag == KILL ?
                [SoundPlayer playSE:KNIFE_HIT_SE] : [SoundPlayer playSE:HIGH_HIT_SE];
            dispatch_async(dispatch_get_main_queue(), ^{
                hp.myPV.progress = hp.myPV.progress - (uv.tag / 100.0);
                if ( hp.myPV.progress <= 0 ) {
                    // NSLog(@"hp.myPV.progress <= 0: %@", [NSThread currentThread]);
                    [self showYouAreDeadLayer];// ここに実行したいコード
                }
            });
            uv = nil;
        }
        if (!CGRectContainsPoint(self.view.frame, uv.frame.origin)){
            [removeUv addObject:uv];
            [uv removeFromSuperview];
            uv = nil;
        }
    }];
    
    [enemyShots removeObjectsInArray:removeUv];
}

////////////////////////////////////////////////////////////////////////////////
// 汎用処理
////////////////////////////////////////////////////////////////////////////////

/* CGRectをmaxの大きさ以下に縮尺して返す */
- (CGRect)resize:(CGRect)rect maxX:(double)maxX maxY:(double)maxY {
    double scaleX = maxX < rect.size.width  ? maxX / rect.size.width  : 1.0;
    double scaleY = maxY < rect.size.height ? maxY / rect.size.height : 1.0;
    double scale = scaleX < scaleY ? scaleX : scaleY;
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*scale, rect.size.height*scale);
    return rect;
}

/* ランダムに、移動先座標を決定する */
- (CGPoint)randomCGPointCenter:(CGRect) rect {
    double movedWidth = self.view.frame.size.width;
    double gridOne = movedWidth / GRID_X_LENGTH;
    int moveGrid = (int)arc4random_uniform(GRID_X_LENGTH); // 0~GRID_X_LENGTH-1
    CGPoint movePoint = CGPointMake(gridOne*moveGrid, rect.origin.y);
    CGPoint centerPoint = CGPointMake(movePoint.x + (rect.size.width/2),
                                      rect.origin.y + (rect.size.height/2));
    return centerPoint;
}

////////////////////////////////////////////////////////////////////////////////
// =============================================================================
// 画面遷移関連処理
// =============================================================================
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// show
////////////////////////////////////////////////////////////////////////////////

/* ゲームオーバーレイヤー表示 */
- (void)showYouAreDeadLayer {
    // NSLog(@"thread: %@", [NSThread currentThread]);
    // NSLog(@"showYouAreDeadLayer");
    if (timeStart == nil) {
        return;
    }
                   
    timeStart = nil; // ゲーム終了の印
    [self endThread];
    [self disabledTouch];
    ////////////////////////////////
    [_progressView1 stopAnimation];
    [_progressView2 stopAnimation];
//    [_progressView1 removeFromSuperview];
//    [_progressView2 removeFromSuperview];
    _progressView1 = nil;
    _progressView2 = nil;
    ////////////////////////////////
    
    gameoverLayer = [[UIView alloc] initWithFrame:self.view.frame];
    gameoverLayer.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.8f];
    gameoverLayer.alpha = 0;
    [self.view addSubview:gameoverLayer];
    UILabel *label = [[UILabel alloc] init];
    label.frame = gameoverLayer.frame;
    label.center = gameoverLayer.center;
    label.font = [UIFont fontWithName:@"Assassin$" size:60];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"You Are Dead";
    [gameoverLayer addSubview:label];
    gameoverLayer.layer.zPosition = 9999;
    [self.view bringSubviewToFront:gameoverLayer];
    //    gameLayerView.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.8f];
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = gameLayerView.frame;
//    label.center = gameLayerView.center;
//    label.alpha = 0.0f;
//    label.font = [UIFont fontWithName:@"Assassin$" size:60];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"You Are Dead";
//    [gameLayerView addSubview:label];
    [self.view addSubview:gameoverLayer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        
        [SoundPlayer playMusic:LOSE_BGM];
        
        float ANIMATION_TIME = 4.0;
        [UIView animateWithDuration:ANIMATION_TIME delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^(void){
            gameoverLayer.alpha = 1.f;
            //        [self.view layoutIfNeeded];
        }completion:^(BOOL finished){
            // NSLog(@"%@",finished?@"true":@"false");
            [self showRetryAlert];
        }];
        while (true) {
            // NSLog(@"%f:",gameoverLayer.alpha);
            if(gameoverLayer.alpha == 1.f){
                break;
            }
        }
    });
//    [UIView animateKeyframesWithDuration:ANIMATION_TIME
//                                   delay:0.5
//                                 options:UIViewKeyframeAnimationOptionLayoutSubviews
//                              animations:^{
//                                  [UIView addKeyframeWithRelativeStartTime:0.0
//                                                          relativeDuration:1.0
//                                                                animations:^{
//                                                                    gameLayerView.backgroundColor =
//                                                                    [UIColor colorWithRed:1.0f
//                                                                                    green:0.0f
//                                                                                     blue:0.0f
//                                                                                    alpha:0.8f];
//                                                                    ((UILabel*)label).alpha = 1.0f;
//                                                                    
//                                                                }];
//                              } completion:^(BOOL finished){
//                                  [self showRetryAlert];
//                              }];
//    gameLayerView.backgroundColor = [UIColor colorWithRed:1.0f
//                                                      green:0.0f
//                                                       blue:0.0f
//                                                      alpha:0.8f];
//    NSLog(@"%@",NSStringFromCGRect(gameLayerView.frame));
//    NSLog(@"%@",gameLayerView.backgroundColor);
//    ((UILabel*)label).alpha = 1.0f;
//    [self.view bringSubviewToFront:gameLayerView];
//    [self showRetryAlert];
}

/* リトライアラート表示 */
- (void)showRetryAlert {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"どうする?"
                                        message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"リトライ"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [SoundPlayer playSE:SELECT_SE];
                                [self execRetry];
                            }]];
    
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"TOPに戻る"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [SoundPlayer playSE:CANCEL_SE];
                                [self segueTop];
                            }]];
    
   // [self presentViewController:alertController animated:YES completion:nil];
    
    //////////////////////////////////
    
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while(presentingViewController.presentedViewController != nil)
    {
        presentingViewController = presentingViewController.presentedViewController;
    }
    
    [presentingViewController presentViewController:alertController animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////
// イベント(Action)
////////////////////////////////////////////////////////////////////////////////

/* TOPに戻る */
- (void)segueTop {
    [self clearGame];
    [self performSegueWithIdentifier:@"segueTop" sender:self];
}

/* リトライ */
- (void)execRetry {
    [gameoverLayer removeFromSuperview];
    gameoverLayer = nil;
    [self clearGame];
    [self initGame];
    [self gameReadyGo];
}

// Result画面へ遷移
- (void)segueResult {
    if (timeStart == nil) {
        return;
    }
    [SoundPlayer stopMusic];
    score = [[Score alloc] init];
    NSTimeInterval timeInterval = [timeStart timeIntervalSinceNow];
    NSTimeInterval gameInterval = timeInterval - poseInterval;
    score.time = -gameInterval;
    score.difficulty = self.gameConfig.difficulty;
    timeStart = nil; // ゲーム終了の印
    [self endThread];
    [self disabledTouch];
    ////////////////////////////////
    [_progressView1 stopAnimation];
    [_progressView2 stopAnimation];
    //    [_progressView1 removeFromSuperview];
    //    [_progressView2 removeFromSuperview];
    _progressView1 = nil;
    _progressView2 = nil;
    ////////////////////////////////
    gameoverLayer = [[UIView alloc] initWithFrame:self.view.frame];
    gameoverLayer.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.8f];
    gameoverLayer.alpha = 0;
    [self.view addSubview:gameoverLayer];
    UILabel *label = [[UILabel alloc] init];
    label.frame = gameoverLayer.frame;
    label.center = gameoverLayer.center;
    label.font = [UIFont fontWithName:@"Assassin$" size:60];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Game Clear!!";
    [gameoverLayer addSubview:label];
    gameoverLayer.layer.zPosition = 9999;
    [self.view bringSubviewToFront:gameoverLayer];
    //    gameLayerView.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.8f];
    //    UILabel *label = [[UILabel alloc] init];
    //    label.frame = gameLayerView.frame;
    //    label.center = gameLayerView.center;
    //    label.alpha = 0.0f;
    //    label.font = [UIFont fontWithName:@"Assassin$" size:60];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.text = @"You Are Dead";
    //    [gameLayerView addSubview:label];
    [self.view addSubview:gameoverLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{

        [SoundPlayer playMusic:WIN_BGM];
    
        float ANIMATION_TIME = 6.3;
        [UIView animateWithDuration:ANIMATION_TIME delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^(void){
            gameoverLayer.alpha = 1.f;
            //        [self.view layoutIfNeeded];
        }completion:^(BOOL finished){
            [self performSegueWithIdentifier:@"segueResult" sender:self];
        }];
        
    });
}

/* ダメージエフェクト設定 */////////////////////////////////////////////////////////
//- (void) createParticleView {
//    // 背景色を透明にしたいUIViewのインスタンスを作成する
//    gameLayerView = [[UIView alloc] initWithFrame:self.view.frame];
//
//    // opaque属性にNOを設定する事で、背景透過を許可する。
//    // ここの設定を忘れると、背景色をいくら頑張っても透明になりません。
//    gameLayerView.opaque = NO;
//
//    // backgroundColorにalpha=0.0fの背景色を設定することで、
//    // 背景色が透明になります。
//    gameLayerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
//
//    // 画像より上に表示されるように
//    gameLayerView.layer.zPosition = 10000;
//
//    // 作成した背景色透明のViewを現在のViewの上に追加する
//    [self.view addSubview:gameLayerView];
//}

///* パーティカルエフェクトの素材画像を作成する */
//- (UIImage *)createParticleImg {
//    UIImage *img_mae = [UIImage imageNamed:@"img_particle.png"];  // リサイズ前UIImage
//    UIImage *image;
//    CGFloat width = 100;  // リサイズ後幅のサイズ
//    CGFloat height = 100;  // リサイズ後高さのサイズ
//    UIGraphicsBeginImageContext(CGSizeMake(width, height));
//    [img_mae drawInRect:CGRectMake(0, 0, width, height)];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

///*
// ダメージエフェクトオブジェクト作成
// birthRate:１秒間に生成するパーティクルの数。
// lifetime:パーティクルが発生してから消えるまでの時間。単位は秒。
// color:パーティクルの色。
// velocity:パーティクルの秒速。
// emissionRange:パーティクルを発生する角度の範囲。単位はラジアン。
// */
//- (CAEmitterLayer *)createEmitterLayer {
//    CAEmitterLayer *caEmitterLayer = [CAEmitterLayer layer];
//    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
//    [queue addOperationWithBlock:^{
//        caEmitterLayer.renderMode = kCAEmitterLayerAdditive;
//        caEmitterLayer.emitterSize = CGSizeMake(3.0f, 3.0f);
//        [gameLayerView.layer addSublayer:caEmitterLayer];
//
//        emitterCell.contents = (__bridge id)([self createParticleImg].CGImage);
//        emitterCell.emissionLongitude = M_PI * 2;
//        emitterCell.emissionRange = M_PI * 2;
//        emitterCell.lifetime = 0.3f;
//        emitterCell.color = [[UIColor colorWithRed:1.000 green:0.433 blue:0.173 alpha:0.3] CGColor];
//        emitterCell.scale = 0.2f;
//        emitterCell.velocity = 20.0f;
//        emitterCell.scaleSpeed = 0.3f;
//        emitterCell.spin = 0.5f;
//
//        [emitterCell setName:@"fireworks"];
//
//        caEmitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
//    }];
//
//    return caEmitterLayer;
//}

///* 自分ダメージエフェクト作成 */
//-(void)myEmitterStart:(id)param {
//    NSValue *value = [param objectForKey:@"point"];
//    CGPoint point = [value CGPointValue];
//    myEmitterLayer.emitterPosition = point;
//
//    [myEmitterLayer setValue:@50
//                  forKeyPath:@"emitterCells.fireworks.birthRate"];
//
//    // メソッドの実行時間までランループの終了を遅延させる
//    [self performSelector:@selector(myEmitterStop) withObject:nil afterDelay:0.3f];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3f]]; // ←これがないとダメ。
//    [NSThread exit];
//}

///* 自分ダメージエフェクト終了 */
//-(void)myEmitterStop
//{
//    [myEmitterLayer setValue:@0
//                  forKeyPath:@"emitterCells.fireworks.birthRate"];
//}

///* 敵ダメージエフェクト作成 */
//- (void)enemyEmitterStart:(id)param {
//    NSValue *value = [param objectForKey:@"point"];
//    CGPoint point = [value CGPointValue];
//    enemyEmitterLayer.emitterPosition = point;
//
//    [enemyEmitterLayer setValue:@50
//                     forKeyPath:@"emitterCells.fireworks.birthRate"];
//
//    // メソッドの実行時間までランループの終了を遅延させる
//    [self performSelector:@selector(enemyEmitterStop) withObject:nil afterDelay:0.3f];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3f]]; // ←これがないとダメ。
//    [NSThread exit];
//}

///* 敵ダメージエフェクト終了 */
//- (void)enemyEmitterStop {
//    [enemyEmitterLayer setValue:@0
//                     forKeyPath:@"emitterCells.fireworks.birthRate"];
//}


@end
