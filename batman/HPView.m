//
//  HPView.m
//  batman
//
//  Created by 山口 大輔 on 2015/04/04.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "HPView.h"

@implementation HPView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// コードで初期化する場合
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeView];
    }
    return self;
}

// xib を使用する場合
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initializeView];
    }
    return self;
}

-(void) initializeView {
    // プログレスバー作成
    _myPV = [[UIProgressView alloc]
            initWithProgressViewStyle:UIProgressViewStyleDefault];
    _myPV.progressTintColor = [ UIColor greenColor ]; // OKな所の色
    _myPV.trackTintColor = [ UIColor redColor ]; // 背景色
    _myPV.frame = CGRectMake(10, 30, self.frame.size.width/2-20, 10);
    _myPV.progress = 1.0;
    CGAffineTransform t1 = CGAffineTransformMakeScale( 1.0f, 2.4f ); // 引き延ばす
    CGAffineTransform t2 = CGAffineTransformMakeRotation( -180.0f * M_PI / 180.0f ); // 回転(弄るなら左)
    _myPV.transform = CGAffineTransformConcat(t1, t2);
    [self addSubview:_myPV];
    
    // ラベルの設置
    _myLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, self.frame.size.width/2-20, 15)];
    _myLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _myLabel.textColor = [UIColor whiteColor];
    [self addSubview:_myLabel];
    
    // プログレスバー作成
    _enemyPV = [[UIProgressView alloc]
               initWithProgressViewStyle:UIProgressViewStyleDefault];
    _enemyPV.progressTintColor = [ UIColor greenColor ]; // OKな所の色
    _enemyPV.trackTintColor = [ UIColor redColor ]; // 背景色
    _enemyPV.frame = CGRectMake(self.center.x+10, 30, self.frame.size.width/2-20, 10);
    _enemyPV.progress = 1.0;
    _enemyPV.transform = CGAffineTransformMakeScale( 1.0f, 2.4f ); // 引き延ばす
    [self addSubview:_enemyPV];
    
    // ラベルの設置
    _enemyLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x+10, 40, self.frame.size.width/2-20, 15)];
    _enemyLabel.textAlignment = NSTextAlignmentRight;
    _enemyLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _enemyLabel.textColor = [UIColor whiteColor];
    [self addSubview:_enemyLabel];
}

@end
