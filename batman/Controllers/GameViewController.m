//
//  GameViewController.m
//  batman
//
//  Created by 山口 大輔 on 2015/03/07.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property UAProgressView *progressView1;
@property UAProgressView *progressView2;
@property UAProgressView *progressView3;
@property UAProgressView *progressView4;

@property (nonatomic, assign) BOOL shot1;
@property (nonatomic, assign) CGFloat localProgress1;
@property (nonatomic, assign) BOOL shot2;
@property (nonatomic, assign) CGFloat localProgress2;
@property (nonatomic, assign) BOOL shot3;
@property (nonatomic, assign) CGFloat localProgress3;
@property (nonatomic, assign) BOOL shot4;
@property (nonatomic, assign) CGFloat localProgress4;

@end

@implementation GameViewController

const int GRID_X_LENGTH = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景設定
    BackgroundView *background = [[BackgroundView alloc] initWithFrame:self.view.frame];
    background.layer.zPosition = 0;
    [self.view addSubview: background];
    
    // HPBar設定
    hp = [[HPView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    hp.myLabel.text    = @"d-yamaguchi";
    hp.enemyLabel.text = _enemyPerson.name;
    [self.view addSubview: hp];
    
    //初期化
    myShots    = [[NSMutableArray alloc]init];
    enemyShots = [[NSMutableArray alloc]init];
    
    [self initMyObject];
    
    [self createEnemy];
    
    myEmitterLayer = [self createEmitterLayer];
    enemyEmitterLayer = [self createEmitterLayer];
    
    _progressView1 = [[UAProgressView alloc]initWithFrame: CGRectMake(100, 100, 50, 50)];
    _progressView1.center = CGPointMake(self.view.bounds.size.width-_progressView1.frame.size.width,
                                        self.view.bounds.size.height-_progressView1.frame.size.height*2);
    _progressView1.layer.zPosition = 200;
    [self setupProgressView1];
    [self.view addSubview: _progressView1];
    
    _progressView2 = [[UAProgressView alloc]initWithFrame: CGRectMake(100, 100, 50, 50)];
    _progressView2.center = CGPointMake(self.view.bounds.size.width-_progressView2.frame.size.width*2,
                                        self.view.bounds.size.height-_progressView2.frame.size.height*1);
    _progressView2.layer.zPosition = 200;
    [self setupProgressView2];
    [self.view addSubview: _progressView2];

    UIImage *dPad = [UIImage imageNamed:@"img_d-pad.png"];
    UIImageView *dPadView = [[UIImageView alloc] initWithImage:dPad];
    dPadView.frame = CGRectMake(self.view.bounds.origin.x + 20,
                                 self.view.bounds.size.height - 150,
                                 130,
                                 130);
    dPadView.tag = 1;
    dPadView.layer.zPosition = 200;
    dPadView.userInteractionEnabled = YES;
    [self.view addSubview: dPadView];
}

////////////////////////////////////////////////////////////////////////////////
/* 初期化処理 *///////////////////////////////////////////////////////////////////

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
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress1:) userInfo:nil repeats:YES];
    
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

- (void)updateProgress1:(NSTimer *)timer {
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
    [self createMyShot];
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
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress2:) userInfo:nil repeats:YES];
    
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
                NSLog(@"if");
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

- (void)updateProgress2:(NSTimer *)timer {
    if (_localProgress2 != 1.0f) {
        _localProgress2 = ( (int)((_localProgress2 * 100.0f) + 1.01) % 101 ) / 100.0f;
        [self.progressView2 setProgress:_localProgress2];
    }
    
    if (_shot2) {
        _shot2 = !_shot2;
        _localProgress2 = 0.0f;
        [self shotTapped2];
    }
}

- (void)shotTapped2 {
    NSLog(@"shot tapped");
}

/* 自分を表示させる */
- (void)initMyObject {
    UIImage *myImg = [UIImage imageNamed:@"img_batman_logo.png"];
    myIV = [[UIImageView alloc]initWithImage:myImg];
    myIV.userInteractionEnabled = YES;
    myIV.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 100);
    double scale = 0.2;
    myIV.transform = CGAffineTransformMakeScale(scale, scale);
    [self.view addSubview:myIV];
    
    // 移動タイマー設定
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(move:) userInfo:nil repeats:YES];
}

////////////////////////////////////////////////////////////////////////////////
/* 移動イベント */////////////////////////////////////////////////////////////////

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    CGPoint location = [touch locationInView: self.view];
    switch (view.tag) {
        case 1:
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
        case 1:
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
        case 1:
            [self updateMove:view];
            break;
            
        default:
            break;
    }
}

- (void)updateMove:(UIView *) uv {
    moveX = 0.0;
    moveY = 0.0;
}

- (void)updateMove:(UIView *) uv withTouchPoint: (CGPoint)touchPoint {
    double diffX = touchPoint.x - uv.center.x;
    double diffY = touchPoint.y - uv.center.y;
    moveX = diffX / (uv.frame.size.width / 2.0);
    moveY = diffY / (uv.frame.size.height / 2.0);
}

// 動かす
- (void)move:(NSTimer *)timer{
    // 移動倍率
    double scall = 5.0;
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
        || top < self.view.frame.origin.y) {
        y = 0;
    }
    // 移動実行
    myIV.center = CGPointMake(myIV.center.x + x, myIV.center.y + y);
}

/* ダメージエフェクト設定 */////////////////////////////////////////////////////////
- (UIView *) createParticleView {
    // 背景色を透明にしたいUIViewのインスタンスを作成する
    UIView *particleView = [[UIView alloc] initWithFrame:self.view.frame];
    
    // opaque属性にNOを設定する事で、背景透過を許可する。
    // ここの設定を忘れると、背景色をいくら頑張っても透明になりません。
    particleView.opaque = NO;
    
    // backgroundColorにalpha=0.0fの背景色を設定することで、
    // 背景色が透明になります。
    particleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    
    // 画像より上に表示されるように
    particleView.layer.zPosition = 100;
    
    // 作成した背景色透明のViewを現在のViewの上に追加する
    [self.view addSubview:particleView];
    
    return particleView;
}

/* パーティカルエフェクトの素材画像を作成する */
- (UIImage *)createParticleImg {
    UIImage *img_mae = [UIImage imageNamed:@"img_particle.png"];  // リサイズ前UIImage
    UIImage *image;
    CGFloat width = 100;  // リサイズ後幅のサイズ
    CGFloat height = 100;  // リサイズ後高さのサイズ
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [img_mae drawInRect:CGRectMake(0, 0, width, height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 ダメージエフェクトオブジェクト作成
 birthRate:１秒間に生成するパーティクルの数。
 lifetime:パーティクルが発生してから消えるまでの時間。単位は秒。
 color:パーティクルの色。
 velocity:パーティクルの秒速。
 emissionRange:パーティクルを発生する角度の範囲。単位はラジアン。
 */
- (CAEmitterLayer *)createEmitterLayer {
    CAEmitterLayer *caEmitterLayer = [CAEmitterLayer layer];
    caEmitterLayer.renderMode = kCAEmitterLayerAdditive;
    caEmitterLayer.emitterSize = CGSizeMake(3.0f, 3.0f);
    [[self createParticleView].layer addSublayer:caEmitterLayer];
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (__bridge id)([self createParticleImg].CGImage);
    emitterCell.emissionLongitude = M_PI * 2;
    emitterCell.emissionRange = M_PI * 2;
    emitterCell.lifetime = 0.3f;
    emitterCell.color = [[UIColor colorWithRed:1.000 green:0.433 blue:0.173 alpha:0.3] CGColor];
    emitterCell.scale = 0.2f;
    emitterCell.velocity = 20.0f;
    emitterCell.scaleSpeed = 0.3f;
    emitterCell.spin = 0.5f;
    
    [emitterCell setName:@"fireworks"];
    
    caEmitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
    return caEmitterLayer;
}

/* 自分ダメージエフェクト作成 */
-(void)myEmitterStart:(id)param {
    NSValue *value = [param objectForKey:@"point"];
    CGPoint point = [value CGPointValue];
    myEmitterLayer.emitterPosition = point;
    
    [myEmitterLayer setValue:@50
                  forKeyPath:@"emitterCells.fireworks.birthRate"];
    // メソッドの実行時間までランループの終了を遅延させる
    [self performSelector:@selector(myEmitterStop) withObject:nil afterDelay:0.3f];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3f]]; // ←これがないとダメ。
    [NSThread exit];
}

/* 自分ダメージエフェクト終了 */
-(void)myEmitterStop
{
    [myEmitterLayer setValue:@0
                  forKeyPath:@"emitterCells.fireworks.birthRate"];
}

/* 敵ダメージエフェクト作成 */
- (void)enemyEmitterStart:(id)param {
    NSValue *value = [param objectForKey:@"point"];
    CGPoint point = [value CGPointValue];
    enemyEmitterLayer.emitterPosition = point;
    
    [enemyEmitterLayer setValue:@50
                     forKeyPath:@"emitterCells.fireworks.birthRate"];
    
    // メソッドの実行時間までランループの終了を遅延させる
    [self performSelector:@selector(enemyEmitterStop) withObject:nil afterDelay:0.3f];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3f]]; // ←これがないとダメ。
    [NSThread exit];
}

/* 敵ダメージエフェクト終了 */
- (void)enemyEmitterStop {
    [enemyEmitterLayer setValue:@0
                     forKeyPath:@"emitterCells.fireworks.birthRate"];
}

/* 敵作成 *//////////////////////////////////////////////////////////////////////
- (void) createEnemy {
    enemyIV = [[UIImageView alloc]initWithImage:_enemyPerson.image];
    enemyIV.userInteractionEnabled = YES;
    double maxWidth = self.view.frame.size.width / GRID_X_LENGTH;
    enemyIV.frame = [self resize:enemyIV.frame max:maxWidth];
    enemyIV.center = CGPointMake(self.view.center.x, 100);
    [self.view addSubview:enemyIV];
    [self moveEnemy];
}

/* 敵移動タイマーを作成してスタート */
- (void) moveEnemy {
    CGPoint moveCenter = [self randomCGPointCenter:enemyIV.frame];
    //NSLog(@"moveCenterは%f,%f", moveCenter.x, moveCenter.y);
    // 指定時間経過後に呼び出すメソッドに渡すデータをセット
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:(moveCenter.x)], @"moveCenterX",
                              nil];
    
    // 定期的に移動する
    [NSTimer scheduledTimerWithTimeInterval:0.005f
                                     target:self
                                   selector:@selector(enemyMoveProgress:)
                                   userInfo:userInfo
                                    repeats:YES
     ];
}

/* 敵の位置を変更 */
-(void) enemyMoveProgress:(NSTimer*)timer {
    NSNumber *nsmoveCenterX = [(NSDictionary *)timer.userInfo objectForKey:@"moveCenterX"];
    double moveCenterX = [nsmoveCenterX doubleValue];
    
    if       (floor(moveCenterX) == floor(enemyIV.center.x)) {
        enemyIV.center = CGPointMake(moveCenterX, enemyIV.center.y);
        [timer invalidate];
        [self moveEnemy];
        [self createEnemyShot];
    }else if (moveCenterX < enemyIV.center.x) {
        enemyIV.center = CGPointMake(enemyIV.center.x - 1, enemyIV.center.y);
    }else if (enemyIV.center.x < moveCenterX) {
        enemyIV.center = CGPointMake(enemyIV.center.x + 1, enemyIV.center.y);
    }else{
        [timer invalidate];
        [self moveEnemy];
        [self createEnemyShot];
    }
}

/* 敵が攻撃 */
- (void)createEnemyShot {
    UIView *uv = [[UIView alloc] init];
    uv = [[UIView alloc] init];
    uv.frame = CGRectMake(enemyIV.center.x,
                          enemyIV.frame.origin.y + enemyIV.frame.size.height,
                          10, 10);
    uv.backgroundColor = [UIColor redColor];
    uv.layer.cornerRadius = uv.frame.size.width / 2.0;
    uv.clipsToBounds = YES;
    [self.view addSubview:uv];
    [enemyShots addObject: uv];
    [self startEnemyShot: uv];
}

/* 敵弾タイマーを作成してスタート */
-(void)startEnemyShot:(UIView*)uv {
    // 指定時間経過後に呼び出すメソッドに渡すデータをセット
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              uv, @"shot",
                              [NSNumber numberWithInt:-1], @"y", nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.003f
                                     target:self
                                   selector:@selector(enemyShotProgress:)
                                   userInfo:userInfo
                                    repeats:YES
     ];
}

/* 弾の進行状況を変更 */
-(void)enemyShotProgress:(NSTimer*)timer {
    UIView *uv = [(NSDictionary *)timer.userInfo objectForKey:@"shot"];
    uv.center = CGPointMake(uv.center.x, uv.center.y + 1);
    if (CGRectIntersectsRect(uv.frame, myIV.frame)){
        //お互いが重なったときの処理をifの中に書きます。
        [timer invalidate];
        [uv removeFromSuperview];
        hp.myPV.progress = hp.myPV.progress - 0.1;
        
        // スレッドパラメータを作成
        NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
        [param setObject:[NSValue valueWithCGPoint:uv.center] forKey:@"point"];
        [NSThread detachNewThreadSelector:@selector(myEmitterStart:) toTarget:self withObject:param];
    }
    if (!CGRectContainsPoint(self.view.frame, uv.frame.origin)){
        [timer invalidate];
        [uv removeFromSuperview];
    }
}

/* イベント */////////////////////////////////////////////////////////////////////

/* イベントに呼び出される処理 *//////////////////////////////////////////////////////

/* 自身の弾を撃ち出す */
-(void)createMyShot {
    UIImageView *uv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_new_batman_logo.png"]];
    uv.layer.zPosition = 100;
    double widthMax = 40.0;
    
    CGRect rect = [self resize:uv.frame max:widthMax];
    rect.origin.x = myIV.center.x - rect.size.width/2;
    rect.origin.y = myIV.frame.origin.y;
    uv.frame = rect;
    
    [self.view addSubview:uv];
    [myShots addObject: uv];
    [self myShotTimerStart: uv];
    
    [UIView animateWithDuration:2.0f // アニメーション速度
                          delay:0.0f // 1秒後にアニメーション
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         uv.transform = CGAffineTransformMakeRotation(135.0 * M_PI / 180.0);
                     } completion:^(BOOL finished) {
                         // アニメーションが終わった後実行する処理
                     }];
}

/* 自身弾タイマーを作成してスタート */
-(void)myShotTimerStart:(UIView*)uv {
    // 指定時間経過後に呼び出すメソッドに渡すデータをセット
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              uv, @"shot",
                              [NSNumber numberWithInt:-1], @"y", nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.003f
                                     target:self
                                   selector:@selector(myShotProgress:)
                                   userInfo:userInfo
                                    repeats:YES
     ];
}

/* 弾の進行状況を変更 */
-(void)myShotProgress:(NSTimer*)timer {
    UIView *uv = [(NSDictionary *)timer.userInfo objectForKey:@"shot"];
    uv.center = CGPointMake(uv.center.x, uv.center.y - 1);
    if (CGRectIntersectsRect(uv.frame, enemyIV.frame)){
        //お互いが重なったときの処理をifの中に書きます。
        [timer invalidate];
        [myShots removeObject:uv];
        [uv removeFromSuperview];
        hp.enemyPV.progress = hp.enemyPV.progress - 0.1;
        
        // スレッドパラメータを作成
        NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
        [param setObject:[NSValue valueWithCGPoint:uv.center] forKey:@"point"];
        [NSThread detachNewThreadSelector:@selector(enemyEmitterStart:) toTarget:self withObject:param];
    }
    if (!CGRectContainsPoint(self.view.frame, uv.frame.origin)){
        [timer invalidate];
        [myShots removeObject:uv];
        [uv removeFromSuperview];
    }
}

/* 汎用処理 */////////////////////////////////////////////////////////////////////

/* CGRectをmaxの大きさ以下に縮尺して返す */
- (CGRect)resize:(CGRect)rect max:(double)maxSize {
    double scaleX = maxSize / rect.size.width;
    double scale = scaleX;
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
//●/////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end